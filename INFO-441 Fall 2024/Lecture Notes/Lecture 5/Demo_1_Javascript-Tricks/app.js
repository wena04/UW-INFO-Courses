const title = "This page";
const subTitle = "This is an example page";
const description = "This is a description of the page";

// string addition
let html =
  "<html><body>" +
  "<h1>" +
  title +
  "</h1>" +
  "<h2>" +
  subTitle +
  "</h2>" +
  "<p>" +
  description +
  "</p>" +
  "</body></html>";
console.log(html);

//template strings (with insertions)
let html2 = `
<html>
    <body>
        <h1>${title}</h1>
        <h2>${subTitle}</h2>
        <p>${description}</p>
    </body>
</html>`;
console.log(html2);

//what if description is undefined??

//solution 1: ternary operator
//condition check ? true : false
let html3 = `
<html>
    <body>
        <h1>${title}</h1>
        <h2>${subTitle}</h2>
        <p>${description ? description : " "}</p>
    </body>
</html>`;
console.log(html3);

//solution 2: helper function
function descriptionHtml(description) {
  if (description) {
    return `<p>${description}</p>`;
  } else {
    return "";
  }
}

let html4 = `
<html>
    <body>
        <h1>${title}</h1>
        <h2>${subTitle}</h2>
        ${descriptionHtml(description)}
    </body>
</html>`;
console.log(html4);

////////////////////////////////////////
// Iterator's Demo

//fake data
const dataArr = [
  "first name : Anthony",
  "last name : Wen",
  "age : 19",
  "glasses : yes",
];

// "forEach" runs a function on each item in an object/arry
// we will use it to extract the values into an object
const valuesDictionary = {};
dataArr.forEach((item) => {
  const split_item = item.split(" : ");
  const item_key = split_item[0];
  const item_value = split_item[1];
  valuesDictionary[item_key] = item_value;
});
console.log(valuesDictionary);

// "map" creates a modified version of an array.
// The new array will have values that are the result of
// running a function on each item in the original array.

// map demo 1: replace all the ":" with "="
const modifiedDataArr1 = dataArr.map((item) => {
  item.replace(" : ", " = ");
});
console.log(modifiedDataArr1);

// map demo 2: just get the key (first part) of each string
const modifiedDataArr2 = dataArr.map((item) => {
  return item.split(" : ")[0];
});
console.log(modifiedDataArr2);

// "filter" goes through an array and makes a new array with
// only the items that passed a given function (function returns true)

// filter demo: keep only strings with name
const filteredDataArr = dataArr.filter((item) => {
  if (item.includes("name")) {
    return true;
  } else {
    return false;
  }
});
console.log(filteredDataArr);
//note shorthand version is:
const filteredDataArr2 = dataArr.filter((item) => item.includes("name"));
console.log(filteredDataArr2);

// one really convienent thing about these iterators
// is that they can be chained together

// chain demo: get only name info, but also replace ":" with "="
const filteredDataArr3 = dataArr
  .filter((item) => item.includes("name"))
  .map((item) => item.replace(" : ", " = "));
console.log(filteredDataArr3);
