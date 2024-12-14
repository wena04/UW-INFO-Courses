async function init() {
  loadIdentity();
  loadUserinfo();
  loadBusinessInfo();
  loadEmployees();
  const identityInfo = await fetchJSON(`api/users/myIdentity`);
  if (identityInfo.status != "loggedin") {
    document.getElementById(
      "add_employee"
    ).innerHTML = `<a href="/">Please log in</a>`;
    return;
  }
}

async function loadUserinfo() {
  try {
    let user_info_div = document.getElementById("user_info_div");

    const identityInfo = await fetchJSON(`api/users/myIdentity`);
    if (identityInfo.status == "loggedin") {
      const username = identityInfo.userInfo.username;
      const name = identityInfo.userInfo.name;
      user_info_div.innerHTML = `
          <p>Name: ${escapeHTML(name)}</p>
          <p>Username: ${escapeHTML(username)}</p>
          `;
    } else {
      user_info_div.innerHTML = `<a href="/">Please log in</a>`;
    }
  } catch (error) {
    console.log("Error occured when loading user info: ", error);
  }
}

async function loadBusinessInfo() {
  const capitalize = (name) => name.charAt(0).toUpperCase() + name.slice(1).toLowerCase();
  try {
    const identityInfo = await fetchJSON(`api/users/myIdentity`);
    if (identityInfo.status != "loggedin") {
      document.getElementById(
        "business_info_div"
      ).innerHTML = `<a href="/">Please log in</a>`;
      return;
    }
    const urlParams = new URLSearchParams(window.location.search);
    const businessID = urlParams.get("businessID");

    const business = await fetchJSON(
      `/api/businessInfo?businessID=${businessID}`
    );

    const businessesHtml = `
        <div class="card mb-4">
        <div class="card-body">
          <h5 class="card-title">${capitalize(business.businessName)}</h5>
          <p class="card-text"><strong>Owner:</strong> ${business.username}</p>
          <p class="card-text"><strong>Total Earnings:</strong> $${
            business.earnings || 0
          }</p>
          <div class="mt-3">
            <label for="business_earnings_input" class="form-label">Add to Total Earnings:</label>
            <input id="business_earnings_input" type="text" class="form-control mb-2" placeholder="Enter amount" />
            <button class="btn btn-success" onclick="addBusinessEarnings()">Add Earnings</button>
            <span id="add_business_earnings_status" class="ms-2"></span>
          </div>
        </div>
      </div>
      `;

    document.getElementById("business_info_div").innerHTML = businessesHtml;
  } catch (error) {
    console.error("Error loading business information:", error);
    document.getElementById("business_info_div").innerHTML =
      "<p>Error loading business information.</p>";
  }
}

async function addBusinessEarnings() {
  try {
    const urlParams = new URLSearchParams(window.location.search);
    const businessID = urlParams.get("businessID");
    const earningsToAdd = parseFloat(
      document.getElementById("business_earnings_input").value
    );

    if (isNaN(earningsToAdd)) {
      document.getElementById("add_business_earnings_status").innerText =
        "Invalid earnings value.";
      return;
    }

    const responseJson = await fetchJSON("/api/businessInfo/addEarnings", {
      method: "POST",
      body: {
        businessID: businessID,
        earningsToAdd: earningsToAdd,
      },
    });

    if (responseJson.status === "success") {
      document.getElementById(
        "add_business_earnings_status"
      ).innerText = ` Update Business Earnings: ${responseJson.status}`;
    } else {
      document.getElementById(
        "add_business_earnings_status"
      ).innerText = ` Update Business Earnings: ${responseJson.status}`;
    }
    document.getElementById("business_earnings_input").value = "";
    loadBusinessInfo();
  } catch (error) {
    console.log("Error adding business earnings");
    document.getElementById("add_business_earnings_status").innerText =
      "Error updating earnings.";
  }
}

async function loadEmployees() {
  try {
    const identityInfo = await fetchJSON(`api/users/myIdentity`);
    if (identityInfo.status != "loggedin") {
      document.getElementById(
        "employee_info_div"
      ).innerHTML = `<a href="/">Please log in</a>`;
      return;
    }
    const urlParams = new URLSearchParams(window.location.search);
    const businessID = urlParams.get("businessID");

    // console.log("Extracted businessID:", businessID);

    const employees = await fetchJSON(
      `/api/employees?businessID=${businessID}`
    );
    // console.log("Employees loaded:", employees);

    const capitalize = (name) =>name.charAt(0).toUpperCase() + name.slice(1).toLowerCase();

    const employeesHtml = `
      <table class="employee-table table table-bordered">
        <thead>
          <tr>
            <th>Name</th>
            <th>Hours Worked</th>
            <th>Hourly Wage</th>
            <th>Earnings</th>
          </tr>
        </thead>
        <tbody class="table-group-divider">
          ${employees
            .map((employee) => {
              const firstName = capitalize(employee.firstName);
              const lastName = capitalize(employee.lastName);
              return `
                <tr>
                  <td><button class="employee_button" onClick="loadEmployee('${
                    employee._id
                  }', '${firstName}', '${lastName}')">${firstName} ${lastName}</button></td>
                  <td>${employee.hoursWorked}</td>
                  <td>$${employee.hourlyWage}</td>
                  <td>$${employee.hoursWorked * employee.hourlyWage}</td>
                </tr>
              `;
            })
            .join("\n")}
        </tbody>
      </table>
    `;

    document.getElementById("employee_info_div").innerHTML = employeesHtml;
  } catch (error) {
    console.error("Error loading employees:", error);
    document.getElementById("employee_info_div").innerHTML =
      "<p>Error loading employees.</p>";
  }
}

