require 'test/unit'
require 'grlite'

class GRLiteUnitTests < Test::Unit::TestCase
    def setup
        @graph = GRLite::Graph.new()
    end

    def teardown
        @graph.close
    end

    def test_create_node
        x = @graph.create_node
    end

    def test_directed_edges
        a = @graph.create_node
        b = @graph.create_node
        c = @graph.create_node

        a << :friend >> b
        b << :friend << c
        a >> :enemy >> c

        assert(a.is?(:friend, b))
        assert(b.is?(:friend, a))
        assert(c.is?(:friend, b))
        assert(a.is?(:enemy, c))
        assert(!a.is?(:friend, c))
        assert(!b.is?(:friend, c))
        assert(!c.is?(:enemy, a))
    end
end
