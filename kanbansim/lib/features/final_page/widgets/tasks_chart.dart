import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksChart extends StatefulWidget {
  final List<BarChartGroupData> bars;

  TasksChart({
    Key key,
    @required this.bars,
  }) : super(key: key);

  @override
  _TasksChartState createState() => _TasksChartState();
}

class _TasksChartState extends State<TasksChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          minY: 0,
          maxY: _getMaxHeight(),
          groupsSpace: _calcGroupsSpace(),
          barTouchData: BarTouchData(
            enabled: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (double value) => "${value.toInt()}",
              getTextStyles: (value) => const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontFamily: 'Digital',
                fontSize: 15,
              ),
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (double value) => "${value.toInt()}",
              getTextStyles: (value) => const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontFamily: 'Digital',
                fontSize: 15,
              ),
            ),
          ),
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
              showTitle: true,
              titleText: AppLocalizations.of(context).amountOfCompletedTasks,
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15,
              ),
            ),
            bottomTitle: AxisTitle(
              showTitle: true,
              titleText:
                  '${AppLocalizations.of(context).completionTime} [${AppLocalizations.of(context).days}]',
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15,
              ),
            ),
            topTitle: AxisTitle(
              showTitle: true,
              margin: 20,
              titleText: AppLocalizations.of(context)
                  .amountOfTasksAndTheirCompletionTime
                  .toUpperCase(),
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.grey),
              right: BorderSide(color: Colors.grey),
              top: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          barGroups: this.widget.bars,
        ),
        swapAnimationDuration: Duration(milliseconds: 2500),
        swapAnimationCurve: Curves.decelerate,
      ),
    );
  }

  double _calcGroupsSpace() {
    double defaultGroupsSpace = 20;
    int defaultAmountOfBars = 10;

    int n = this.widget.bars.length;

    return defaultGroupsSpace * (defaultAmountOfBars / n);
  }

  double _getMaxHeight() {
    double maxHeight = 0;

    int n = this.widget.bars.length;
    for (int i = 0; i < n; i++) {
      double thisHeight = this.widget.bars[i].barRods[0].y;
      if (thisHeight > maxHeight) {
        maxHeight = thisHeight;
      }
    }

    maxHeight++; // Visual aesthetics

    return maxHeight;
  }
}

class ChartColumnData {
  final Color standardColor = Colors.yellowAccent;
  final Color expediteColor = Colors.redAccent;
  final Color fixedDateColor = Colors.lightBlueAccent;

  final int daysAmount;
  final int standardTasksAmount;
  final int expediteTasksAmount;
  final int fixedDateTasksAmount;

  ChartColumnData({
    @required this.daysAmount,
    @required this.standardTasksAmount,
    @required this.expediteTasksAmount,
    @required this.fixedDateTasksAmount,
  });

  BarChartGroupData getChartBarData() {
    double sum = (this.standardTasksAmount +
            this.expediteTasksAmount +
            this.fixedDateTasksAmount)
        .toDouble();

    return BarChartGroupData(
      x: this.daysAmount,
      barRods: [
        BarChartRodData(
          y: sum,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          colors: [Colors.transparent],
          rodStackItems: [
            BarChartRodStackItem(
              0,
              this.standardTasksAmount.toDouble(),
              standardColor,
            ),
            BarChartRodStackItem(
              this.standardTasksAmount.toDouble(),
              (this.standardTasksAmount + this.expediteTasksAmount).toDouble(),
              expediteColor,
            ),
            BarChartRodStackItem(
              (this.standardTasksAmount + this.expediteTasksAmount).toDouble(),
              sum,
              fixedDateColor,
            ),
          ],
        ),
      ],
    );
  }
}
