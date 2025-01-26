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
})().then(() => console.log("done!"));

function saveUint8ArrayAsFile(
    data,
    filename = "dnd.bin",
    mimeType = "application/octet-stream"
) {
    // Create a Blob from the Uint8Array
    const blob = new Blob([data], { type: mimeType });

    // Create a temporary URL for the Blob
    const url = URL.createObjectURL(blob);

    // Create a temporary <a> element
    const link = document.createElement("a");
    link.href = url;
    link.download = filename;

    // Trigger the download
    document.body.appendChild(link); // Append the link to the body
    link.click(); // Simulate a click to trigger the download
    document.body.removeChild(link); // Remove the link

    // Revoke the URL to free up memory
    URL.revokeObjectURL(url);
}

function saveDB() {
    saveUint8ArrayAsFile(db.export());
}
