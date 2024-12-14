import React, { useState } from "react";
import _ from "lodash";

export default function GameDataTable(props) {
  const [sortByCriteria, setSortByCriteria] = useState(null);
  const [isAscending, setIsAscending] = useState(null);

  const handleClick = (event) => {
    const criteria = event.currentTarget.name;
    if (criteria !== sortByCriteria) {
      setSortByCriteria(criteria);
      setIsAscending(true);
    } else if (isAscending) {
      setIsAscending(false);
    } else {
      setSortByCriteria(null);
      setIsAscending(null);
    }
  };

  let sortedData = props.data;
  if (sortByCriteria) {
    sortedData = _.sortBy(props.data, [sortByCriteria]);
    if (!isAscending) {
      sortedData = _.reverse(sortedData);
    }
  }

  const gameRows = sortedData.map((gameObj) => (
    <GameDataRow key={gameObj.year} gameObj={gameObj} />
  ));

  return (
    <div className="table-responsive">
      <table className="table">
        <thead>
          <tr>
            <th>
              Year
              <SortButton
                name="year"
                onClick={handleClick}
                active={sortByCriteria === "year"}
                ascending={isAscending}
              />
            </th>
            <th className="text-end">
              Winner
              <SortButton
                name="winner"
                onClick={handleClick}
                active={sortByCriteria === "winner"}
                ascending={isAscending}
              />
            </th>
            <th className="text-center">
              Score
              <SortButton
                name="score"
                onClick={handleClick}
                active={sortByCriteria === "score"}
                ascending={isAscending}
              />
            </th>
            <th>
              Runner-Up
              <SortButton
                name="runner_up"
                onClick={handleClick}
                active={sortByCriteria === "runner_up"}
                ascending={isAscending}
              />
            </th>
          </tr>
        </thead>
        <tbody>{gameRows}</tbody>
      </table>
    </div>
  );
}

function SortButton(props) {
  let iconClasses = "material-icons";
  if (props.active) {
    iconClasses += " active";
    if (props.ascending) {
      iconClasses += " flip";
    }
  }

  return (
    <button
      className="btn btn-sm btn-sort"
      name={props.name}
      onClick={props.onClick}
    >
      <span className={iconClasses} aria-label={`sort by ${props.name}`}>
        sort
      </span>
    </button>
  );
}

function GameDataRow({ gameObj }) {
  //gameObj = props.gameObj
  return (
    <tr>
      <td>{gameObj.year}</td>
      <td className="text-end">
        {gameObj.winner} {gameObj.winner_flag}
      </td>
      <td className="text-center">{gameObj.score}</td>
      <td>
        {gameObj.runner_up_flag}&nbsp;&nbsp;{gameObj.runner_up}
      </td>
    </tr>
  );
}
