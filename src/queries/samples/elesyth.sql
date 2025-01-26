INSERT INTO characters (name)
VALUES
    ("Elesyth");

WITH sources_to_connect AS (
    SELECT s.id
    FROM sources s
    JOIN source_types st ON s.type_id = st.id
    WHERE st.label = "Universal Rule"
    UNION SELECT id FROM sources WHERE name ="Tiefling"OR name = "Bloodline of Asmodeus" OR name = "Sorcerer"),
    elesyth_id AS (SELECT id FROM characters WHERE name = "Elesyth")
INSERT INTO character_source (character_id, source_id)
SELECT * FROM elesyth_id
JOIN sources_to_connect