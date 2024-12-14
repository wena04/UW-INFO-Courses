import React, { useState } from "react";
import GameDataTable from "./GameDataTable";
import TeamSelectForm from "./TeamSelectForm";

function App(props) {
  const [selectedTeam, setSelectedTeam] = useState("");
  const [includeRunnerUps, setIncludeRunnerUps] = useState(false);

  const uniqueTeamNames = [
    ...new Set(
      props.gameData.reduce((all, current) => {
        return all.concat([current.winner, current.runner_up]);
      }, [])
    ),
  ].sort();

  const applyFilter = (teamName, includeRunners) => {
    setSelectedTeam(teamName);
    setIncludeRunnerUps(includeRunners);
  };

  const displayedData = props.gameData.filter((game) => {
    if (selectedTeam === "") return true;
    if (game.winner === selectedTeam) return true;
    if (includeRunnerUps && game.runner_up === selectedTeam) return true;
    return false;
  });

  return (
    <div className="container">
      <header className="mb-3">
        <h1>FIFA World Cup Finals</h1>
      </header>

      <main>
        <TeamSelectForm
          teamOptions={uniqueTeamNames}
          applyFilterCallback={applyFilter}
        />
        <GameDataTable data={displayedData} />
      </main>

      <footer>
        <small>
          Data from{" "}
          <a href="https://en.wikipedia.org/wiki/List_of_FIFA_World_Cup_finals">
            Wikipedia
          </a>
          .
        </small>
      </footer>
    </div>
  );
}

export default App;
