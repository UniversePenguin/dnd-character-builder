INSERT INTO sources (name, type_id)
VALUES ("Sorcerer", (SELECT id FROM source_types WHERE label = "Class"));

INSERT INTO stats (name)
VALUES ("Spells Known"), ("Sorcery Points");

-- Sorcery points
WITH 
    sorcery_points_stat_id AS (SELECT id FROM stats WHERE name = "Sorcery Points"),
    sorcerer_source_id AS (SELECT id FROM sources WHERE name = "Sorcerer")
INSERT INTO modifiers (value, start_level, modified_stat, source_id)
SELECT 
    1, 
    level, 
    (SELECT * FROM sorcery_points_stat_id), 
    (SELECT * FROM sorcerer_source_id)
FROM (SELECT level FROM (WITH RECURSIVE
    levels(level) AS (
        VALUES(2)
        UNION ALL
        SELECT level + 1 FROM levels WHERE level < 20
    )
    SELECT level FROM levels
))
UNION ALL
VALUES
    (0, 0, (SELECT * FROM sorcery_points_stat_id), (SELECT * FROM sorcerer_source_id)),
    (1, 2, (SELECT * FROM sorcery_points_stat_id), (SELECT * FROM sorcerer_source_id));

-- Known spells
WITH
    known_spells_stat_id AS (SELECT id FROM stats WHERE name = "Spells Known"),
    sorcerer_source_id AS (SELECT id FROM sources WHERE name = "Sorcerer"),
    increase_levels(level) AS (
        VALUES
        (0),(1),(2),(3),(4),
        (5),(6),(7),(8),(9),
        (10),(11),(13),(15),(17)
    )
INSERT INTO modifiers (value, start_level, modified_stat, source_id)
SELECT
    1,
    increase_levels.level,
    (SELECT * FROM known_spells_stat_id),
    (SELECT * FROM sorcerer_source_id)
FROM increase_levels;

-- Saving throws
INSERT INTO modifiers (modified_stat, base_stat, source_id)
VALUES
    ((SELECT id FROM stats WHERE name = "Constitution Saving Throw"), (SELECT id FROM stats WHERE name = "Proficiency Bonus"), (SELECT id FROM sources WHERE name = "Sorcerer")),
    ((SELECT id FROM stats WHERE name = "Charisma Saving Throw"), (SELECT id FROM stats WHERE name = "Proficiency Bonus"), (SELECT id FROM sources WHERE name = "Sorcerer"));

-- Spellcasting
INSERT INTO modifiers (value, modified_stat, base_stat, source_id)
VALUES
    (8, (SELECT id FROM stats WHERE name = "Spell Save DC"), (SELECT id FROM stats WHERE name = "Proficiency Bonus"), (SELECT id FROM sources WHERE name = "Sorcerer")),
    (0, (SELECT id FROM stats WHERE name = "Spell Save DC"), (SELECT id FROM stats WHERE name = "Charisma Modifier"), (SELECT id FROM sources WHERE name = "Sorcerer")),
    (0, (SELECT id FROM stats WHERE name = "Spell Attack Modifier"), (SELECT id FROM stats WHERE name = "Proficiency Bonus"), (SELECT id FROM sources WHERE name = "Sorcerer")),
    (0, (SELECT id FROM stats WHERE name = "Spell Attack Modifier"), (SELECT id FROM stats WHERE name = "Charisma Modifier"), (SELECT id FROM sources WHERE name = "Sorcerer"));