import express from "express";
import path from "path";
import { promises as fs } from "fs";

const app = express();
const wwwroot = path.join(process.cwd(), "HybridAnimals", "wwwroot");
const imgDirectory = path.join(wwwroot, "imgs");

// Redirect "/" to "/site/"
app.get("/", (req, res) => {
  res.redirect("/site/");
});

app.get("/site/*", (req, res) => {
  let filePath;
  console.log("Request path:", req.path);

  if (req.path === "/site/") {
    filePath = path.join(wwwroot, "index.html");
  } else {
    // replace "/site/" from req.path and add it to wwwroot
    const relativePath = req.path.replace("/site/", "");
    filePath = path.join(wwwroot, relativePath);
    console.log("Serving file:", filePath);
  }

  res.sendFile(filePath, (err) => {
    if (err) {
      console.error("Error serving file:", err);
      res.status(404).send("404 - File Not Found");
    }
  });
});

app.get("/api/animals", async (req, res) => {
  const animal = req.query.animal;
  console.log("Animal query is :", animal);
  if (!animal) {
    return res.status(400).send("Error: Missing 'animal' query parameter");
  }

  try {
    // Read all the filenames in the imgs directory
    const files = await fs.readdir(imgDirectory);
    // Filter filenames that contain the query parameter (animal name)
    const matchingFiles = files.filter((file) => file.includes(animal));
    // Prepend /site/imgs/ to each filename before sending to the client
    const responseFiles = matchingFiles.map((file) => `/site/imgs/${file}`);
    // Return the full file paths in the response
    if (responseFiles.length > 0) {
      res.json(responseFiles); // Send back the full path for each image
    } else {
      res.status(404).send("No images found with the specified animal.");
    }
  } catch (error) {
    console.error("Error reading directory:", error);
    res.status(500).send("Server error: Unable to read directory.");
  }
});

app.listen(3000, "localhost", () => {
  console.log("Secure server listening at http://localhost:3000");
});
