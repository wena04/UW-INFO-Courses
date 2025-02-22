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
            likes: post.likes,
            id: post.id,
            username: post.username,
            created_date: post.created_date,
          };
        } catch (error) {
          return {
            htmlPreview: "Error: " + error,
            description: post.description,
            likes: post.likes,
            id: post.id,
            username: post.username,
            date: post.date,
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

router.delete("/", async function (req, res, next) {
  let session = req.session;
  if (!session.isAuthenticated) {
    console.log("Unauthorized: not logged in");
    res.status(401).json({ status: "error", error: "not logged in" });
    return;
  }

  try {
    const postToDelete = await req.models.Post.findById(req.body.postID);
    if (postToDelete.username != session.account.username) {
      res.json({
        status: "error",
        error: "you can only delete your own posts",
      });
    }
    let postIdToDelete = postToDelete.id;
    let deletedCommentsInfo = await req.models.Comment.deleteMany({
      post: postIdToDelete,
    });
    let deletedPostInfo = await req.models.Post.deleteOne({
      _id: postIdToDelete,
    });

    res.json({ status: "success" });
  } catch (error) {
    console.log("Error: " + error);
    res.status(500).json({ status: "error", error: "error" + error });
  }
});

//TODO: Make these patch?
// or make /like a route and have post / delete actions

router.post("/like", async function (req, res, next) {
  let session = req.session;
  if (!session.isAuthenticated) {
    console.log("Unauthorized: not logged in");
    res.status(401).json({ status: "error", error: "not logged in" });
    return;
  }

  try {
    //find the post
    const postToLike = await req.models.Post.findById(req.body.postID);
    if (!postToLike.likes.includes(session.account.username)) {
      postToLike.likes.push(session.account.username);
    }
    let response = await postToLike.save();

    res.json({ status: "success" });
  } catch (error) {
    console.log("Error: " + error);
    res.status(500).json({ status: "error", error: "error" + error });
  }
});

router.post("/unlike", async function (req, res, next) {
  let session = req.session;
  if (!session.isAuthenticated) {
    console.log("Unauthorized: not logged in");
    res.status(401).json({ status: "error", error: "not logged in" });
    return;
  }

  try {
    //find the post
    const postToUnLike = await req.models.Post.findById(req.body.postID);
    if (postToUnLike.likes.includes(session.account.username)) {
      postToUnLike.likes.pull(session.account.username);
    }
    let response = await postToUnLike.save();

    res.json({ status: "success" });
  } catch (error) {
    console.log("Error: " + error);
    res.status(500).json({ status: "error", error: "error" + error });
  }
});

export default router;
