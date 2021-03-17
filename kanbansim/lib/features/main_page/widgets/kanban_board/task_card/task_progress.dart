import 'package:flutter/material.dart';
import 'package:kanbansim/models/Task.dart';

class TaskProgress extends StatelessWidget {
  final Task task;

  TaskProgress({
    Key key,
    @required this.task,
  }) : super(key: key);

  List<Widget> _buildFormattedTasksList() {
    List<Widget> tasksRow = <Widget>[];

    tasksRow.add(SizedBox(height: 15));

    int allDots = this.task.progress.getNumberOfAllParts();
    for (int i = 0; i < allDots; i++) {
      tasksRow.add(SizedBox(width: 5));
      if (this.task.progress.isFulfilled(i)) {
        tasksRow.add(
          Icon(
            Icons.circle,
            size: 5,
            color: this.task.progress.getUserColor(i),
          ),
        );
      } else {
        tasksRow.add(
          Icon(
            Icons.trip_origin,
            size: 5,
            color: Colors.black,
          ),
        );
      }
    }
    tasksRow.add(SizedBox(width: 5));

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
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildFormattedTasksList(),
            ),
          ),
        ),
        Flexible(flex: 2, child: Container()),
      ],
    );
  }
}
