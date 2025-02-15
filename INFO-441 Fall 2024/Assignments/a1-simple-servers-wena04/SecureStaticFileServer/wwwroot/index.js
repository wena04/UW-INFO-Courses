async function showImg() {
  const img = document.getElementById("img");

  // Check if the image is currently hidden
  if (img.style.display === "none") {
    // If the image is hidden, show it
    img.style.display = "block";
  }
}
