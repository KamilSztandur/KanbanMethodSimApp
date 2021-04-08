import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card_window/task_card_popup.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_status.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';

class TaskCard extends StatelessWidget {
  final Function taskUnlocked;
  final Function getUsers;
  Function(Task) deleteMe;
  Color _taskCardColor;
  Task task;

  TaskCard({
    @required this.task,
    @required this.deleteMe,
    @required this.getUsers,
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
            taskUnlocked: this.taskUnlocked,
            taskCardColor: this._taskCardColor,
            deleteTask: () => deleteMe(this.task),
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
