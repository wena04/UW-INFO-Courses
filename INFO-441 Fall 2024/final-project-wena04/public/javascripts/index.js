async function init() {
  loadIdentity();
  try {
    let identityInfo = await fetchJSON(`api/users/myIdentity`);
    if (identityInfo.status == "loggedin") {
      loadBusinesses();
    }
  } catch (error) {
    console.log("User is not logged in: ", error);
  }
}

async function addBusiness() {
  const businessName = document.getElementById("business_name_input").value;

  const imgFile = document.getElementById("logoFile").files[0]

  //reference for FormData objects https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest_API/Using_FormData_Objects
  if (imgFile) {
    const formData = new FormData()
    const changedFileName = new File([imgFile], businessName + "." + imgFile.name.split('.').pop(), {type: imgFile.type})
    // console.log(imgFile.files[0])
    formData.append('file', changedFileName);
    formData.append('businessName', businessName)
    let uploadResponse = await fetch(`api/business/upload`, {
      method: "POST",
      body: formData,
    });
  
    // console.log(businessName);
    const logoPath = await uploadResponse.json();
    console.log(logoPath.filePath)
    console.log("making request to post new business name");
  
    // fetchJSON not defined error
    // copied utils.js file to implement fetchJSON()
    let responseJson = await fetchJSON(`api/business`, {
      method: "POST",
      body: { businessName: businessName, logo: logoPath.filePath },
    });
    console.log("response received. successfully saved business");
    document.getElementById("business_name_input").value = "";
    document.getElementById("logoFile").value = "";
    
    if (responseJson.status == "success") {
      document.getElementById(
        "postStatus"
      ).innerText = `Status: ${responseJson.status}`;
    } else {
      document.getElementById(
        "postStatus"
      ).innerText = `Status: ${responseJson.status} (${responseJson.error})`;
    }
  } else {
    let responseJson = await fetchJSON(`api/business`, {
      method: "POST",
      body: { businessName: businessName},
    });
    console.log("response received. successfully saved business");
    document.getElementById("business_name_input").value = "";
  
    if (responseJson.status == "success") {
      document.getElementById(
        "postStatus"
      ).innerText = `Status: ${responseJson.status}`;
    } else {
      document.getElementById(
        "postStatus"
      ).innerText = `Status: ${responseJson.status} (${responseJson.error})`;
    }
  }
  
  loadBusinesses();
}

async function loadBusinesses() {
  const capitalize = (name) =>name.charAt(0).toUpperCase() + name.slice(1).toLowerCase();

  try {
    console.log("Fetching business names...");
    const businessesJson = await fetchJSON(`/api/business/`);
    let businessesHtml = businessesJson
      .map((business) => {
        
        return `
        <div class="col-md-4 mb-4">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title">${capitalize(business.businessName)}</h5>
              <p class="card-text">
                <strong>Owner:</strong> ${business.username}
              </p>
              <a href="/businessInfo.html?businessID=${encodeURIComponent(
                business._id
              )}" class="btn btn-primary mb-3">Manage Business</a>
              ${loadLogo(business.logo)}
            </div>
          </div>
        </div>
      `;
      })
      .join("\n");

    document.getElementById("business_results").innerHTML = businessesHtml;
  } catch (error) {
    console.error("Error fetching business names:", error);
  }
}

function loadLogo(businessLogo) {
  if (businessLogo) {
    return `<img src="${businessLogo}" class="img-fluid card-img-top">`
  } else {
    return ``
  }
}
