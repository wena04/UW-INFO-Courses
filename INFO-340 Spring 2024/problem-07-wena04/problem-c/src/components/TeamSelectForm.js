import React, { useState } from "react";

export default function TeamSelectForm(props) {
  const [selectedTeam, setSelectedTeam] = useState("");
  const [includeRunnerUps, setIncludeRunnerUps] = useState(false);

  const handleTeamChange = (event) => {
    setSelectedTeam(event.target.value);
  };

  const handleCheckboxChange = (event) => {
    setIncludeRunnerUps(event.target.checked);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    props.applyFilterCallback(selectedTeam, includeRunnerUps);
  };

  const optionElems = props.teamOptions.map((teamName) => {
    return (
      <option key={teamName} value={teamName}>
        {teamName}
      </option>
    );
  });

  return (
    <form onSubmit={handleSubmit} className="row align-items-center mb-3">
      <div className="col-auto">
        <select
          id="teamSelect"
          className="form-select"
          value={selectedTeam}
          onChange={handleTeamChange}
        >
          <option value="">Show all teams</option>
          {optionElems}
        </select>
      </div>
      <div className="col-auto">
        <div className="form-check">
          <input
            id="runnerupCheckbox"
            type="checkbox"
            className="form-check-input"
            checked={includeRunnerUps}
            onChange={handleCheckboxChange}
          />
          <label htmlFor="runnerupCheckbox" className="form-check-label">
            Include runner-up
          </label>
        </div>
      </div>
      <div className="col-auto">
        <button id="submitButton" type="submit" className="btn btn-warning">
          Apply Filter
        </button>
      </div>
    </form>
  );
}
