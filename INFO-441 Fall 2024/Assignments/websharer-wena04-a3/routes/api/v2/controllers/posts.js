import express from "express";
import getURLPreview from "../utils/urlPreviews.js";

var router = express.Router();

//TODO: Add handlers here
// POST request to add a new post (URL, description, and username)
router.post("/", async (req, res) => {
  try {
    // console.log("Request body:", req.body);
    const { url, description, username } = req.body;

    if (!url || !description || !username) {
      return res.status(400).json({
        status: "error",
        error: "Missing url, description, or userame",
      });
    }

    const newPost = new req.models.Post({
      url: url,
      description: description,
      username: username,
      created_date: new Date(),
    });

    await newPost.save();
    console.log("Post successfully saved to MongoDB:", newPost);

    res.json({ status: "success" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ status: "error", error: error.message });
  }
});

router.get("/", async (req, res) => {
  try {
    const posts = await req.models.Post.find();

    let postData = await Promise.all(
      posts.map(async (post) => {
        try {
          const htmlPreview = await getURLPreview(post.url);
          return {
            description: post.description,
            username: post.username,
            htmlPreview: htmlPreview,
          };
        } catch (error) {
          return {
            description: post.description,
            username: username,
            htmlPreview: `Error generating preview: ${error.message}`,
          };
        }
      })
    );

    res.json(postData);
  } catch (error) {
    console.error("Error fetching posts:", error);
    res.status(500).json({ status: "error", error: error.message });
  }
});

export default router;
