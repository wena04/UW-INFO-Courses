import express from "express";
const router = express.Router();

router.get("/myIdentity", (req, res) => {
  // console.log("myIdentity route is being accessed");
  if (req.session && req.session.isAuthenticated) {
    console.log("User is logged in");
    res.json({
      status: "loggedin",
      userInfo: {
        name: req.session.account.name,
        username: req.session.account.username,
      },
    });
  } else {
    console.log("User is not logged in");
    res.json({
      status: "loggedout",
      // error: "You must be logged in to access this information",
    });
  }
});

export default router;
