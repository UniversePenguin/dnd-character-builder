PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS characters;
DROP TABLE IF EXISTS stat_types;
DROP TABLE IF EXISTS character_stats;

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS characters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    level INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS stat_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);
INSERT INTO stat_types (name)
VALUES
    ('strength'),
    ('dexterity'),
    ('constitution'),
    ('intelligence'),
    ('wisdom'),
    ('charisma');

CREATE TABLE IF NOT EXISTS character_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    modifier INTEGER,
    type INTEGER,
    character_id INTEGER,
    FOREIGN KEY (type) REFERENCES stat_types(id)
    FOREIGN KEY (character_id) REFERENCES characters(id)
);