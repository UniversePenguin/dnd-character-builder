PRAGMA foreign_keys = ON;

CREATE TABLE characters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE source_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
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

CREATE TABLE traits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,

    source_id INTEGER NOT NULL,

    FOREIGN KEY (source_id) REFERENCES sources(id)
);

CREATE TABLE allocations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    total_points INTEGER,

    type_id INTEGER NOT NULL,
    FOREIGN KEY (type_id) REFERENCES source_types(id)
);

CREATE TABLE character_allocation (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    start_level INTEGER NOT NULL DEFAULT 0,
    end_level INTEGER,

    character_id INTEGER NOT NULL,
    allocation_id INTEGER NOT NULL,

    FOREIGN KEY (character_id) REFERENCES characters(id),
    FOREIGN KEY (allocation_id) REFERENCES allocations(id)
);

CREATE TABLE buyables (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    change INTEGER NOT NULL,
    cost INTEGER,

    allocation_id INTEGER NOT NULL,
    stat_id INTEGER NOT NULL,

    FOREIGN KEY (allocation_id) REFERENCES allocations(id),
    FOREIGN KEY (stat_id) REFERENCES stats(id)
);

CREATE TABLE buyable_selections (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ca_id INTEGER NOT NULL,
    buyable_id INTEGER NOT NULL,

    FOREIGN KEY (ca_id) REFERENCES character_allocation(id),
    FOREIGN KEY (buyable_id) REFERENCES buyables(id)
);

CREATE VIEW full_modifier_info AS
SELECT 
    cs.id AS character_source_id,
    cs.start_level AS character_source_start_level,
    cs.end_level AS character_source_end_level,
    s.id AS source_id,
    s.name AS source_name,
    c.id AS character_id,
    c.name AS character_name,
    m.id AS modifier_id,
    m.value AS value,
    m.multiplier AS multiplier,
    m.start_level AS modifier_start_level,
    m.end_level AS modifier_end_level,
    m.optional_flag AS optional_flag,
    mstat.id AS modified_stat_id,
    mstat.name AS modified_stat_name,
    bstat.id AS base_stat_id,
    bstat.name AS base_stat_name,
    sel.id AS selection_id
FROM character_source cs
JOIN sources s ON cs.source_id = s.id
JOIN characters c ON cs.character_id = c.id
RIGHT JOIN modifiers m ON m.source_id = s.id
LEFT JOIN stats mstat ON mstat.id = m.modified_stat
LEFT JOIN stats bstat ON bstat.id = m.base_stat
LEFT JOIN character_selections sel ON sel.modifier_id = m.id;

CREATE VIEW character_source_names AS
SELECT 
    cs.id AS character_source_id,
    c.id AS character_id,
    s.id AS source_id,
    c.name AS character_name,
    s.name AS source_name
FROM character_source cs
JOIN characters c ON c.id = cs.character_id
JOIN sources s ON s.id = cs.source_id;

CREATE VIEW modifier_names AS
SELECT
    m.id AS modifier_id,
    s.id AS source_id,
    s.name AS source_name,
    mstat.id AS modified_stat_id,
    mstat.name AS modified_stat_name,
    bstat.id AS base_stat_id,
    mstat.name AS modified_stat_name
FROM modifiers m
JOIN sources s ON s.id = m.source_id
LEFT JOIN stats mstat ON m.modified_stat = mstat.id
LEFT JOIN stats bstat ON m.base_stat = bstat.id;

CREATE VIEW character_allocation_names AS
SELECT
    ca.id AS character_allocation_id,
    c.id AS character_id,
    a.id AS allocation_id,
    c.name AS character_name,
    a.name AS allocation_name
FROM character_allocation ca
JOIN characters c ON c.id = ca.character_id
JOIN allocations a ON a.id = ca.allocation_id;

CREATE VIEW buyable_names AS
SELECT
    b.id AS buyable_id,
    b.cost AS cost,
    b.change AS change,
    a.id AS allocation_id,
    a.name AS allocation_name,
    s.id AS stat_id,
    s.name AS stat_name
FROM buyables b
LEFT JOIN allocations a ON b.allocation_id = a.id
LEFT JOIN stats s ON b.stat_id = s.id;

CREATE VIEW full_buyable_info AS
SELECT
    ca.id AS character_allocation_id,
    ca.start_level AS character_allocation_start_level,
    ca.end_level AS character_allocation_end_level,
    a.id AS allocation_id,
    a.name AS allocation_name,
    c.id AS character_id,
    c.name AS character_name,
    b.id AS buyable_id,
    b.change AS buyable_change,
    s.id AS stat_id,
    s.name AS stat_name,
    bs.id AS selection_id
FROM character_allocation ca
JOIN characters c ON c.id = ca.character_id
JOIN allocations a ON a.id = ca.allocation_id
RIGHT JOIN buyable_selections bs ON bs.ca_id = ca.id
JOIN buyables b ON b.id = bs.buyable_id
JOIN stats s ON s.id = b.stat_id;

CREATE VIEW all_character_modifiers AS
SELECT * FROM full_modifier_info
UNION
SELECT
    b.character_allocation_id,
    b.character_allocation_start_level,
    b.character_allocation_end_level,
    b.allocation_id,
    b.allocation_name,
    b.character_id,
    b.character_name,
    b.buyable_id,
    b.buyable_change,
    1, 0, NULL, 0,
    b.stat_id,
    b.stat_name,
    NULL, NULL,
    b.selection_id
FROM full_buyable_info b