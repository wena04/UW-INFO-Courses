async function init() {
  await loadIdentity();
  loadUserInfo();
}

async function saveUserInfo() {
  //TODO: do an ajax call to save whatever info you want about the user from the user table
  //see postComment() in the index.js file as an example of how to do this
  const personalWebsite = document
    .getElementById("personalWebsiteInput")
    .value.trim();

  // notify user if error
  if (!personalWebsite) {
    document.getElementById("notification").innerText =
      "Please enter a valid website link.";
    document.getElementById("notification");
    return;
  }

  const responseJson = await fetchJSON(`api/${apiVersion}/users/info`, {
    method: "POST",
    body: { personalWebsite: personalWebsite },
  });

  // update notification (from above)
  if (responseJson.status === "success") {
    document.getElementById("notification").innerText =
      "User info updated successfully!";
    document.getElementById("notification");
    document.getElementById("notification");
    loadUserInfo();
  } else {
    document.getElementById(
      "notification"
    ).innerText = `Error: ${responseJson.error}`;
    document.getElementById("notification");
  }
}

async function loadUserInfo() {
  const urlParams = new URLSearchParams(window.location.search);
  const username = urlParams.get("user");
  if (username == myIdentity) {
    document.getElementById("username-span").innerText = `You (${username})`;
    document.getElementById("user_info_new_div").classList.remove("d-none");
  } else {
    document.getElementById("username-span").innerText = username;
    document.getElementById("user_info_new_div").classList.add("d-none");
  }

  //TODO: do an ajax call to load whatever info you want about the user from the user table
  const userInfo = await fetchJSON(
    `api/${apiVersion}/users/info?user=${encodeURIComponent(username)}`
  );
  if (userInfo) {
    document.getElementById("user_info_div").innerHTML = `
            <p>Email: ${escapeHTML(userInfo.email)}</p>
            <p>Personal Website: <a href="${escapeHTML(
              userInfo.personalWebsite
            )}" target="_blank">${escapeHTML(userInfo.personalWebsite)}</a></p>
        `;
  } else {
    document.getElementById("user_info_div").innerText = "User info not found.";
  }

  loadUserInfoPosts(username);
}

async function loadUserInfoPosts(username) {
  document.getElementById("posts_box").innerText = "Loading...";
  let postsJson = await fetchJSON(
    `api/${apiVersion}/posts?username=${encodeURIComponent(username)}`
  );
  let postsHtml = postsJson
    .map((postInfo) => {
      return `
        <div class="post">
            ${escapeHTML(postInfo.description)}
            ${postInfo.htmlPreview}
            <div><a href="/userInfo.html?user=${encodeURIComponent(
              postInfo.username
            )}">${escapeHTML(postInfo.username)}</a>, ${escapeHTML(
        postInfo.created_date
      )}</div>
            <div class="post-interactions">
                <div>
                    <span title="${
                      postInfo.likes
                        ? escapeHTML(postInfo.likes.join(", "))
                        : ""
                    }"> ${
        postInfo.likes ? `${postInfo.likes.length}` : 0
      } likes </span> &nbsp; &nbsp;
                </div>
                <br>
                <div><button onclick='deletePost("${postInfo.id}")' class="${
        postInfo.username == myIdentity ? "" : "d-none"
      }">Delete</button></div>
            </div>
        </div>`;
    })
    .join("\n");
  document.getElementById("posts_box").innerHTML = postsHtml;
}

async function deletePost(postID) {
  let responseJson = await fetchJSON(`api/${apiVersion}/posts`, {
    method: "DELETE",
    body: { postID: postID },
  });
  loadUserInfo();
}
