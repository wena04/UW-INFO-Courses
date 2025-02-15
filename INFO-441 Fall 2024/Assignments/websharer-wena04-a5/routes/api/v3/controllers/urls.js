import express from "express";
var router = express.Router();

import getURLPreview from "../utils/urlPreviews.js";

/* GET users listing. */
router.get("/preview", async function (req, res, next) {
  try {
    let url = req.query.url;
    let html = await getURLPreview(url);
    res.type("html");
    res.send(html);
  } catch (error) {
    res.type("html");
    console.log("Error: " + error);
    res.status(500).send("Error: " + error);
  }
});

export default router;
