PRAGMA foreign_keys = ON;

CREATE TABLE characters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE source_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    label TEXT NOT NULL
);

CREATE TABLE sources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,

    type_id INTEGER NOT NULL,
    required_source INTEGER,

    FOREIGN KEY (type_id) REFERENCES source_types(id),
    FOREIGN KEY (required_source) REFERENCES sources(id)
);

CREATE TABLE character_source (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    start_level INTEGER NOT NULL DEFAULT 0,
    end_level INTEGER,

    character_id INTEGER NOT NULL,
    source_id INTEGER NOT NULL,

    FOREIGN KEY (character_id) REFERENCES characters(id),
    FOREIGN KEY (source_id) REFERENCES sources(id)
);

CREATE TABLE stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE modifiers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    value INTEGER NOT NULL DEFAULT 0,
    multiplier INTEGER NOT NULL DEFAULT 1,
    start_level INTEGER NOT NULL DEFAULT 0,
    end_level INTEGER,

    source_id INTEGER NOT NULL,
    modified_stat INTEGER NOT NULL,
    base_stat INTEGER,

    FOREIGN KEY (source_id) REFERENCES sources(id),
    FOREIGN KEY (modified_stat) REFERENCES stats(id),
    FOREIGN KEY (base_stat) REFERENCES stats(id)
);