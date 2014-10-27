require 'grlite/graph'

module GRLite
    class Rel
        attr_reader :name, :id
        def initialize(graph, name, id)
            @graph = graph
            @name = name.to_s
            @id = id
        end

        def to_s
            @name
        end
    end
end
