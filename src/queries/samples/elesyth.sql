INSERT INTO characters (name)
VALUES
    ("Elesyth");

WITH sources_to_connect AS (
    SELECT s.id
    FROM sources s
    JOIN source_types st ON s.type_id = st.id
    WHERE st.name = "Universal Rule"
    UNION SELECT id FROM sources WHERE name ="Tiefling"OR name = "Bloodline of Asmodeus" OR name = "Sorcerer"),
    elesyth_id AS (SELECT id FROM characters WHERE name = "Elesyth")
INSERT INTO character_source (character_id, source_id)
SELECT * FROM elesyth_id
JOIN sources_to_connect;

-- Sorcerer proficiencies
INSERT INTO character_selections (cs_id, modifier_id)
VALUES
    (
        (SELECT character_source_id FROM character_source_names WHERE character_name = "Elesyth" AND source_name = "Sorcerer"),
        (SELECT modifier_id FROM modifier_names WHERE modified_stat_name = "Arcana Modifier" AND source_name = "Sorcerer")
    );

WITH allocations_to_connect AS (
    SELECT a.id
    FROM allocations a
    JOIN source_types st ON a.type_id = st.id
    WHERE st.name = "Universal Rule"),
    elesyth_id AS (SELECT id FROM characters WHERE name = "Elesyth")
INSERT INTO character_allocation (character_id, allocation_id)
SELECT * FROM elesyth_id
JOIN allocations_to_connect;

-- Point buy
INSERT INTO buyable_selections (ca_id, buyable_id)
VALUES
    (
        (SELECT character_allocation_id FROM character_allocation_names WHERE character_name = "Elesyth" AND allocation_name = "Point Buy"),
        (SELECT buyable_id FROM buyable_names WHERE change = 7 AND allocation_name = "Point Buy" AND stat_name = "Charisma Ability Score")
    ),
    (
        (SELECT character_allocation_id FROM character_allocation_names WHERE character_name = "Elesyth" AND allocation_name = "Point Buy"),
        (SELECT buyable_id FROM buyable_names WHERE change = 7 AND allocation_name = "Point Buy" AND stat_name = "Intelligence Ability Score")
    ),
    (
        (SELECT character_allocation_id FROM character_allocation_names WHERE character_name = "Elesyth" AND allocation_name = "Point Buy"),
        (SELECT buyable_id FROM buyable_names WHERE change = 5 AND allocation_name = "Point Buy" AND stat_name = "Constitution Ability Score")
    );

-- Health Selections
-- WITH health_increase_buyables AS (
--     SELECT 
--         * 
--     FROM buyables b
--     JOIN allocations a ON a.id = b.allocation_id
--     WHERE a.name = "Health Increases"
-- )
-- INSERT INTO buyable_selections (ca_id, buyable_id)
-- VALUES
--     ()