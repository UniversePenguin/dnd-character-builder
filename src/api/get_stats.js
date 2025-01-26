function get_stats(character_name, level) {
    const query = `SELECT 
    m.id AS modifier_id,
    m.value,
    m.multiplier,
    m.start_level AS modifier_start,
    m.end_level AS modifier_end,
    modified_stat.name AS modified_stat_name,
    base_stat.name AS base_stat_name,
    s.name AS source_name,
    cs.start_level AS source_start,
    cs.end_level AS source_end
    FROM modifiers m
    JOIN stats modified_stat ON m.modified_stat = modified_stat.id
    LEFT JOIN stats base_stat ON m.base_stat = base_stat.id
    JOIN sources s ON m.source_id = s.id
    JOIN character_source cs ON s.id = cs.source_id
    WHERE cs.character_id = (SELECT id FROM characters WHERE name = "${character_name}")
    AND m.start_level <= ${level} AND (m.end_level IS NULL OR m.end_level >= ${level})
    AND cs.start_level <= ${level} AND (cs.end_level IS NULL OR cs.end_level >= ${level})`;

    const result = resultsToJSON(db.exec(query)[0]);

    const statCache = new Map();

    const uniqueStats = [...new Set(result.map((x) => x.modified_stat_name))];

    const calcStat = (stat_name) => {
        if (!stat_name) return 0;

        const relevantModifiers = result.filter(
            (x) => x.modified_stat_name === stat_name
        );

        if (statCache.has(stat_name)) return statCache.get(stat_name);

        const total = relevantModifiers.reduce((agg, val) => {
            return (
                agg +
                Math.floor(
                    val.multiplier * (val.value + calcStat(val.base_stat_name))
                )
            );
        }, 0);

        statCache.set(stat_name, total);

        return total;
    };

    for (const stat of uniqueStats) {
        calcStat(stat);
    }

    return statCache;
}
