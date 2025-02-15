import express from "express";
var router = express.Router();

import getURLPreview from "../utils/urlPreviews.js";

router.get("/", async function (req, res, next) {
  try {
    let username = req.query.username;
    let posts;
    if (username) {
      posts = await req.models.Post.find({ username: username }).exec();
    } else {
      posts = await req.models.Post.find();
    }

    let postData = await Promise.all(
      posts.map(async (post) => {
        try {
          let htmlPreview = await getURLPreview(post.url);
          return {
            htmlPreview: htmlPreview,
            description: post.description,
            username: post.username,
          };
        } catch (error) {
          return {
            htmlPreview: "Error: " + error,
            description: post.description,
            username: post.username,
          };
        }
      })
    );
    res.json(postData);
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
    const newPost = new req.models.Post({
      url: req.body.url,
      description: req.body.description,
      username: session.account.username,
      created_date: new Date(),
    });
    let response = await newPost.save();

    res.json({ status: "success" });
  } catch (error) {
    console.log("Error: " + error);
    res.status(500).json({ status: "error", error: "error" + error });
  }
});

export default router;
