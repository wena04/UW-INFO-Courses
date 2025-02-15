import express from "express";
import fetch from "node-fetch";
import { parse } from "node-html-parser";

const router = express.Router();

// Define the route for /api/v1/urls/preview
router.get("/urls/preview", async (req, res) => {
  const url = req.query.url;

  if (!url) {
    return res.status(400).send("URL query parameter is required.");
  }

  try {
    const response = await fetch(url);
    const html = await response.text();
    const root = parse(html);

    // Extract OpenGraph title, fallback to <title> if og:title is missing
    const ogTitle =
      root
        .querySelector('meta[property="og:title"]')
        ?.getAttribute("content") ||
      root.querySelector("title")?.text ||
      url;

    // Extract OpenGraph image
    const ogImage = root
      .querySelector('meta[property="og:image"]')
      ?.getAttribute("content");

    // Extract OpenGraph description, fallback to empty string if missing
    const ogDescription =
      root
        .querySelector('meta[property="og:description"]')
        ?.getAttribute("content") || "";

    // Extract OpenGraph site name
    const ogSiteName =
      root
        .querySelector('meta[property="og:site_name"]')
        ?.getAttribute("content") || "";

    const ogAudio =
      root
        .querySelector('meta[property="og:audio"]')
        ?.getAttribute("content") || "";

    // Construct preview HTML with website title and other details
    let previewHTML = `
    <div id="url_previews">
        <div>
            <a href="${url}">
                <p><strong>${ogTitle}</strong></p>
            </a>
            ${
              ogImage
                ? `<img src="${ogImage}" style="max-height: 200px; max-width: 100%; margin-bottom: 10px;">`
                : ""
            }
            ${ogDescription ? `<p>${ogDescription}</p>` : ""}
            ${ogSiteName ? `<p>Site: ${ogSiteName}</p>` : ""}
            ${
              ogAudio
                ? `<p>Audio: <audio controls><source src="${ogAudio}" /></audio></p>`
                : ""
            }
        </div>
    </div>
`;

    res.send(previewHTML); // Send the constructed HTML as the response
  } catch (error) {
    console.error("Error fetching or parsing URL:", error);
    res.status(500).send("Error generating URL preview.");
  }
});

export default router;
