import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/task_creator_popup.dart';
import 'package:kanbansim/models/task.dart';

class CreateTaskButton extends StatelessWidget {
  final Function getCurrentDay;
  final Function getMaxSimDay;
  final Function getUsers;
  final Function(Task) taskCreated;

  CreateTaskButton({
    Key key,
    @required this.getMaxSimDay,
    @required this.getCurrentDay,
    @required this.taskCreated,
    @required this.getUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.post_add),
          color: Theme.of(context).primaryColor,
          iconSize: 66,
          splashColor: Theme.of(context).primaryColor,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => TaskCreatorPopup(
                getCurrentDay: this.getCurrentDay,
                getMaxSimDay: this.getMaxSimDay,
                getUsers: this.getUsers,
                taskCreated: this.taskCreated,
              ).show(context),
            );
          },
        ),
      ),
    );
  }
}
