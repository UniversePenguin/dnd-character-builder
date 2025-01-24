import { Database } from "bun:sqlite";

async function executeFile(db: Database, filepath: string) {
    const text = await Bun.file(filepath).text();

    for (const query of text
        .split(";")
        .map((x) => x.trim())
        .filter((x) => !x.startsWith("--"))
        .filter((x) => x.length > 0)) {
        db.run(query);
    }

    return;
}

const db = new Database("dnd.sqlite", { create: true });

await executeFile(db, "./queries/init.sql");
await executeFile(db, "./queries/add_samples.sql");

db.close();
