import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_status.dart';
import 'package:kanbansim/features/notifications/feedback_popup.dart';
import 'package:kanbansim/models/Task.dart';

class TaskCard extends StatelessWidget {
  Function(Task) deleteMe;
  Task _task;

  TaskCard(Task task, Function(Task) deleteMe) {
    this.deleteMe = deleteMe;
    this._task = task;
  }

  int getID() {
    return this._task.getID();
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
            "Task #${getID()} selected.",
          ),
        );
      },
      onLongPress: () => deleteMe(this._task),
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
        child: TaskStatus(task: this._task),
      ),
    );
  }
}
