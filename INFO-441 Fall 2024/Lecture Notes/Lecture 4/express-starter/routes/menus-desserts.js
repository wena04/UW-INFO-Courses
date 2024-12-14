import express from "express";
var router = express.Router();

router.get("/", (req, res) => {
  res.send("this is the desserts section");
});

router.get("/1", (req, res) => {
  res.send("chocolate cake");
});

// broken endpoint to show error
// note: if async function, then it crashes the whole server
router.get("/2", async (req, res) => {
  // Fake an error to pretned our database failed on something
  throw new Error("Loading dessert failed");
  res.send("dessert 2");
});

// error now handled
router.get("/3", (req, res) => {
  try {
    throw new Error("Loading dessert failed");
  } catch (err) {
    console.log(err);
    res.status(500).send("Error Loading dessert");
  }
});

export default router;
