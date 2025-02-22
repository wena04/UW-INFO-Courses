const express = require("express");
const { emitWarning } = require("process");
const path = require("path");
const app = express();

const wwwrootdir = "wwwroot";

app.get("*", (req, res) => {
  let path = req.path;
  if (path == "/") {
    path = "/index.html";
  }

  res.sendFile(process.cwd() + "/" + wwwrootdir + path);
});

app.listen(3000, "localhost", () => {
  console.log("Example app listening at http://localhost:3000");
});