async function addEmployee() {
  const urlParams = new URLSearchParams(window.location.search);
  const businessID = urlParams.get("businessID");
  const firstName = document.getElementById("employee_first_name").value;
  const lastName = document.getElementById("employee_last_name").value;
  const hourlyWage = document.getElementById("hourly_wage").value;
  const hoursWorked = document.getElementById("hours_worked").value;

  console.log(
    "Testing employee info:",
    firstName,
    lastName,
    hourlyWage,
    hoursWorked,
    businessID
  );
  console.log("Testing business id:", businessID);

  if (firstName == "") {
    console.log("The firstName input field is empty.");
    document.getElementById("add_status").innerText = "Please enter employee's first name.";
    return;
  }

  if (lastName == "") {
    console.log("The lastName input field is empty.");
    document.getElementById("add_status").innerText = "Please enter employee's last name."
    return;
  }

  let responseJson = await fetchJSON("api/employees", {
    method: "POST",
    body: {
      firstName: firstName,
      lastName: lastName,
      hourlyWage: hourlyWage,
      hoursWorked: hoursWorked,
      businessID: businessID,
    },
  });
  console.log(responseJson.status);
  document.getElementById("employee_first_name").value = "";
  document.getElementById("employee_last_name").value = "";
  document.getElementById("hourly_wage").value = "";
  document.getElementById("hours_worked").value = "";

  if (responseJson.status == "success") {
    document.getElementById(
      "add_status"
    ).innerText = `Save Status: ${responseJson.status}`;
    loadEmployees();
  } else {
    document.getElementById(
      "add_status"
    ).innerText = `Save Status: ${responseJson.status} (Error: ${responseJson.error})`;
  }
}

//onClick function to create div and input field for specific employee using the passed employee name and ID
async function loadEmployee(employeeID, firstName, lastName) {
  console.log("Entering loadEmployee function");
  // console.log(employeeID)
  // console.log(firstName)
  // console.log(lastName)

  // Capitalize first and last names
  const capitalize = (name) => name.charAt(0).toUpperCase() + name.slice(1).toLowerCase();
  const capitalizedFirstName = capitalize(firstName);
  const capitalizedLastName = capitalize(lastName);

  document.getElementById("employee_edit").innerHTML = `
  <h2>Adjust ${capitalizedFirstName} ${capitalizedLastName}'s Information</h4>
  <input id="add_hours" type="text"/>  <button class="btn btn-primary btn-sm" onClick="addHours('${employeeID}')">Add Hours</button><span id="hours_update_status"></span>
  <br>
  <br>
  <input id="update_wage" type="text"/>  <button class="btn btn-primary btn-sm" onClick="updateWage('${employeeID}')">Update Wage</button><span id="wage_update_status"></span>
  <div class="d-flex justify-content-end align-items-center"><p class="me-3 mb-0"><strong>Note</strong>: Deleting an employee cannot be undone</p><button class="btn btn-danger btn-sm" onclick="deleteEmployee('${employeeID}')">Delete Employee</button></div>
  <span id="delete_employee_status"></span>
  `;
}

//New api call to employees/addHours to incrememnt and post added hours
async function addHours(employeeID) {
  const hours = document.getElementById("add_hours").value;
  // console.log(hours)
  // console.log(employeeID)

  let responseJson = await fetchJSON("api/employees/addHours", {
    method: "POST",
    body: {
      hours: hours,
      employeeID: employeeID,
    },
  });

  if (responseJson.status == "success") {
    document.getElementById(
      "hours_update_status"
    ).innerText = `Update Hours: ${responseJson.status}`;
  } else {
    document.getElementById(
      "hours_update_status"
    ).innerText = `Update Hours: ${responseJson.status}`;
  }
  document.getElementById("add_hours").value = "";
  loadEmployees();
}

async function updateWage(employeeID) {
  let wage = document.getElementById("update_wage").value;
  console.log(wage);

  let responseJson = await fetchJSON("/api/employees/updateWage", {
    method: "POST",
    body: {
      wage: wage,
      employeeID: employeeID,
    },
  });
  if (responseJson.status == "success") {
    document.getElementById(
      "wage_update_status"
    ).innerText = `Update Wage: ${responseJson.status}`;
  } else {
    document.getElementById(
      "wage_update_status"
    ).innerText = `Update Wage: ${responseJson.status}`;
  }
  document.getElementById("update_wage").value = "";
  loadEmployees();
}

async function deleteEmployee(employeeID) {
  let responseJson = await fetchJSON("/api/employees/", {
    method: "DELETE",
    body: {
      employeeID: employeeID
    }
  })

  if (responseJson.status === "Success") {
    document.getElementById("delete_employee_status").innerText = `Success: employee deleted`
  } else {
    document.getElementById("delete_employee_status").innerText = `Error: employee failed to delete`
  }
  document.getElementById("employee_edit").innerHTML = ``;
  loadEmployees();
}

async function deleteBusiness() {
  const urlParams = new URLSearchParams(window.location.search);
  const businessID = urlParams.get("businessID");

  const responseJson = await fetchJSON("/api/businessInfo/", {
    method: 'DELETE',
    body: { businessID: businessID }
  });
  //redirects to index.html page
  window.location.href = "index.html"

  //option to reload business page after deletion to show that it works
  // loadBusinessInfo()
  if (responseJson.status === "success") {
    console.log("Successfully deleted business")
  } else {
    console.log("Error deleting business:", responseJson.error);
  }
}