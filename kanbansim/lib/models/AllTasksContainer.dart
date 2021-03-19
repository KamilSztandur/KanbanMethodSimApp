import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';
import 'package:kanbansim/models/User.dart';

class AllTasksContainer {
  Function getUsersList;

  List<Task> idleTasksColumn,
      stageOneInProgressTasksColumn,
      stageOneDoneTasksColumn,
      stageTwoTasksColumn,
      finishedTasksColumn;

  AllTasksContainer(Function getUserList) {
    this.getUsersList = getUserList;
    _setUpTaskLists();
  }

  void createTask(
      String title, int productivityRequired, User owner, Color color) {
    this.idleTasksColumn.add(
          Task(
            title,
            productivityRequired,
            owner,
            _getRandomTaskType(),
          ),
        );
  }

  void removeTask(Task task) {
    if (this.idleTasksColumn.remove(task) == true) {
      return;
    }

    if (this.stageOneInProgressTasksColumn.remove(task) == true) {
      return;
    }

    if (this.stageOneDoneTasksColumn.remove(task) == true) {
      return;
    }

    if (this.stageTwoTasksColumn.remove(task) == true) {
      return;
    }

    if (this.finishedTasksColumn.remove(task) == true) {
      return;
    }
  }

  void addRandomTasksForAllColumns() {
    _addRandomTasks(this.idleTasksColumn);
    _addRandomTasks(this.stageOneInProgressTasksColumn);
    _addRandomTasks(this.stageOneDoneTasksColumn);
    _addRandomTasks(this.stageTwoTasksColumn);
    _addRandomTasks(this.finishedTasksColumn);
  }

  void clearAllTasks() {
    _setUpTaskLists();
  }

  bool areThereAnyLocks() {
    if (_checkForLockedTasks(this.idleTasksColumn)) {
      return true;
    }

    if (_checkForLockedTasks(this.stageOneInProgressTasksColumn)) {
      return true;
    }

    if (_checkForLockedTasks(this.stageOneDoneTasksColumn)) {
      return true;
    }

    if (_checkForLockedTasks(this.stageTwoTasksColumn)) {
      return true;
    }

    if (_checkForLockedTasks(this.finishedTasksColumn)) {
      return true;
    }

    return false;
  }

  bool _checkForLockedTasks(List<Task> tasksList) {
    int length = tasksList.length;
    for (int i = 0; i < length; i++) {
      if (tasksList[i].isLocked()) {
        return true;
      }
    }

    return false;
  }

  void _setUpTaskLists() {
    this.idleTasksColumn = <Task>[];
    this.stageOneInProgressTasksColumn = <Task>[];
    this.stageOneDoneTasksColumn = <Task>[];
    this.stageTwoTasksColumn = <Task>[];
    this.finishedTasksColumn = <Task>[];
  }

  void _addRandomTasks(List<Task> tasks) {
    Random rand = new Random();
    int newTasks = rand.nextInt(3);
    for (int i = 0; i < newTasks; i++) {
      tasks.add(
        createRandomTask(),
      );
    }
  }

  TaskType _getRandomTaskType() {
    int randomIndex = Random().nextInt(3);
    return TaskType.values[randomIndex];
  }

  Task createRandomTask() {
    Random rand = new Random();

    Task randomTask = Task(
      "RANDOM TITLE",
      Random().nextInt(5) + 1,
      _getRandomUser(),
      _getRandomTaskType(),
    );

    randomTask = _fulfillTaskRandomly(randomTask);

    return randomTask;
  }

  Task _fulfillTaskRandomly(Task task) {
    task.investProductivity(
      Random().nextInt(task.owner.getProductivity() + 1),
    );

    var userList = this.getUsersList();
    int n = userList.length;

    for (int i = 0; i < n; i++) {
      User otherUser = userList[i];
      if (otherUser.getID() == task.owner.getID()) {
        continue;
      }

      int randomUserProductivity = otherUser.getProductivity();
      if (randomUserProductivity == 0) {
        continue;
      }

      int range = Random().nextInt(randomUserProductivity + 1);
      task.investProductivityFrom(
        otherUser,
        range,
      );
    }

    return task;
  }

  User _getRandomUser() {
    List<User> userList = this.getUsersList();
    int randomIndex = Random().nextInt(userList.length);

    return userList[randomIndex];
  }
}
