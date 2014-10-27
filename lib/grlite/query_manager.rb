require 'sqlite3'

class SQLite3::Statement
    def get_first_row(*bind_vars)
        self.execute(*bind_vars) { |results| return reults.next() }
    end

    def get_first_value(*bind_vars)
        self.execute(*bind_vars) { |results| return results.next()[0] }
    end
end

module GRLite
    class QueryManager
        def initialize(db)
            @db = db
            @queries = {
                :last_id => @db.prepare('SELECT last_insert_rowid()')
            }
        end

        def last_id
            @queries[:last_id].get_first_value
        end

        def [](query)
            unless @queries.has_key?(query)
                @queries[query] = @db.prepare(query)
            end
            return @queries[query]
        end
    end
end
