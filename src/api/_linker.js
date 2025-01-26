const prefix = `./src/api/`;

const files = ["get_stats.js"];

files.forEach((file) => {
    const script = document.createElement("script");
    script.setAttribute("src", prefix + file);

    document.head.appendChild(script);
});
