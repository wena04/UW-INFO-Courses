import express from "express";
var router = express.Router();

router.get("/", async function (req, res, next) {
  let commentsData;
  try {
    commentsData = await req.models.Comment.find({
      post: req.query.postID,
    }).exec();
    res.json(commentsData);
  } catch (error) {
    console.log("Error: " + error);
    res.status(500).json({ status: "error", error: "error" + error });
  }
});

router.post("/", async function (req, res, next) {
  let session = req.session;
  if (!session.isAuthenticated) {
    console.log("Unauthorized: not logged in");
    res.status(401).json({ status: "error", error: "not logged in" });
    return;
  }

  try {
    //find the post
    const postToCommentOn = await req.models.Post.findById(req.body.postID);
    const newComment = new req.models.Comment({
      username: session.account.username,
      comment: req.body.newComment,
      post: req.body.postID,
      created_date: new Date(),
    });
    let response = await newComment.save();

    res.json({ status: "success" });
  } catch (error) {
    console.log("Error: " + error);
    res.status(500).json({ status: "error", error: "error" + error });
  }
});

export default router;
