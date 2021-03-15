import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/notifications/feedback_popup.dart';

class TaskCard extends StatelessWidget {
  static int _tasksNumber = 1;
  Function(TaskCard) deleteMeFromBoard;

  int _taskID;
  int _productivityRequiredToUnlock;
  int _productivityNeeded;
  int _productivityInvested;
  String _title;

  TaskCard(Function(TaskCard) deleteMeFromBoard) {
    this.deleteMeFromBoard = deleteMeFromBoard;
    this._taskID = _tasksNumber;
    _tasksNumber++;

    _test_setRandomTaskStatusValues();
  }

  int getID() {
    return this._taskID;
  }

  void _test_setRandomTaskStatusValues() {
    var dice = Random().nextInt(6) + 1;
    this._productivityRequiredToUnlock = dice == 1 ? 1 : 0;
    this._productivityNeeded = Random().nextInt(5) + 1;
    this._productivityInvested = Random().nextInt(this._productivityNeeded);
    this._title = '';
  }

  List<Widget> _buildFormattedTasksList() {
    List<Widget> tasksRow = <Widget>[];

    tasksRow.add(SizedBox(height: 15));
    for (int i = 0; i < this._productivityNeeded; i++) {
      tasksRow.add(SizedBox(width: 5));
      if (i < this._productivityInvested) {
        tasksRow.add(
          Icon(
            Icons.circle,
            size: 5,
            color: Colors.black,
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

  Widget _buildTaskStatusBar() {
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
    /*
    SizedBox(height: 15)
                          SizedBox(width: 5),
                          Icon(Icons.trip_origin, size: 5),
                          SizedBox(width: 5),
                          Icon(Icons.circle, size: 5),
                          SizedBox(width: 5),
                          Icon(Icons.circle, size: 5),
                          SizedBox(width: 5),
                          Icon(Icons.circle, size: 5),
                          SizedBox(width: 5),
                          Icon(Icons.circle, size: 5),
                          SizedBox(width: 5),
                          */
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => FeedbackPopUp.show(
            context,
            "Attention!",
            "Task #$_taskID selected.",
          ),
        );
      },
      onLongPress: () => deleteMeFromBoard(this),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Color.fromRGBO(255, 231, 156, 1.0)
              : Color.fromRGBO(249, 216, 118, 1.0),
          border: Border.all(),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: IgnorePointer(
                      ignoring: true,
                      child: IconButton(
                        iconSize: 17,
                        icon: Icon(
                          this._productivityRequiredToUnlock != 0
                              ? Icons.lock_rounded
                              : Icons.lock_open_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Flexible(flex: 4, child: Container()),
                ],
              ),
            ),
            Flexible(flex: 5, child: Container()),
            Flexible(
              flex: 20,
              child: Text(
                "Task number #$_taskID",
                textAlign: TextAlign.center,
                style: GoogleFonts.pangolin(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(flex: 5, child: Container()),
            Flexible(
              flex: 8,
              fit: FlexFit.tight,
              child: _buildTaskStatusBar(),
            ),
            Flexible(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }
}
