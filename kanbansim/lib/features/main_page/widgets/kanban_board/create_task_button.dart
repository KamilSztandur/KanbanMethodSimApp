import 'package:flutter/material.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';

class CreateTaskButton extends StatelessWidget {
  final VoidCallback createNewTask;

  CreateTaskButton({
    Key key,
    @required this.createNewTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.post_add),
          color: Theme.of(context).primaryColor,
          iconSize: 100,
          splashColor: Theme.of(context).primaryColor,
          onPressed: () {
            this.createNewTask();

            SubtleMessage.messageWithContext(
              context,
              "New task added successfuly.",
            );
          },
        ),
      ),
    );
  }
}
