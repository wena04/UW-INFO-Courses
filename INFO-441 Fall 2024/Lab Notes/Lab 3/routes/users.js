import express from "express";
var router = express.Router();
import User from "./userSchema";

/* GET users listing. */
router.get("/", async function (req, res, next) {
  try {
    const users = await User.find();
    res.send(users);
  } catch (error) {
    res.status(500).send(error);
});

router.post("/", async function (req, res, next) {
  try {
    const user = new User(req.body);
    await user.save();
    res.send(user);
  } catch (error) {
    res.status(500).send(error);
  }
});

export default router;
