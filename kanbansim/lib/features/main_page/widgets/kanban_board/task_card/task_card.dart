import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card_window/task_card_popup.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_status.dart';
import 'package:kanbansim/models/task.dart';
import 'package:kanbansim/models/task_type.dart';
import 'package:kanbansim/models/user.dart';

class TaskCard extends StatelessWidget {
  final Function(Task, User, int) productivityAssigned;
  final Function(Task) taskUnlocked;
  final Function getUsers;
  final Function getCurrentDay;
  final Function getFinalDay;
  Function(Task) deleteMe;
  Color _taskCardColor;
  Task task;

  TaskCard({
    @required this.task,
    @required this.productivityAssigned,
    @required this.deleteMe,
    @required this.getUsers,
    @required this.getCurrentDay,
    @required this.getFinalDay,
    @required this.taskUnlocked,
  });

  int getID() {
    return this.task.getID();
  }

  Color _getTaskTypeColor(TaskType type) {
    switch (type) {
      case TaskType.Standard:
        return Color.fromRGBO(245, 237, 123, 1.0); // Yellow
        break;

      case TaskType.Expedite:
        return Color.fromRGBO(247, 100, 115, 1.0); // Red
        break;

      case TaskType.FixedDate:
        return Color.fromRGBO(86, 179, 226, 1.0); // Blue
        break;

      default:
        return Color.fromRGBO(255, 231, 156, 1.0); // Default
    }
  }

  @override
  Widget build(BuildContext context) {
    this._taskCardColor = _getTaskTypeColor(task.getTaskType());

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => TaskCardPopup(
            getUsers: this.getUsers,
            taskUnlocked: () => this.taskUnlocked(this.task),
            taskCardColor: this._taskCardColor,
            deleteTask: () => deleteMe(this.task),
            productivityAssigned: this.productivityAssigned,
            getCurrentDay: this.getCurrentDay,
            getFinalDay: this.getFinalDay,
          ).show(
            context,
            task,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(0.0),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: this._taskCardColor,
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
        child: TaskStatus(task: this.task),
      ),
    );
  }
}
