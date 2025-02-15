import express from "express";
import path from "path";

const app = express();

// Define the full file path to the wwwroot directory
const wwwroot = path.join(process.cwd(), "SecureStaticFileServer", "wwwroot");

app.get("*", (req, res) => {
  console.log("Serving from directory: " + wwwroot);

  // if the request path is / then show the index.html file
  if (req.path === "/") {
    res.sendFile(path.join(wwwroot, "index.html"), (err) => {
      if (err) {
        console.error("Error serving index.html:", err);
        res.status(404).send("404 - File Not Found");
      }
    });
  } else {
    // display other files using sendFile()
    const filePath = path.join(wwwroot, req.path);
    res.sendFile(filePath, (err) => {
      if (err) {
        // for any file errors
        console.error("File not found or forbidden:", err);
        res.status(404).send("404 - File Not Found");
      }
    });
  }
});

// Start the secure server on port 3000
app.listen(3000, "localhost", () => {
  console.log("Secure server listening at http://localhost:3000");
});
