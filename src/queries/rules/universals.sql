-- Insert Basic Ability Scores, Modifiers, and Saving Throws
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
    ("Charisma Modifier"),
    ("Strength Saving Throw"),
    ("Dexterity Saving Throw"),
    ("Constitution Saving Throw"),
    ("Intelligence Saving Throw"),
    ("Wisdom Saving Throw"),
    ("Charisma Saving Throw");

-- Add various universal stats
INSERT INTO stats (name)
VALUES
    ("Proficiency Bonus"),
    ("Armor Class"),
    ("Initiative"),
    ("Passive Perception"),
    ("Maximum HP"),
    ("Walking Speed"),
    ("Swimming Speed"),
    ("Flying Speed"),
    ("Climbing Speed");

-- Add skill modifiers
INSERT INTO stats (name)
VALUES
    ("Acrobatics Modifier"),
    ("Animal Handling Modifier"),
    ("Arcana Modifier"),
    ("Athletics Modifier"),
    ("Deception Modifier"),
    ("History Modifier"),
    ("Insight Modifier"),
    ("Intimidation Modifier"),
    ("Investigation Modifier"),
    ("Medicine Modifier"),
    ("Nature Modifier"),
    ("Perception Modifier"),
    ("Performance Modifier"),
    ("Persuasion Modifier"),
    ("Religion Modifier"),
    ("Sleight of Hand Modifier"),
    ("Stealth Modifier"),
    ("Survival Modifier");

-- Add spellcasting stats
INSERT INTO stats (name)
VALUES
    ("Spell Save DC"),
    ("Spell Attack Bonus"),
    ("Cantrips Known"),
    ("1st Level Spell Slots"),
    ("2nd Level Spell Slots"),
    ("3rd Level Spell Slots"),
    ("4th Level Spell Slots"),
    ("5th Level Spell Slots"),
    ("6th Level Spell Slots"),
    ("7th Level Spell Slots"),
    ("8th Level Spell Slots"),
    ("9th Level Spell Slots");

-- Add all possible source types
INSERT INTO source_types (label)
VALUES
    ("Race"),
    ("Class"),
    ("Feat"),
    ("Background"),
    ("Item"),
    ("Ability Score Increase"),
    ("Universal Rule");

-- Create sources for various intrinsic rules
INSERT INTO sources (name, type_id)
VALUES
    ("Base Ability Scores", (SELECT id FROM source_types WHERE label = "Universal Rule")),
    ("Proficiency Bonus", (SELECT id FROM source_types WHERE label = "Universal Rule")),
    ("Ability Score Modifier Translation", (SELECT id FROM source_types WHERE label = "Universal Rule")),
    ("Ability Modifier Bases", (SELECT id FROM source_types WHERE label = "Universal Rule"));

