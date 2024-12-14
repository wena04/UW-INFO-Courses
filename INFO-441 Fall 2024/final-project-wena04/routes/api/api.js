import express from "express";
var router = express.Router();

import businessRouter from "./controllers/business.js";
import usersRouter from "./controllers/users.js";
import employeesRouter from "./controllers/employees.js";
import businessInfoRouter from "./controllers/businessInfo.js";

router.use("/business", businessRouter);
router.use("/users", usersRouter);
router.use("/employees", employeesRouter);
router.use("/businessInfo", businessInfoRouter);

export default router;
