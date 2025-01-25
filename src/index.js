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

    const initQuery = await (await fetch("./src/queries/init.sql")).text();

    db.run(initQuery);

    const rulesQuery = await (
        await fetch("./src/queries/dnd_rules.sql")
    ).text();

    db.run(rulesQuery);

    const sampleQuery = await (
        await fetch("./src/queries/samples/testing.sql")
    ).text();

    db.run(sampleQuery);

    // db.run(text);
})().then(() => console.log("done!"));
