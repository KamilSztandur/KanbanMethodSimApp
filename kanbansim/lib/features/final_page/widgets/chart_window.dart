import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/common/chart_calculator.dart';
import 'package:kanbansim/features/final_page/widgets/tasks_chart.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';

class ChartWindow extends StatelessWidget {
  final AllTasksContainer allTasks;

  const ChartWindow({
    Key key,
    @required this.allTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 25,
        bottom: 25,
        right: 65,
        left: 20,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          )),
      child: TasksChart(
        bars: _getBars(),
      ),
    );
  }

  List<BarChartGroupData> _getBars() {
    CharCalculator calculator = CharCalculator(allTasks: this.allTasks);
    return calculator.getBars();
  }
}
