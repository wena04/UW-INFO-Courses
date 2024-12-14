import mongoose from "mongoose";

let models = {};

console.log("Trying to connect to mongodb");
await mongoose.connect("mongodb://localhost:27017/playlists");

console.log("Successfully connected to mongodb");

const userSchema = new mongoose.Schema({
  username: String,
});

models.User = mongoose.model("User", userSchema);

console.log("Successfully created database model");

export default models;
