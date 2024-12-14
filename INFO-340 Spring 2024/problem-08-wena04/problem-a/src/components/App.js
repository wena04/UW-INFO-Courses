import React from "react";
import { Routes, Route, Navigate, Link } from "react-router-dom";
import { AboutNav } from "./Nav";
import PetPage from "./PetPage";
import PetList from "./PetList";
import AboutPage from "./AboutPage";
import ResourcesPage from "./ResourcesPage";
import PetDetail from "./PetDetail";

import SAMPLE_DOGS from "../data/dogs.json";

function App(props) {
  const pets = SAMPLE_DOGS;
  return (
    <div>
      <header className="jumbotron py-4 mb-4">
        <div className="container">
          <h1>
            <Link to="/adopt">Adopt a Pet</Link>
          </h1>
        </div>
      </header>

      <main className="container">
        <div className="row">
          <div className="col-3">
            <AboutNav />
          </div>
          <div className="col">
            <Routes>
              <Route path="about" element={<AboutPage />} />
              <Route path="resources" element={<ResourcesPage />} />
              <Route path="adopt" element={<PetPage />}>
                <Route index element={<PetList pets={pets} />} />
                <Route path=":petName" element={<PetDetail />} />
              </Route>
              <Route path="*" element={<Navigate to="/adopt" />} />
            </Routes>
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
}

export default App;
