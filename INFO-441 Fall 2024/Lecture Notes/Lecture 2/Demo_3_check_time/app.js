import express from "express";
import { promises as fs } from "fs";

const app = express();

app.get("/", async (req, res) => {
  console.log("request to '/', sending back html");
  let fileContents = await fs.readFile("index.html");
  res.type("html");
  res.send(fileContents);
});

app.get("/style.css", async (req, res) => {
  console.log("request to '/style.css', sending back css content");
  let fileContents = await fs.readFile("style.css");
  res.type("css");
  res.send(fileContents);
});

app.get("/index.js", async (req, res) => {
  console.log("request to '/index.js', sending back css content");
  let fileContents = await fs.readFile("index.js");
  res.type("js");
  res.send(fileContents);
});

app.get("/api/getTime", (req, res) => {
  let time = new Date();
  res.type("txt");
  res.send(time);
});

app.listen(3000, () => {
  console.log("Example app listening at http://localhost:3000");
});
