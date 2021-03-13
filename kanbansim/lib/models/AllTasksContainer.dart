import 'dart:math';

import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card.dart';

class AllTasksContainer {
  List<TaskCard> idleTasksColumn,
      stageOneInProgressTasksColumn,
      stageOneDoneTasksColumn,
      stageTwoTasksColumn,
      finishedTasksColumn;

  Function(TaskCard) _onRemove;

  AllTasksContainer(Function(TaskCard) onRemove) {
    _setUpTaskLists();

    this._onRemove = onRemove;
  }

  void createTask() {
    this.idleTasksColumn.add(TaskCard(this._onRemove));
  }

  void removeTask(TaskCard task) {
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

  void _setUpTaskLists() {
    this.idleTasksColumn = <TaskCard>[];
    this.stageOneInProgressTasksColumn = <TaskCard>[];
    this.stageOneDoneTasksColumn = <TaskCard>[];
    this.stageTwoTasksColumn = <TaskCard>[];
    this.finishedTasksColumn = <TaskCard>[];
  }

  void _addRandomTasks(List<TaskCard> tasks) {
    var rand = new Random();
    int newTasks = rand.nextInt(3);
    for (int i = 0; i < newTasks; i++) {
      tasks.add(TaskCard(
        this._onRemove,
      ));
    }
  }
}
