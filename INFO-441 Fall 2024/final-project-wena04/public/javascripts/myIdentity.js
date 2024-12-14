async function loadIdentity() {
    let identity_div = document.getElementById("identity_div");

    try {
        let identityInfo = await fetchJSON(`api/users/myIdentity`)
        if (identityInfo.status == "loggedin") {
            const username = identityInfo.userInfo.username;
            const name = identityInfo.userInfo.name;
            identity_div.innerHTML = `
            <p class="me-3 mb-0"><strong>Business Owner</strong>: ${escapeHTML(name)} (${escapeHTML(username)})</p>
            <a href="/signout" class="btn btn-danger me-2" role="button">Log out</a>`;
        } else {
            identity_div.innerHTML = `
            <a href="/signin" class="btn btn-primary" role="button">Log in</a>`;
        }
    } catch (error) {
        console.log("Error occured when loading identity: ", error)
        return res.status(500).json({
            status: "error",
            error: error.toString()
        })
    }
}