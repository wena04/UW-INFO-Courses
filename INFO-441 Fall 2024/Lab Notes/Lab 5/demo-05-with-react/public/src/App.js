import React from 'react';

function App() {
  return (
    <div>
      <h1>React App</h1>
      <button onClick={getUser}>Get User</button>
    </div>
  );
}

async function getUser() {
  await fetch('/users')
    .then(response => response.json())
    .then(data => console.log(data))
    .catch(error => console.log(error));
}

export default App;
