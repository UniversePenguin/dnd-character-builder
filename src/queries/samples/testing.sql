INSERT INTO characters (name)
VALUES
    ("Elesyth"),
    ("Mafi"),
    ("Elora"),
    ("Vala"),
    ("$o-lil' oqueef"),
    ("Draven");

INSERT INTO character_source (start_level, character_id, source_id)
VALUES
    (0, (SELECT id FROM characters WHERE name = "Vala"), (SELECT id FROM sources WHERE name = "Base Ability Scores"));