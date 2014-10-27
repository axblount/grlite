require 'grlite/edge'

module GRLite
    class Node
        attr_reader :graph, :id

        def initialize(graph, id=nil)
            @graph = graph
            if id.nil?
                create
            elsif exists?(id)
                @id = id
            else
                raise "A node with that id doesn't exist."
            end
        end

        include Comparable
        def <=>(other)
            @id <=> other.id
        end

        def create
            @graph.db.execute(<<-SQL)
                INSERT INTO grlite_nodes
                DEFAULT VALUES
            SQL
            @id = @graph.db.last_insert_row_id
        end

        def exists?
            1 == @graph.db.get_first_value(<<-SQL, :id => @id)
                SELECT COUNT(*) FROM grlite_nodes WHERE id = :id
            SQL
        end

        def delete!; raise 'TODO' end

        def <<(rel); InEdge.new(@graph, self, @graph.rel(rel)) end
        def >>(rel); OutEdge.new(@graph, self, @graph.rel(rel)) end

        def is?(rel, node)
            if not rel.is_a? Rel
                rel = @graph.rel(rel)
            end
            1 <= @graph.db.get_first_value(<<-SQL, :src => @id, :dest => node.id, :rel_id => rel.id)
                SELECT COUNT(*)
                FROM grlite_edges
                WHERE source_node_id = :src
                  AND destination_node_id = :dest
                  AND relation_id = :rel_id
            SQL
        end
    end
end
