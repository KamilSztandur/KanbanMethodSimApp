import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/notifications/feedback_popup.dart';

class TaskCard extends StatelessWidget {
  static int _tasksNumber = 1;
  Function(TaskCard) deleteMeFromBoard;

  int _taskID;

  TaskCard(Function(TaskCard) deleteMeFromBoard) {
    this.deleteMeFromBoard = deleteMeFromBoard;
    this._taskID = _tasksNumber;
    _tasksNumber++;
  }

  int getID() {
    return this._taskID;
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
      child: new Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.yellowAccent,
          border: Border.all(),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 1,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            "#$_taskID",
            style: GoogleFonts.indieFlower(
              fontSize: 58,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
