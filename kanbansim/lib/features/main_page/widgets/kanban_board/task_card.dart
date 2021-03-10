import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/notifications/feedback_popup.dart';

class TaskCard extends StatelessWidget {
  KanbanBoardState boardPointer;
  static int _tasksNumber = 1;
  int _taskID;

  TaskCard(KanbanBoardState parent) {
    this.boardPointer = parent;
    this._taskID = _tasksNumber;
    _tasksNumber++;
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
      onLongPress: () {
        _deleteMeFromList();
      },
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

  void _deleteMeFromList() {
    this.boardPointer.removeTask(this);
  }

  int getIndexIfImHere(List<TaskCard> list) {
    int length = list.length;
    for (int i = 0; i < length; i++) {
      var otherTask = list[i];
      if (this._taskID == otherTask.getID()) {
        return i;
      }
    }

    return -1;
  }

  int getID() {
    return this._taskID;
  }
}
