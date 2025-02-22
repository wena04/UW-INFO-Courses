const fs = require("fs").promises;
const express = require("express");
const { emitWarning } = require("process");
const path = require("path");
const app = express();

const wwwrootdir = "wwwroot";

app.get("*", async (req, res) => {
  let path = req.path;
  if (path == "/") {
    path = "/index.html";
  }

  let filedata = await fs.readFile(wwwrootdir + path);

  if (path.endsWith(".html")) {
    res.type("html");
  } else if (path.endsWith(".css")) {
    res.type("css");
  } else if (path.endsWith(".js")) {
    res.type("js");
  } else if (path.endsWith(".txt")) {
    res.type("txt");
  }

  res.send(filedata);
});

app.listen(3000, "localhost", () => {
  console.log("Example app listening at http://localhost:3000");
});
