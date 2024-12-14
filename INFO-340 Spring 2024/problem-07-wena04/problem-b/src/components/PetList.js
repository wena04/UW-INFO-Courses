import React from "react";

const PetCard = ({ petData, adoptCallback }) => {
  const handleAdopt = () => {
    adoptCallback(petData.name);
  };

  return (
    <div className="card" onClick={handleAdopt}>
      <img className="card-img-top" src={petData.img} alt={petData.name} />
      <div className="card-body">
        <h3 className="card-title">
          {petData.name} {petData.adopted ? "(Adopted)" : ""}
        </h3>
        <p className="card-text">
          {petData.sex} {petData.breed}
        </p>
      </div>
    </div>
  );
};

const PetList = ({ pets, adoptCallback }) => {
  return (
    <div>
      <h2>Dogs for Adoption</h2>
      <div className="card-deck">
        {pets.map((pet) => (
          <PetCard key={pet.name} petData={pet} adoptCallback={adoptCallback} />
        ))}
      </div>
    </div>
  );
};

export default PetList;
