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

    let sqlstr =
        "CREATE TABLE hello (a int, b char); \
INSERT INTO hello VALUES (0, 'hello'); \
INSERT INTO hello VALUES (1, 'world');";
    db.run(sqlstr);

    console.log(db.exec("SELECT * FROM hello"));
})().then(() => console.log("done!"));
