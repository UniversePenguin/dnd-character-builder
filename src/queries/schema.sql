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

    optional_modifiers INTEGER,
    optional_sources INTEGER,

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

CREATE TABLE stat_groups (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    group_id INTEGER,

    FOREIGN KEY (group_id) REFERENCES stat_groups(id)
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

    optional_flag INTEGER NOT NULL DEFAULT 0,

    FOREIGN KEY (source_id) REFERENCES sources(id),
    FOREIGN KEY (modified_stat) REFERENCES stats(id),
    FOREIGN KEY (base_stat) REFERENCES stats(id)
);

CREATE TABLE character_selections (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cs_id INTEGER NOT NULL,
    modifier_id INTEGER NOT NULL,

    FOREIGN KEY (cs_id) REFERENCES character_source(id),
    FOREIGN KEY (modifier_id) REFERENCES modifiers(id)
);