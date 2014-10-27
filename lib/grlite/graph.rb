require 'sqlite3'
require 'grlite/schema'
require 'grlite/node'
require 'grlite/rel'

module GRLite
    class Graph
        attr_reader :db

        def initialize(file=':memory:', options={})
            @file = file
            @db = SQLite3::Database.new(@file)
            @db.execute('PRAGMA foreign_keys = ON')
            @db.type_translation = true
            create_schema unless schema_exists?
        end

        def create_schema
            @db.transaction { |t| t.execute_batch(GRLite::SCHEMA) }
        end

        def schema_exists?
            1 == @db.get_first_value(<<-SQL)
                SELECT COUNT(*)
                FROM sqlite_master
                WHERE type = 'table'
                  AND name = 'grlite_master'
            SQL
        end

        def create_node
            Node.new(self)
        end

        # ensures that the given relation is in the
        # relations table and returns its id
        # name will likely be a symbol
        def rel(name)
            id = @db.get_first_value(<<-SQL, :name => name.to_s)
                SELECT id
                FROM grlite_relations
                WHERE name = :name
            SQL
            if id == nil
                @db.execute(<<-SQL, :name => name.to_s)
                    INSERT INTO grlite_relations(name)
                    VALUES (:name)
                SQL
                id = @db.last_insert_row_id
            end
            return Rel.new(self, name, id)
        end

        def close
            @db.close
        end
    end
end

