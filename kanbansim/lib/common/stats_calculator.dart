import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';

class StatsCalculator {
  final AllTasksContainer allTasks;

  StatsCalculator({
    @required this.allTasks,
  });

  double countAverageOfCompletionTime() {
    double sum = 0.0;
    int amount = 0;

    allTasks.finishedTasksColumn.forEach((Task task) {
      int completionTime = task.getCompletionTime();

      if (completionTime >= 0) {
        sum += completionTime;
        amount++;
      }
    });

    if (amount == 0) {
      return 0;
    } else {
      return sum / amount;
    }
  }

  double countStandardDeviationOfCompletionTime() {
    double sum = 0.0;
    int amount = 0;

    double averageTime = this.countAverageOfCompletionTime();

    allTasks.finishedTasksColumn.forEach((Task task) {
      int completionTime = task.getCompletionTime();

      if (completionTime >= 0) {
        sum += pow(averageTime - completionTime, 2);
        amount++;
      }
    });
    if (amount == 0) {
      return 0;
    } else {
      return sqrt(sum / amount);
    }
  }

  int getAmountOfFinishedTasks() {
    return this.allTasks.finishedTasksColumn.length;
  }

  int countFinishedTaskWithType(TaskType type) {
    return _getAmountOfAllTasksOfType(type, allTasks.finishedTasksColumn);
  }

  int getAmountOfFixedDateTasksBeforeDeadline() {
    int amount = 0;

    List<Task> fixedDateTasks = _getAllTasksOfType(
      TaskType.FixedDate,
      allTasks.finishedTasksColumn,
    );

    int n = fixedDateTasks.length;
    for (int i = 0; i < n; i++) {
      int days = fixedDateTasks[i].getDeadlineDay() - fixedDateTasks[i].endDay;

      if (days > 0) {
        amount++;
      }
    }

    return amount;
  }

  int getAmountOfFixedDateTasksOnDeadline() {
    int amount = 0;

    List<Task> fixedDateTasks = _getAllTasksOfType(
      TaskType.FixedDate,
      allTasks.finishedTasksColumn,
    );

    int n = fixedDateTasks.length;
    for (int i = 0; i < n; i++) {
      int days = fixedDateTasks[i].getDeadlineDay() - fixedDateTasks[i].endDay;

      if (days == 0) {
        amount++;
      }
    }

    return amount;
  }

  int getAmountOfFixedDateTasksAfterDeadline() {
    int amount = 0;

    List<Task> fixedDateTasks = _getAllTasksOfType(
      TaskType.FixedDate,
      allTasks.finishedTasksColumn,
    );

    int n = fixedDateTasks.length;
    for (int i = 0; i < n; i++) {
      int days = fixedDateTasks[i].getDeadlineDay() - fixedDateTasks[i].endDay;

      if (days < 0) {
        amount++;
      }
    }

    return amount;
  }

  List<Task> _getAllTasksOfType(TaskType type, List<Task> tasks) {
    return tasks.where((Task task) => task.getTaskType() == type).toList();
  }

  int _getAmountOfAllTasksOfType(TaskType type, List<Task> tasks) {
    return _getAllTasksOfType(type, tasks).length;
  }
}
