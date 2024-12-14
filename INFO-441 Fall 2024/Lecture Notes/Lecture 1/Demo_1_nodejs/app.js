// run npm init to create a package.json file
// run npm install express to install express

console.log("Hello World!");

const years = 1;
const days = years * 365;
const hours = days * 24;
const minutes = hours * 60;

console.log("There are " + minutes + " minutes in a year.");

// note these three ways of writing functions are (mostly) equivalent

function example_function() {
  return a + b;
}

let example_function = function (a, b) {
  return a + b;
};

let example_function = (a, b) => {
  return a + b;
};
