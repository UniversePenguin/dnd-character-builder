import { Database } from "bun:sqlite";

console.log(await Bun.file("./queries/init.sql").text());

const db = new Database("dnd.sqlite", { create: true });

db.query(await Bun.file("./queries/init.sql").text()).run();
db.query(await Bun.file("./queries/add_samples.sql").text()).run();
