-- Tiefling
INSERT INTO sources (name, type_id)
VALUES ("Tiefling", (SELECT id FROM source_types WHERE label = "Race"));

INSERT INTO modifiers (value, modified_stat, source_id)
VALUES
    (2, (SELECT id FROM stats WHERE name = "Charisma Ability Score"), (SELECT id FROM sources WHERE name = "Tiefling")),
    (30, (SELECT id FROM stats WHERE name = "Walking Speed"), (SELECT id FROM sources WHERE name = "Tiefling"));

-- Tiefling Subraces
INSERT INTO sources (name, required_source, type_id)
VALUES ("Bloodline of Asmodeus", (SELECT id FROM sources WHERE name = "Tiefling"), (SELECT id FROM source_types WHERE label = "Race"));

INSERT INTO modifiers (value, modified_stat, source_id)
VALUES
    (1, (SELECT id FROM stats WHERE name = "Intelligence Ability Score"), (SELECT id FROM sources WHERE name = "Bloodline of Asmodeus"));