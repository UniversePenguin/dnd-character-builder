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

    FOREIGN KEY (type_id) REFERENCES source_types(id)
);

CREATE TABLE character_source (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    start_level INTEGER NOT NULL,
    end_level INTEGER,

    character_id INTEGER NOT NULL,
    source_id INTEGER NOT NULL,

    FOREIGN KEY (character_id) REFERENCES characters(id),
    FOREIGN KEY (source_id) REFERENCES sources(id)
);

CREATE TABLE stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE modifiers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    value INTEGER NOT NULL,
    multiplier INTEGER NOT NULL,
    start_level INTEGER NOT NULL,
    end_level INTEGER,

    source_id INTEGER NOT NULL,
    modified_stat INTEGER NOT NULL,
    base_stat INTEGER,

    FOREIGN KEY (source_id) REFERENCES sources(id),
    FOREIGN KEY (modified_stat) REFERENCES stats(id),
    FOREIGN KEY (base_stat) REFERENCES stats(id)
);