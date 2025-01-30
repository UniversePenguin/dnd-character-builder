function get_stats(character_name, level) {
    const query = `
    SELECT * FROM full_modifier_info
    WHERE character_name = "${character_name}"
    AND modifier_start_level <= ${level} 
    AND (modifier_end_level IS NULL OR modifier_end_level >= ${level})
    AND character_source_start_level <= ${level} 
    AND (character_source_end_level IS NULL OR character_source_end_level >= ${level})
    AND (optional_flag = 0 OR selection_id IS NOT NULL)`;

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
