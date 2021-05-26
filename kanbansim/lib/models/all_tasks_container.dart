import 'package:kanbansim/models/task.dart';

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
}