-- Add base ability scores
INSERT INTO modifiers (value, source_id, modified_stat)
VALUES
    (8, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Strength Ability Score")),
    (8, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Dexterity Ability Score")),
    (8, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Constitution Ability Score")),
    (8, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Intelligence Ability Score")),
    (8, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Wisdom Ability Score")),
    (8, (SELECT id FROM sources WHERE name = "Base Ability Scores"), (SELECT id FROM stats WHERE name = "Charisma Ability Score"));

-- Add translation from ability score to modifiers
INSERT INTO modifiers (value, multiplier, source_id, modified_stat, base_stat)
VALUES
    (-10, 0.5, (SELECT id FROM sources WHERE name = "Ability Score Modifier Translation"), (SELECT id FROM stats WHERE name = "Strength Modifier"), (SELECT id FROM stats WHERE name = "Strength Ability Score")),
    (-10, 0.5, (SELECT id FROM sources WHERE name = "Ability Score Modifier Translation"), (SELECT id FROM stats WHERE name = "Dexterity Modifier"), (SELECT id FROM stats WHERE name = "Dexterity Ability Score")),
    (-10, 0.5, (SELECT id FROM sources WHERE name = "Ability Score Modifier Translation"), (SELECT id FROM stats WHERE name = "Constitution Modifier"), (SELECT id FROM stats WHERE name = "Constitution Ability Score")),
    (-10, 0.5, (SELECT id FROM sources WHERE name = "Ability Score Modifier Translation"), (SELECT id FROM stats WHERE name = "Intelligence Modifier"), (SELECT id FROM stats WHERE name = "Intelligence Ability Score")),
    (-10, 0.5, (SELECT id FROM sources WHERE name = "Ability Score Modifier Translation"), (SELECT id FROM stats WHERE name = "Wisdom Modifier"), (SELECT id FROM stats WHERE name = "Wisdom Ability Score")),
    (-10, 0.5, (SELECT id FROM sources WHERE name = "Ability Score Modifier Translation"), (SELECT id FROM stats WHERE name = "Charisma Modifier"), (SELECT id FROM stats WHERE name = "Charisma Ability Score"));

-- Add proficiency bonuses for every level
INSERT INTO modifiers (value, start_level, end_level, source_id, modified_stat)
VALUES
    (2, 1, 4, (SELECT id FROM sources WHERE name = "Proficiency Bonus"), (SELECT id FROM stats WHERE name = "Proficiency Bonus")),
    (3, 5, 8, (SELECT id FROM sources WHERE name = "Proficiency Bonus"), (SELECT id FROM stats WHERE name = "Proficiency Bonus")),
    (4, 9, 12, (SELECT id FROM sources WHERE name = "Proficiency Bonus"), (SELECT id FROM stats WHERE name = "Proficiency Bonus")),
    (5, 13, 16, (SELECT id FROM sources WHERE name = "Proficiency Bonus"), (SELECT id FROM stats WHERE name = "Proficiency Bonus")),
    (6, 17, 20, (SELECT id FROM sources WHERE name = "Proficiency Bonus"), (SELECT id FROM stats WHERE name = "Proficiency Bonus"));

-- Add misc. modifiers
INSERT INTO modifiers (value, modified_stat, base_stat, source_id)
VALUES
    (0, (SELECT id FROM stats WHERE name = "Initiative"), (SELECT id FROM stats WHERE name = "Dexterity Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases")),
    (0, (SELECT id FROM stats WHERE name = "Passive Perception"), (SELECT id FROM stats WHERE name = "Perception Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases")),
    (10, (SELECT id FROM stats WHERE name = "Armor Class"), (SELECT id FROM stats WHERE name = "Dexterity Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases")),
    (8, (SELECT id FROM stats WHERE name = "Maximum HP"), (SELECT id FROM stats WHERE name = "Constitution Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases"));

-- Add saving throw bases
INSERT INTO modifiers (modified_stat, base_stat, source_id)
VALUES
    ((SELECT id FROM stats WHERE name = "Strength Saving Throw"), (SELECT id FROM stats WHERE name = "Strength Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases")),
    ((SELECT id FROM stats WHERE name = "Dexterity Saving Throw"), (SELECT id FROM stats WHERE name = "Dexterity Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases")),
    ((SELECT id FROM stats WHERE name = "Constitution Saving Throw"), (SELECT id FROM stats WHERE name = "Constitution Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases")),
    ((SELECT id FROM stats WHERE name = "Intelligence Saving Throw"), (SELECT id FROM stats WHERE name = "Intelligence Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases")),
    ((SELECT id FROM stats WHERE name = "Wisdom Saving Throw"), (SELECT id FROM stats WHERE name = "Wisdom Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases")),
    ((SELECT id FROM stats WHERE name = "Charisma Saving Throw"), (SELECT id FROM stats WHERE name = "Charisma Modifier"), (SELECT id FROM sources WHERE name = "Ability Modifier Bases"));
    
-- Add skill bases
WITH 
    ability_modifier_source_id AS (SELECT id FROM sources WHERE name = "Ability Modifier Bases"),
    modifier_mappings(modified_stat, base_stat) AS (
        VALUES
        ('Acrobatics Modifier', 'Dexterity Modifier'),
        ('Animal Handling Modifier', 'Wisdom Modifier'),
        ('Arcana Modifier', 'Intelligence Modifier'),
        ('Athletics Modifier', 'Strength Modifier'),
        ('Deception Modifier', 'Charisma Modifier'),
        ('History Modifier', 'Intelligence Modifier'),
        ('Insight Modifier', 'Wisdom Modifier'),
        ('Intimidation Modifier', 'Charisma Modifier'),
        ('Investigation Modifier', 'Intelligence Modifier'),
        ('Medicine Modifier', 'Wisdom Modifier'),
        ('Nature Modifier', 'Intelligence Modifier'),
        ('Perception Modifier', 'Wisdom Modifier'),
        ('Performance Modifier', 'Charisma Modifier'),
        ('Persuasion Modifier', 'Charisma Modifier'),
        ('Religion Modifier', 'Intelligence Modifier'),
        ('Sleight of Hand Modifier', 'Dexterity Modifier'),
        ('Stealth Modifier', 'Dexterity Modifier'),
        ('Survival Modifier', 'Wisdom Modifier')
    )
INSERT INTO modifiers (modified_stat, base_stat, source_id)
SELECT 
    (SELECT id FROM stats WHERE name = modified_stat),
    (SELECT id FROM stats WHERE name = base_stat),
    (SELECT * FROM ability_modifier_source_id)
FROM modifier_mappings;
