module GRLite
    class Edge
        attr_reader :graph, :id

        def initialize(graph, src, rel, dest)
            @graph = graph
            @graph.db.execute(<<-SQL, :src => src.id, :rel => rel, :dest => dest.id)
                INSERT INTO grlite_edges(
                    source_node_id,
                    destination_node_id,
                    relation_id)
                VALUES (:src, :dest, :rel)
            SQL
            @id = @graph.db.last_insert_row_id
        end

        include Comparable
        def <=>(other)
            @id <=> other.id
        end

        def delete!; raise "TODO" end
    end

    # Reperesents an incomplete edge. Internal use only.
    #
    # This shouldn't be instantiated directly, use one of it's subclasses
    # InEdge, OutEdge, or DualEdge
    class PartialEdge #:nodoc: all
        def initialize(graph, node, rel)
            @graph = graph
            @rel = rel
            @node = node
        end
    end

    class InEdge < PartialEdge #:nodoc: all
        def <<(source); Edge.new(@graph, source, @rel, @node) end
        def >>(_); raise "use << to complete an incoming edge" end
        def *(_); raise "use << to complete an incoming edge" end
    end

    class OutEdge < PartialEdge #:nodoc: all
        def >>(dest); Edge.new(@graph, @node, @rel, dest) end
        def <<(_); raise "use >> to complete an outgoing edge" end
        def *(_); raise "use >> to complete an outgoing edge" end
    end

    class BiEdge < PartialEdge #:nodoc: all
        def <<(_); raise "use ** to complete an bidirectional edge" end
        def >>(_); raise "use ** to complete an bidirectional edge" end
        def *(other)
            a = Edge.new(@graph, @node, @rel, other)
            b = Edge.new(@graph, other, @rel, @node)
            return a, b
        end
    end
end
