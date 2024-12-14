import React from "react";
import { useParams } from "react-router-dom";
import Button from "react-bootstrap/Button";
import Carousel from "react-bootstrap/Carousel";
import _ from "lodash";

import SAMPLE_DOGS from "../data/dogs.json";

function PetDetail(props) {
  const { petName } = useParams();

  let pet = _.find(SAMPLE_DOGS, { name: petName });

  if (!pet) return <h2>No pet specified</h2>;

  let carouselItems = pet.images.map(function (img) {
    return (
      <Carousel.Item key={img}>
        <img className="d-block" src={img} alt={pet.name} />
      </Carousel.Item>
    );
  });

  return (
    <div>
      <h2>Adopt {pet.name}</h2>
      <p className="lead">
        {pet.sex} {pet.breed}
      </p>
      <div>
        <Carousel indicators={false} prevLabel="" nextLabel="">
          {carouselItems}
        </Carousel>
      </div>
      <Button disabled variant="primary" size="lg">
        Adopt me now!
      </Button>
    </div>
  );
}

export default PetDetail;
