INSERT INTO source_types (label)
VALUES
    ("Race"),
    ("Class"),
    ("Feat"),
    ("Background"),
    ("Item"),
    ("Ability Score Increase"),
    ("Universal Rule");

-- Insert Basic Ability Scores & Modifiers
INSERT INTO stats (name)
VALUES
    ("Strength Ability Score"),
    ("Dexterity Ability Score"),
    ("Constitution Ability Score"),
    ("Intelligence Ability Score"),
    ("Wisdom Ability Score"),
    ("Charisma Ability Score"),
    ("Strength Modifier"),
    ("Dexterity Modifier"),
    ("Constitution Modifier"),
    ("Intelligence Modifier"),
    ("Wisdom Modifier"),
    ("Charisma Modifier");

INSERT INTO stats (name)
VALUES
    ("Proficiency Bonus");

-- Create sources for various intrinsic rules
INSERT INTO sources (name, type_id)
VALUES
    ("Base Ability Scores", (SELECT id FROM source_types WHERE label = "Universal Rule")),
    ("Proficiency Bonus", (SELECT id FROM source_types WHERE label = "Universal Rule")),
    ("Ability Score Modifiers", (SELECT id FROM source_types WHERE label = "Universal Rule"));

INSERT INTO modifiers (value, multiplier, start_level, source_id, modified_stat)
VALUES
    (8, 1, 0, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Strength Ability Score")),
    (8, 1, 0, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Dexterity Ability Score")),
    (8, 1, 0, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Constitution Ability Score")),
    (8, 1, 0, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Intelligence Ability Score")),
    (8, 1, 0, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Wisdom Ability Score")),
    (8, 1, 0, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Charisma Ability Score"));

INSERT INTO modifiers (value, multiplier, start_level, source_id, modified_stat, base_stat)
VALUES
    (-10, 0.5, 0, (SELECT id FROM sources WHERE name = "Ability Score Modifiers"), (SELECT id FROM stats WHERE name = "Strength Modifier"), (SELECT id FROM stats WHERE name = "Strength Ability Score")),
    (-10, 0.5, 0, (SELECT id FROM sources WHERE name = "Ability Score Modifiers"), (SELECT id FROM stats WHERE name = "Dexterity Modifier"), (SELECT id FROM stats WHERE name = "Dexterity Ability Score")),
    (-10, 0.5, 0, (SELECT id FROM sources WHERE name = "Ability Score Modifiers"), (SELECT id FROM stats WHERE name = "Constitution Modifier"), (SELECT id FROM stats WHERE name = "Constitution Ability Score")),
    (-10, 0.5, 0, (SELECT id FROM sources WHERE name = "Ability Score Modifiers"), (SELECT id FROM stats WHERE name = "Intelligence Modifier"), (SELECT id FROM stats WHERE name = "Intelligence Ability Score")),
    (-10, 0.5, 0, (SELECT id FROM sources WHERE name = "Ability Score Modifiers"), (SELECT id FROM stats WHERE name = "Wisdom Modifier"), (SELECT id FROM stats WHERE name = "Wisdom Ability Score")),
    (-10, 0.5, 0, (SELECT id FROM sources WHERE name = "Ability Score Modifiers"), (SELECT id FROM stats WHERE name = "Charisma Modifier"), (SELECT id FROM stats WHERE name = "Charisma Ability Score"));

INSERT INTO modifiers (value, multiplier, start_level, end_level, source_id, modified_stat)
VALUES
    (2, 1, 1, 4, (SELECT id FROM sources WHERE name = "Proficiency Bonus"), (SELECT id FROM stats WHERE name = "Proficiency Bonus"));

INSERT INTO sources (name, type_id)
VALUES
    ("Dragonborn", (SELECT id FROM source_types WHERE label = 'Race'));

INSERT INTO modifiers (value, multiplier, start_level, source_id, modified_stat)
VALUES
    (2, 1, 0, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Strength Ability Score")),
    (1, 1, 0, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Charisma Ability Score"));