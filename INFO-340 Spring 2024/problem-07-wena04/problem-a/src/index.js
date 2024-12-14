import React from "react";
import ReactDOM from "react-dom/client";
import { App } from "./components/App.js";
import senators from "./data/senators.json";

//render the App component here!
ReactDOM.createRoot(document.getElementById("root")).render(
  <App senatorList={senators} />
);
