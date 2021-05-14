import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:kanbansim/features/final_page/tasks_chart.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';

class CharCalculator {
  final int MAX_DAY = 10;
  final AllTasksContainer allTasks;

  CharCalculator({
    @required this.allTasks,
  });

  List<Task> _getAllTasksOfType(TaskType type, List<Task> tasks) {
    return tasks.where((Task task) => task.getTaskType() == type).toList();
  }

  List<BarChartGroupData> getBars() {
    List<BarChartGroupData> bars = <BarChartGroupData>[];

    for (int i = 0; i <= MAX_DAY; i++) {
      bars.add(
        ChartColumnData(
          daysAmount: i,
          standardTasksAmount: _getAmountOfTasksWithCertainCompletionTime(
            TaskType.Standard,
            i,
          ),
          expediteTasksAmount: _getAmountOfTasksWithCertainCompletionTime(
            TaskType.Expedite,
            i,
          ),
          fixedDateTasksAmount: _getAmountOfTasksWithCertainCompletionTime(
            TaskType.FixedDate,
            i,
          ),
        ).getChartBarData(),
      );
    }

    return bars;
  }

  int _getAmountOfTasksWithCertainCompletionTime(TaskType type, int days) {
    int amount = 0;

    List<Task> tasks = _getAllTasksOfType(
      type,
      this.allTasks.finishedTasksColumn,
    );

    tasks.forEach((Task task) {
      if (task.getCompletionTime() == days) {
        amount++;
      }
    });

    return amount;
  }
}
