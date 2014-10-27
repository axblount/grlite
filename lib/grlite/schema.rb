require 'grlite/version'

module GRLite
    SCHEMA = <<-SQL
        CREATE TABLE grlite_master (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
        );

        INSERT INTO grlite_master (key, value)
        VALUES ('VERSION', '#{GRLite::VERSION}');

        CREATE TABLE grlite_relations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE NOT NULL
        );

        /***********/
        /*** NODES */
        /***********/

        CREATE TABLE grlite_nodes (
            id INTEGER PRIMARY KEY AUTOINCREMENT
        );

        /***********/
        /*** EDGES */
        /***********/

        CREATE TABLE grlite_edges (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            source_node_id INTEGER NOT NULL
                REFERENCES grlite_nodes(id),
            destination_node_id INTEGER NOT NULL
                REFERENCES grlite_nodes(id),
            relation_id INTEGER NOT NULL
                REFERENCES grlite_relations(id)
        );
    SQL
end

__END__

CREATE TABLE grlite_master (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

INSERT INTO grlite_master (key, value)
VALUES ('VERSION', '0.0.0');

CREATE TABLE grlite_relations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL
);

/***********/
/*** NODES */
/***********/

CREATE TABLE grlite_nodes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
);

/***********/
/*** EDGES */
/***********/

CREATE TABLE grlite_edges (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_node_id INTEGER NOT NULL REFERENCES grlite_nodes(id),
    destination_node_id INTEGER NOT NULL REFERENCES grlite_nodes(id),
    relationship_id INTEGER NOT NULL REFERENCES grlite_relationships(id)
);


/****************/
/*** HYPEREDGES */
/****************/
/*
CREATE TABLE grlite_hyperedges (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    relationship_id INTEGER NOT NULL REFERENCES grlite_relationships(id)
);

CREATE TABLE grlite_hyperedge_links (
    node_id INTEGER NOT NULL REFERENCES grlite_nodes(id),
    hyperedge_id INTEGER NOT NULL REFERENCES grlite_hyperedges(id),
    relationship_id INTEGER REFERENCES grlite_relationships(id),

    PRIMARY KEY (node_id, hyperedge_id, relationship_id)
);
*/

/**************/
/*** AUX DATA */
/**************/
/*
CREATE TABLE grlite_node_data (
    node_id INTEGER NOT NULL REFERENCES grlite_nodes(id),
    key TEXT NOT NULL,
    value TEXT NOT NULL,

    PRIMARY KEY (node_id, key)
);

CREATE TABLE grlite_edge_data (
    edge_id INTEGER NOT NULL REFERENCES grlite_edges(id),
    key TEXT NOT NULL,
    value TEXT NOT NULL,

    PRIMARY KEY (edge_id, key)
);

CREATE TABLE grlite_hyperedge_data (
    hyperedge_id INTEGER NOT NULL REFERENCES grlite_hyperedges(id),
    key TEXT NOT NULL,
    value TEXT NOT NULL,

    PRIMARY KEY (hyperedge_id, key)
);
*/

/***********************/
/*** POTENTIAL INDEXES */
/***********************/

/*
CREATE INDEX idx_grlite_node_data_key
ON grlite_node_data(key);

CREATE INDEX idx_grlite_edges_forward
ON grlite_edges(source_node_id, destination_node_id);

CREATE INDEX idx_grlite_edges_backward
ON grlite_edges(destination_node_id, source_node_id);

CREATE INDEX idx_grlite_edge_data_key
ON grlite_edge_data(key);

CREATE INDEX idx_grlite_hyperedge_links_backward
ON grlite_hyperedge_links(hyperedge_id, node_id);

CREATE INDEX idx_grlite_hyperedge_data_key
ON grlite_hyperedge_data(key);
*/

