import express from "express";
let router = express.Router();

import usersRouter from "./controllers/users.js";

router.use("/users", usersRouter);

router.use("user");
