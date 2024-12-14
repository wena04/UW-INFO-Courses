"use strict";

import * as model from "./Model.js";
import { renderTaskList } from "./View.js";

function markCompleteCallback(task) {
  model.markComplete(task.id);
  renderTaskView();
}

export function renderTaskView() {
  document.querySelector("#tasks-root").innerHTML = "";
  document
    .querySelector("#tasks-root")
    .appendChild(renderTaskList(markCompleteCallback));

  const button = document.querySelector("#add-task-button");
  const input = document.querySelector("#task-input");

  button.addEventListener("click", () => {
    const taskDescription = input.value.trim();
    if (taskDescription) {
      model.addTask(taskDescription);
      input.value = "";
      renderTaskView();
    }
  });
}
