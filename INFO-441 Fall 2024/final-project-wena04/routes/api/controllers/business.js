import express from "express";
var router = express.Router();

import multer from 'multer'



const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './public/uploads')
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname)
  }
})

const upload = multer({ storage });


//reference for using multer to upload images https://www.youtube.com/watch?v=i8yxx6V9UdM&t=278s
router.post('/upload', upload.single('file'), (req, res) => {
  console.log("Entering uploads")
  console.log(req.file)
  console.log(req.body.businessName)

  const filePath = `/uploads/${req.file.filename}`
  console.log(filePath)
  res.json({
    status: "success",
    filePath: filePath
  })
})


// GET all business information
router.get("/", async (req, res) => {
  try {
    if (!req.session.isAuthenticated) {
      res.status(401).json({
        status: "error",
        error: "not logged in",
      });
      return;
    }

    const username = req.session.account.username;
    const businesses = await req.models.Business.find({ username: username });

    // console.log("Fetched business:", businesses);
    res.json(businesses);
  } catch (error) {
    console.error("Error fetching business names:", error);
    res.status(500).json({ status: "error", error: error.message });
  }
});

// POST a new business
router.post("/", async (req, res) => {
  try {
    console.log("Entering /post");
    console.log("Received from req.body: ", req.body.businessName);

    if (!req.session.isAuthenticated) {
      res.status(401).json({
        status: "error",
        error: "not logged in",
      });
      return;
    }
    const newBusinessName = req.body.businessName;
    const logoPath = req.body.logo

    const newBusiness = new req.models.Business({
      businessName: newBusinessName,
      username: req.session.account.username,
      logo: logoPath
    });

    await newBusiness.save();
    console.log("successfully saved business into db");

    return res.json({ status: "success" });
  } catch (error) {
    console.log("Error saving new business: ", error);
    return res.status(500).json({ error: error.message });
  }
});



export default router;
