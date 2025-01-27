let db;
(async () => {
    const initSqlJs = window.initSqlJs;

    const SQL = await initSqlJs({
        // Required to load the wasm binary asynchronously. Of course, you can host it wherever you want
        // You can omit locateFile completely when running in node
        locateFile: (file) => `./assets/wasm/${file}`,
    });

    // Create a database
    db = new SQL.Database();

    const executeFile = async (filename) => {
        console.log(`Executing ${filename}...`);
        const text = await (await fetch(filename)).text();
        db.run(text);
    };

    await executeFile("./src/queries/schema.sql"); // Initialize tables

    await executeFile("./src/queries/rules/universals.sql"); // Initialize D&D rules

    await executeFile("./src/queries/rules/races_common.sql");

    await executeFile("./src/queries/rules/classes/sorcerer.sql");

    await executeFile("./src/queries/samples/elesyth.sql");
})(); /*.then(() => loadCharacter());*/

function loadCharacter() {
    const dropdown = document.getElementById("character-dropdown");
    const range = document.getElementById("character-level-range");

    const name = dropdown.value;
    const level = range.value;

    const result = get_stats(name, level);
    const loc = document.getElementById("result-location");
    loc.replaceChildren(mapToFourColumnTable(result));
}

function mapToFourColumnTable(map) {
    // Create a table element
    const table = document.createElement("table");

    // Create a table header with 4 columns
    const thead = document.createElement("thead");
    const headerRow = document.createElement("tr");

    ["Key 1", "Value 1", "Key 2", "Value 2"].forEach((text) => {
        const th = document.createElement("th");
        th.textContent = text;
        headerRow.appendChild(th);
    });

    thead.appendChild(headerRow);
    table.appendChild(thead);

    // Create a table body
    const tbody = document.createElement("tbody");
    const entries = Array.from(map.entries()); // Convert map to an array of [key, value] pairs

    for (let i = 0; i < entries.length; i += 2) {
        const row = document.createElement("tr");

        // Get two key-value pairs for the current row
        const pair1 = entries[i];
        const pair2 = entries[i + 1] || ["", ""]; // Fallback to empty cells if there's no second pair

        // Add the cells for the first key-value pair
        const key1Cell = document.createElement("td");
        key1Cell.textContent = pair1[0];
        const value1Cell = document.createElement("td");
        value1Cell.textContent = pair1[1];

        row.appendChild(key1Cell);
        row.appendChild(value1Cell);

        // Add the cells for the second key-value pair
        const key2Cell = document.createElement("td");
        key2Cell.textContent = pair2[0];
        const value2Cell = document.createElement("td");
        value2Cell.textContent = pair2[1];

        row.appendChild(key2Cell);
        row.appendChild(value2Cell);

        tbody.appendChild(row);
    }

    table.appendChild(tbody);

    return table;
}
