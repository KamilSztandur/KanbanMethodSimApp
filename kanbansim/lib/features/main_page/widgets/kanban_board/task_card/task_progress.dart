import 'package:flutter/material.dart';
import 'package:kanbansim/models/Task.dart';

enum Size {
  small,
  big,
}

class TaskProgress extends StatelessWidget {
  final Task task;
  final Size mode;

  TaskProgress({Key key, @required this.task, @required this.mode})
      : super(key: key);

  List<Widget> _getFormattedTasksList(BuildContext context) {
    List<Widget> tasksRow = <Widget>[];

    tasksRow.add(
      Flexible(flex: 1, child: Container()),
    );

    int allDots = this.task.progress.getNumberOfAllParts();
    for (int i = 0; i < allDots; i++) {
      if (this.task.progress.isFulfilled(i)) {
        tasksRow.add(
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: _ProgressDot(
              mode: mode,
              color: this.task.progress.getUserColor(i),
            ),
          ),
        );
      } else {
        tasksRow.add(
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: _ProgressDot(
              mode: mode,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade100
                  : Colors.grey.shade800,
            ),
          ),
        );
      }
    }

    tasksRow.add(
      Flexible(flex: 1, child: Container()),
    );

    return tasksRow;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 2, child: Container()),
        Flexible(
          flex: 6,
          fit: FlexFit.tight,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade100
                  : Colors.grey.shade700,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  this.mode == Size.big ? 50.0 : 15.0,
                ),
              ),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _getFormattedTasksList(context),
            ),
          ),
        ),
        Flexible(flex: 2, child: Container()),
      ],
    );
  }
}

class _ProgressDot extends StatelessWidget {
  final Color color;
  final Size mode;

  _ProgressDot({
    Key key,
    @required this.color,
    @required this.mode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.mode == Size.big ? 25.0 : 5.0,
      width: this.mode == Size.big ? 25.0 : 5.0,
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.all(
          Radius.circular(
            this.mode == Size.big ? 25.0 : 5.0,
          ),
        ),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      ),
    );
  }
}
