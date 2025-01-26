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

function loadCharacter(name) {
    const query = `SELECT 
    m.id AS modifier_id,
    m.value,
    m.multiplier,
    m.start_level,
    m.end_level,
    modified_stat.name AS modified_stat_name,
    base_stat.name AS base_stat_name,
    s.name AS source_name
FROM modifiers m
JOIN stats modified_stat ON m.modified_stat = modified_stat.id
LEFT JOIN stats base_stat ON m.base_stat = base_stat.id
JOIN sources s ON m.source_id = s.id
JOIN character_source cs ON s.id = cs.source_id
WHERE cs.character_id = (SELECT id FROM characters WHERE name = "${name}") -- Replace ? with the specific character ID`;

    document.body.appendChild(arrayToTable(db.exec(query)[0].values));

    console.log(db.exec(query));
}

function arrayToTable(data) {
    const table = document.createElement("table");
    table.classList.add("data-table");

    // Create table body
    const tbody = document.createElement("tbody");
    data.forEach((row) => {
        const tr = document.createElement("tr");
        row.forEach((cell) => {
            const td = document.createElement("td");
            td.textContent = cell;
            tr.appendChild(td);
        });
        tbody.appendChild(tr);
    });

    table.appendChild(tbody);
    return table;
}
