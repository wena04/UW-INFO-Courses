import fetch from "node-fetch";
import parser from "node-html-parser";

async function getURLPreview(url) {
  try {
    if (!url) {
      throw new Error("URL query parameter is required.");
    }

    const response = await fetch(url);
    const pageText = await response.text();
    const root = parser.parse(pageText);

    // Extract OpenGraph title, fallback to <title> if og:title is missing
    const ogTitle =
      root
        .querySelector('meta[property="og:title"]')
        ?.getAttribute("content") ||
      root.querySelector("title")?.innerText ||
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

    // Construct preview HTML with website title and other details
    let previewHTML = `
      <div id="url_previews style="max-width: 300px; border: solid 1px; border-radius: 5px; padding: 3px; text-align: center;">
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
      </div>
    `;

    return previewHTML; // Send the constructed HTML as the response
  } catch (error) {
    console.error("Error fetching or parsing URL:", error);
    return `<div>Error fetching preview for <a href="${url}">${url}</a></div>`;
  }
}

export default getURLPreview;
