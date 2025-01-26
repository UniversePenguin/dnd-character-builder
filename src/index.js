let db;
(async () => {
    const initSqlJs = window.initSqlJs;

    const SQL = await initSqlJs({
        // Required to load the wasm binary asynchronously. Of course, you can host it wherever you want
        // You can omit locateFile completely when running in node
        locateFile: (file) =>
            `https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.12.0/${file}`,
    });

    // Create a database
    db = new SQL.Database();

    const executeFile = async (filename) => {
        console.log(`Executing ${filename}...`);
        const text = await (await fetch(filename)).text();
        db.run(text);
    };

    await executeFile("./src/queries/init.sql"); // Initialize tables

    await executeFile("./src/queries/rules/universals.sql"); // Initialize D&D rules

    await executeFile("./src/queries/rules/races_common.sql");

    await executeFile("./src/queries/rules/classes/sorcerer.sql");

    await executeFile("./src/queries/samples/elesyth.sql");
})().then(() => {
    const dropdown = document.getElementById("character-dropdown");

    loadCharacter(dropdown.value);
});

function loadCharacter() {
    const dropdown = document.getElementById("character-dropdown");
    const range = document.getElementById("character-level-range");

    const name = dropdown.value;
    const level = range.value;

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
    WHERE cs.character_id = (SELECT id FROM characters WHERE name = "${name}")
    AND m.start_level <= ${level} AND (m.end_level IS NULL OR m.end_level >= ${level})
    AND cs.start_level <= ${level} AND (cs.end_level IS NULL OR cs.end_level >= ${level})`;

    const result = resultsToJSON(db.exec(query)[0]);

    const loc = document.getElementById("result-location");

    loc.replaceChildren(resultsToTable(result));
}

function resultsToTable(data) {
    if (!Array.isArray(data) || data.length === 0) {
        const noDataMessage = document.createElement("p");
        noDataMessage.textContent = "No data available";
        return noDataMessage;
    }

    // Extract the headers from the object keys
    const headers = Object.keys(data[0]);

    // Create the table element
    const table = document.createElement("table");

    // Create the header row
    const thead = document.createElement("thead");
    const headerRow = document.createElement("tr");
    headers.forEach((header) => {
        const th = document.createElement("th");
        th.textContent = header;
        headerRow.appendChild(th);
    });
    thead.appendChild(headerRow);
    table.appendChild(thead);

    // Create the body rows
    const tbody = document.createElement("tbody");
    data.forEach((row) => {
        const tr = document.createElement("tr");
        headers.forEach((header) => {
            const td = document.createElement("td");
            td.textContent = row[header] ?? "";
            tr.appendChild(td);
        });
        tbody.appendChild(tr);
    });
    table.appendChild(tbody);

    return table;
}
