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

function resultsToJSON(results) {
    return results.values.map((x) => {
        const toPush = {};

        for (let i = 0; i < x.length; i++) {
            toPush[results.columns[i]] = x[i];
        }

        return toPush;
    });
}
