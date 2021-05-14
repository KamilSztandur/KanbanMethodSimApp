import 'package:flutter/material.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';
import 'package:kanbansim/models/User.dart';

class ScoreCalculator {
  final AllTasksContainer allTasks;
  final List<User> users;

  final double standardTaskWeight = 1.0;
  final double expediteTaskWeight = 2.0;
  final double fixedDateTaskWeight = 1.5;

  final double fixedDateBeforeDeadlineModifier = 1.5;
  final double fixedDateOnDeadlineModifier = 1.0;
  final double fixedDateAfterDeadlineTimeModifier = 0.75;

  final double smallTeamBonus = 10.0;
  final int smallTeamBonusMaxTeamMembers = 3;

  final double afterFirstStageTasksBonusWeight = 0.25;

  ScoreCalculator({
    @required this.allTasks,
    @required this.users,
  });

  double calculate() {
    double sum = 0.0;

    sum += sumAllStandardTasks();
    sum += sumAllExpediteTasks();
    sum += sumAllFixedDateTasks();
    sum += _sumAllBonuses();

    return sum;
  }

  int countFinishedTaskWithType(TaskType type) {
    return _getAmountOfAllTasksOfType(type, allTasks.finishedTasksColumn);
  }

  int getMaxUsersAmountForBonus() {
    return this.smallTeamBonusMaxTeamMembers;
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

  double calcScoreFromFixedDateTasksBeforeDeadline() {
    int amount = getAmountOfFixedDateTasksBeforeDeadline();
    return amount * fixedDateOnDeadlineModifier;
  }

  double calcScoreFromFixedDateTasksOnDeadline() {
    int amount = getAmountOfFixedDateTasksOnDeadline();
    return amount * fixedDateOnDeadlineModifier;
  }

  double calcScoreFromFixedDateTasksAfterDeadline() {
    int amount = getAmountOfFixedDateTasksAfterDeadline();
    return amount * fixedDateOnDeadlineModifier;
  }

  double sumAllStandardTasks() {
    int standardTasksAmount = _getAmountOfAllTasksOfType(
      TaskType.Standard,
      allTasks.finishedTasksColumn,
    );

    return standardTasksAmount * standardTaskWeight;
  }

  double sumAllExpediteTasks() {
    int expediteTasksAmount = _getAmountOfAllTasksOfType(
      TaskType.Expedite,
      allTasks.finishedTasksColumn,
    );

    return expediteTasksAmount * expediteTaskWeight;
  }

  double sumAllFixedDateTasks() {
    double sum = 0.0;

    sum += calcScoreFromFixedDateTasksBeforeDeadline();
    sum += calcScoreFromFixedDateTasksOnDeadline();
    sum += calcScoreFromFixedDateTasksAfterDeadline();

    return sum;
  }

  double _sumAllBonuses() {
    double sum = 0.0;

    sum += sumSmallTeamBonus();
    sum += sumAfterFirstStageTasksBonus();

    return sum;
  }

  double sumSmallTeamBonus() {
    if (this.users.length <= this.smallTeamBonusMaxTeamMembers) {
      return smallTeamBonus;
    } else {
      return 0.0;
    }
  }

  double sumAfterFirstStageTasksBonus() {
    int sum = getAmountOfTasksAfterFirstStage();

    return sum * this.afterFirstStageTasksBonusWeight;
  }

  int getAmountOfTasksAfterFirstStage() {
    int stageTwoAmount = this.allTasks.stageTwoTasksColumn.length;
    int stageOneDoneAmount = this.allTasks.stageOneDoneTasksColumn.length;
    return stageOneDoneAmount + stageTwoAmount;
  }

  int _getAmountOfAllTasksOfType(TaskType type, List<Task> tasks) {
    return _getAllTasksOfType(type, tasks).length;
  }

  List<Task> _getAllTasksOfType(TaskType type, List<Task> tasks) {
    return tasks.where((Task task) => task.getTaskType() == type).toList();
  }
}
