const fs = require("fs").promises;
const express = require("express");
const { emitWarning } = require("process");
const path = require("path");
const app = express();

const wwwrootdir = "wwwroot";

app.get("/", (req, res) => {
  res.redirect("/site/");
});

app.get("/site/*", (req, res) => {
  let path = req.path;
  path = path.substring(5);
  console.log(path);
  if (path == "/") {
    path = "/index.html";
  }

  res.sendFile(process.cwd() + "/" + wwwrootdir + path);
});

app.get("/api/animals", async (req, res) => {
  let queryparams = req.query;
  if (queryparams) {
    querystring = queryparams.animal;
  } else {
    querystring = "";
  }

  let files = await fs.readdir("wwwroot/imgs");

  let matchedFiles = files.filter((filename) => filename.includes(querystring));

  let matchedFilesWithImg = matchedFiles.map((filename) => "imgs/" + filename);

  res.send(matchedFilesWithImg.join("\n"));
});

app.listen(3000, () => {
  console.log("Example app listening at http://localhost:3000");
});
