import React, { useState } from "react";
import { AboutNav, BreedNav } from "./Navigation";
import PetList from "./PetList";
import "../style.css";

const App = ({ pets: initialPets }) => {
  const [pets, setPets] = useState(initialPets);

  const uniqueBreeds = Array.from(new Set(pets.map((pet) => pet.breed)));

  const adoptPet = (petName) => {
    const updatedPets = pets.map((pet) =>
      pet.name === petName ? { ...pet, adopted: true } : pet
    );
    setPets(updatedPets);
  };

  return (
    <div>
      <header className="jumbotron jumbotron-fluid py-4">
        <div className="container">
          <h1>Adopt a Pet</h1>
        </div>
      </header>
      <main className="container">
        <div className="row">
          <div id="navs" className="col-3">
            <AboutNav />
            <BreedNav breeds={uniqueBreeds} />
          </div>
          <div id="petList" className="col-9">
            <PetList pets={pets} adoptCallback={adoptPet} />
          </div>
        </div>
      </main>
      <footer className="container">
        <small>
          Images from{" "}
          <a href="http://www.seattlehumane.org/adoption/dogs">
            Seattle Humane Society
          </a>
        </small>
      </footer>
    </div>
  );
};

export default App;
