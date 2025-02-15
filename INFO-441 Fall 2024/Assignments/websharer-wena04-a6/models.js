import mongoose from "mongoose";

let models = {};

(async function connectToDB() {
  console.log("connecting to mongodb");
  try {
    // Connect to MongoDB
    await mongoose.connect(
      "mongodb+srv://root:info441@cluster0.vnmb0.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
    );
    console.log("successfully connected to mongodb!");

    // Define the Post schema
    const postSchema = new mongoose.Schema({
      url: String,
      description: String,
      username: String,
      likes: [String],
      created_date: { type: Date, default: Date.now },
    });

    // Define the Comment schema
    const commentSchema = new mongoose.Schema({
      username: String,
      comment: String,
      post: { type: mongoose.Schema.Types.ObjectId, ref: "Post" },
      created_date: { type: Date, default: Date.now },
    });

    // Create the Post model
    models.Post = mongoose.model("Post", postSchema);
    // Create the Comment model
    models.Comment = mongoose.model("Comment", commentSchema);
    console.log("mongoose models created");
  } catch (error) {
    console.error("Error connecting to MongoDB:", error);
  }
})();

export default models;
