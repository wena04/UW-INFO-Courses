import express from "express";
import getURLPreview from "../utils/urlPreviews.js";

var router = express.Router();

function escapeHTML(str) {
  return String(str).replace(
    /[&<>'"]/g,
    (tag) =>
      ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        "'": "&#39;",
        '"': "&quot;",
      }[tag])
  );
}

// POST request to add a new post (URL, description, username)
router.post("/", async (req, res) => {
  try {
    // Check if user is authenticated
    if (!req.session || !req.session.isAuthenticated) {
      return res.status(401).json({
        status: "error",
        error: "not logged in",
      });
    }

    const url = escapeHTML(req.body.url);
    const description = escapeHTML(req.body.description);
    const username = req.session.account.username;

    if (!url || !description) {
      return res.status(400).json({
        status: "error",
        error: "Missing url or description",
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

// GET request to retrieve posts
router.get("/", async (req, res) => {
  try {
    const query = {};

    // Debug log to see if a username query parameter or session username exists
    console.log("Request query:", req.query);

    // Check if a username query parameter is provided
    if (req.query.username) {
      query.username = req.query.username;
      console.log(
        "Filtering posts by username from query parameter:",
        req.query.username
      );
    }
    // If no query parameter is provided, use the session username if logged in
    else if (
      req.session &&
      req.session.isAuthenticated &&
      req.session.account &&
      req.session.account.username
    ) {
      query.username = req.session.account.username;
      console.log(
        "Filtering posts by session username:",
        req.session.account.username
      );
    } else {
      console.log(
        "No username specified and no logged-in user; fetching all posts."
      );
    }

    // Fetch posts based on the query (filtered by username if available, otherwise fetch all)
    const posts = await req.models.Post.find(query);

    // Map each post to include the preview, description, and username
    const postData = await Promise.all(
      posts.map(async (post) => {
        const sanitizedDescription = escapeHTML(post.description);
        const sanitizedUsername = escapeHTML(post.username);

        try {
          const htmlPreview = await getURLPreview(post.url);
          return {
            description: sanitizedDescription,
            username: sanitizedUsername,
            htmlPreview: htmlPreview,
            id: post._id,
            likes: post.likes,
            created_date: post.created_date,
            description: post.description,
          };
        } catch (error) {
          return {
            id: post._id,
            url: post.url,
            description: sanitizedDescription,
            username: sanitizedUsername,
            likes: post.likes,
            created_date: post.created_date,
            htmlPreview: `Error generating preview: ${error.message}`,
          };
        }
      })
    );

    // POST request to like a post
    router.post("/like", async (req, res) => {
      try {
        if (!req.session || !req.session.isAuthenticated) {
          return res
            .status(401)
            .json({ status: "error", error: "not logged in" });
        }

        const postID = req.body.postID;
        if (!postID) {
          return res
            .status(400)
            .json({ status: "error", error: "Missing postID" });
        }

        const post = await req.models.Post.findById(postID);
        if (!post) {
          return res
            .status(404)
            .json({ status: "error", error: "Post not found" });
        }

        const username = req.session.account.username;

        if (!post.likes.includes(username)) {
          post.likes.push(username);
        }
        await post.save();

        res.json({ status: "success" });
      } catch (error) {
        console.error("Error liking post:", error);
        res.status(500).json({ status: "error", error: error.message });
      }
    });

    // POST request to unlike a post
    router.post("/unlike", async (req, res) => {
      try {
        if (!req.session || !req.session.isAuthenticated) {
          return res
            .status(401)
            .json({ status: "error", error: "not logged in" });
        }

        const postID = req.body.postID;
        const post = await req.models.Post.findById(postID);

        const index = post.likes.indexOf(req.session.account.username);
        if (index > -1) {
          post.likes.splice(index, 1);
          await post.save();
        }

        res.json({ status: "success" });
      } catch (error) {
        console.error("Error unliking post:", error);
        res.status(500).json({ status: "error", error: error.message });
      }
    });

    // DELETE request to delete a post
    router.delete("/", async (req, res) => {
      try {
        if (!req.session.isAuthenticated) {
          return res
            .status(401)
            .json({ status: "error", error: "not logged in" });
        }

        const { postID } = req.body;

        if (!postID) {
          return res
            .status(400)
            .json({ status: "error", error: "Missing postID" });
        }

        const post = await req.models.Post.findById(postID);

        if (!post) {
          return res
            .status(404)
            .json({ status: "error", error: "Post not found" });
        }

        const username = req.session.account.username;

        if (post.username !== username) {
          return res.status(401).json({
            status: "error",
            error: "you can only delete your own posts",
          });
        }

        await req.models.Comment.deleteMany({ post: postID });

        await req.models.Post.deleteOne({ _id: postID });

        res.json({ status: "success" });
      } catch (error) {
        console.log(error);
        res.status(500).json({ status: "error", error: error.message });
      }
    });

    // Send the final post data as JSON
    res.json(postData);
  } catch (error) {
    console.error("Error fetching posts:", error);
    res.status(500).json({ status: "error", error: error.message });
  }
});

export default router;
