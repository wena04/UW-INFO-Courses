import express from "express";
import { promises as fs } from "fs";
import path from "path";

const app = express();
const wwwroot = path.join(
  process.cwd(),
  "/UnsecureStaticFileServer/",
  "wwwroot"
);

app.get("*", async (req, res) => {
  console.log("the current directory is: " + wwwroot);
  if (req.path !== "/") {
    console.log(
      `request to '${req.path.split(".")}', sending back ${
        req.path.split(".")[1]
      } content`
    );
    let fileContents = await fs.readFile(wwwroot + req.path);
    // file type will be based on the letters after the first "." in the path entered
    res.type(req.path.split(".")[1]);
    res.send(fileContents);
    return;
  } else {
    console.log("request to '/index.html', sending back html content");
    let fileContents = await fs.readFile(wwwroot + "/index.html");
    res.type("html");
    res.send(fileContents);
  }
});
// I did not do any error handling for an invalid file path

// Start the server on port 3000
app.listen(3000, "localhost", () => {
  console.log("Example app listening at http://localhost:3000");
});
