import express from "express";
var router = express.Router();

// GET all employee information
router.get("/", async (req, res) => {
  try {
    const business = req.query.businessID;
    const employees = await req.models.Employee.find({
      businessID: business,
    });
    res.json(employees);
  } catch (error) {
    console.error("Error fetching employees:", error);
    res.status(500).json({ status: "error", error: error.message });
  }
});

// POST a new employee
router.post("/", async (req, res) => {
  try {
    const employeePost = new req.models.Employee({
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      hourlyWage: Number(req.body.hourlyWage),
      hoursWorked: Number(req.body.hoursWorked),
      businessID: req.body.businessID,
    });
    await employeePost.save();
    res.json({
      status: "success",
    });
  } catch (error) {
    console.log("Error saving employee: ", error);
    res.status(500).json({
      status: "error",
      error: error.message,
    });
  }
});

//POST add hours to employee
router.post('/addHours', async(req, res) => {
  try {
    // console.log("Entering addHours post api")
    // console.log("Employee ID: ", req.body.employeeID)
    // console.log("Hours Being Added: ", req.body.hours)
    const employee = await req.models.Employee.findById({_id: req.body.employeeID})
    // console.log("Employee from db: ", employee)
    employee.hoursWorked += Number(req.body.hours)

    await employee.save()
    res.json({
      status: "Success"
    })
  } catch (error) {
    console.log("Error updating employee's hours: ", error);
    res.status(500).json({
      status: "error",
      error: error.message,
    });
  }
})

//POST update wage to employee
router.post('/updateWage', async(req, res) => {
  try {
    const employee = await req.models.Employee.findById({_id: req.body.employeeID})
    employee.hourlyWage = Number(req.body.wage)

    await employee.save()
    res.json({
      status: "Success"
    })
  } catch (error) {
    console.log("Error updating employee's wage: ", error);
    res.status(500).json({
      status: "error",
      error: error.message,
    });
  }
})


router.delete("/", async(req, res) => {
  try {
    const employee = await req.models.Employee.findById({_id: req.body.employeeID})
    const deleteResult = await req.models.Employee.deleteOne({_id: employee})
    console.log(`successfully deleted employee with ID: ${employee}`);

    return res.json({
      status: "Success"
    })

  } catch (error) {
    console.log("Error deleting employee:", error);
    res.status(500).json({
      status: "error",
      error: error.message,
    });
  }
}) 

export default router;
