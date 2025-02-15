import express from "express";
import path from "path";
import cookieParser from "cookie-parser";
import logger from "morgan";
import sessions from "express-session";

import models from "./models.js";
import apiv1Router from "./routes/api/v1/apiv1.js";
import apiv2Router from "./routes/api/v2/apiv2.js";
import apiv3Router from "./routes/api/v3/apiv3.js";

import usersRouter from "./routes/api/v3/controllers/users.js";

import WebAppAuthProvider from "msal-node-wrapper";

import { fileURLToPath } from "url";
import { dirname } from "path";

const authConfig = {
  auth: {
    clientId: "23130d83-c63a-4d32-aa13-d03c499d0262",
    authority:
      "https://login.microsoftonline.com/f6b6dd5b-f02f-441a-99a0-162ac5060bd2",
    clientSecret: "EU28Q~1Cse-u53ZchzxzkG6Sc5tRBIMYGHELIae1",
    redirectUri: "/redirect",
  },
  system: {
    loggerOptions: {
      loggerCallback(loglevel, message, containsPii) {
        console.log(message);
      },
      piiLoggingEnabled: false,
      logLevel: 3,
    },
  },
};

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

var app = express();

app.enable("trust proxy");

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

const oneDay = 1000 * 60 * 60 * 24;
app.use(
  sessions({
    secret:
      "this is some secret key I am making up 093u4oih54lkndso8y43hewrdskjf",
    saveUninitialized: true,
    cookie: { maxAge: oneDay },
    resave: false,
  })
);

// Middleware to add models to the request object
app.use((req, res, next) => {
  req.models = models;
  next();
});

app.use("/api/v1", apiv1Router);
app.use("/api/v2", apiv2Router);
app.use("/api/v3", apiv3Router);

const authProvider = await WebAppAuthProvider.WebAppAuthProvider.initialize(
  authConfig
);

app.use("/users", usersRouter);

app.use(authProvider.authenticate());

app.get("/signin", (req, res, next) => {
  return req.authContext.login({
    postLoginRedirectUri: "/", // redirect here after login
  })(req, res, next);
});
app.get("/signout", (req, res, next) => {
  return req.authContext.logout({
    postLogoutRedirectUri: "/", // redirect here after logout
  })(req, res, next);
});
app.use(authProvider.interactionErrorHandler());

export default app;
