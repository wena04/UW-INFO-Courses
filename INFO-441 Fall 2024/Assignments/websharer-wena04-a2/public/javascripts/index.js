async function previewUrl() {
  let url = document.getElementById("urlInput").value;

  try {
    let fetchUrl = "/api/v1/urls/preview?url=" + url;
    console.log("fetching: " + fetchUrl);
    let response = await fetch(fetchUrl);
    let resultText = await response.text();
    let preview = resultText;
    displayPreviews(preview);
  } catch (error) {
    console.log("error: " + response.status);
    displayPreviews("Error: " + response.status);
  }
}

function displayPreviews(previewHTML) {
  document.getElementById("url_previews").innerHTML = previewHTML;
}
