import express from "express";
var router = express.Router();

// GET request to retrieve comments for a specific post
router.get("/", async (req, res) => {
  try {
    const { postID } = req.query;
    if (!postID) {
      return res
        .status(400)
        .json({ status: "error", error: "postID is required" });
    }

    const comments = await req.models.Comment.find({ post: postID });

    console.log("Fetched comments:", comments); // Debugging log

    const commentData = comments.map((comment) => ({
      id: comment._id,
      username: comment.username,
      comment: comment.comment,
      created_date: comment.created_date,
    }));

    res.json(commentData);
  } catch (error) {
    console.error("Error fetching comments:", error);
    res.status(500).json({ status: "error", error: error.message });
  }
});

// POST request to add a new comment to a post
router.post("/", async (req, res) => {
  try {
    if (!req.session || !req.session.isAuthenticated) {
      return res.status(401).json({ status: "error", error: "not logged in" });
    }

    const { postID, newComment } = req.body;

    const username = req.session.account.username;

    if (!postID || !newComment) {
      return res
        .status(400)
        .json({ status: "error", error: "Missing postID or comment" });
    }

    const comment = new req.models.Comment({
      username: username,
      comment: newComment,
      post: postID,
      created_date: new Date(),
    });

    await comment.save();
    res.json({ status: "success" });
  } catch (error) {
    console.error("Error saving comment:", error);
    res.status(500).json({ status: "error", error: error.message });
  }
});

export default router;
