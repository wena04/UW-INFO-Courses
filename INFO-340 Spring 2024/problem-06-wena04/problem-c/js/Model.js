"use strict";
import initialTasks from "./task-data.js";

let currentTaskList = initialTasks.map((task, index) => ({
  ...task,
  id: index + 1,
}));

export const getIncompleteTasks = () => {
  return currentTaskList.filter((task) => task.status === "incomplete");
};

export const addTask = (taskDescription) => {
  const newTask = {
    id: currentTaskList.length + 1,
    description: taskDescription,
    status: "incomplete",
  };
  currentTaskList = [...currentTaskList, newTask];
};

export const markComplete = (taskId) => {
  currentTaskList = currentTaskList.map((task) => {
    const taskCopy = { ...task };
    if (taskCopy.id === taskId) {
      taskCopy.status = "complete";
    }
    return taskCopy;
  });
};
