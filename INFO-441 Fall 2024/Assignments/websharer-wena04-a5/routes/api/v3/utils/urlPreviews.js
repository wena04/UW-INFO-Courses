import fetch from "node-fetch";
import parser from "node-html-parser";
import * as cheerio from "cheerio";

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

    // Construct preview HTML with website title and other details using Cheerio for safety
    const $ = cheerio.load(
      '<div id="url_previews" style="max-width: 300px; border: solid 1px; border-radius: 5px; padding: 3px; text-align: center;"></div>'
    );
    $("<a></a>")
      .attr("href", url)
      .append(`<p><strong>${ogTitle}</strong></p>`)
      .appendTo("#url_previews");
    if (ogImage) {
      $("<img>")
        .attr("src", ogImage)
        .css({
          "max-height": "200px",
          "max-width": "100%",
          "margin-bottom": "10px",
        })
        .appendTo("#url_previews");
    }
    if (ogDescription) {
      $("<p></p>").text(ogDescription).appendTo("#url_previews");
    }
    if (ogSiteName) {
      $("<p></p>").text(`Site: ${ogSiteName}`).appendTo("#url_previews");
    }

    return $.html(); // Return the sanitized HTML
  } catch (error) {
    console.error("Error fetching or parsing URL:", error);
    return `<div>Error fetching preview for <a href="${url}">${url}</a></div>`;
  }
}

export default getURLPreview;
