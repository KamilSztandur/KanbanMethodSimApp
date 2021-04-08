import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card_window/confirm_task_deletion_popup.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card_window/lock_status_popup.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_progress.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';

class TaskCardPopup {
  final Function taskUnlocked;
  final Function deleteTask;
  final Function getUsers;
  final Color taskCardColor;

  TaskCardPopup({
    @required this.getUsers,
    @required this.taskUnlocked,
    @required this.deleteTask,
    @required this.taskCardColor,
  });

  Widget show(BuildContext context, Task task) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _TaskCardPage(
        task: task,
        taskCardColor: this.taskCardColor,
        taskUnlocked: this.taskUnlocked,
        deleteTask: this.deleteTask,
        getUsers: this.getUsers,
      ),
    );
  }
}

class _TaskCardPage extends StatefulWidget {
  final Function deleteTask;
  final Function taskUnlocked;
  final Function getUsers;
  final Color taskCardColor;
  final Task task;

  _TaskCardPage({
    Key key,
    @required this.task,
    @required this.deleteTask,
    @required this.taskCardColor,
    @required this.getUsers,
    @required this.taskUnlocked,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskCardPageState();
}

class _TaskCardPageState extends State<_TaskCardPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 800,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: 500,
            width: 500,
            decoration: BoxDecoration(
              color: widget.taskCardColor,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Row(
                          children: [
                            Flexible(
                              flex: 35,
                              child: _LockIcon(
                                task: this.widget.task,
                                getUsers: this.widget.getUsers,
                                taskUnlocked: this.widget.taskUnlocked,
                              ),
                            ),
                            Flexible(
                              flex: 22,
                              fit: FlexFit.tight,
                              child: Container(),
                            ),
                            Flexible(
                              flex: 35,
                              child: _UserIcon(owner: this.widget.task.owner),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Flexible(
                            flex: 35,
                            child: _CloseButton(),
                          ),
                          Flexible(flex: 7, child: Container()),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(flex: 3, child: Container()),
                Flexible(
                  flex: 20,
                  fit: FlexFit.tight,
                  child: _Title(title: this.widget.task.getTitle()),
                ),
                Flexible(flex: 5, child: Container()),
                Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: TaskProgress(
                    mode: Size.big,
                    task: this.widget.task,
                  ),
                ),
                Flexible(flex: 5, child: Container()),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DeleteTaskButton(
                task: this.widget.task,
                deleteTask: this.widget.deleteTask,
              ),
              SizedBox(width: 650),
            ],
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  _Title({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.pangolin(
        fontSize: 50,
        color: Colors.black,
      ),
    );
  }
}

class _LockIcon extends StatelessWidget {
  final Function taskUnlocked;
  final Function getUsers;
  final Task task;

  _LockIcon({
    Key key,
    @required this.task,
    @required this.getUsers,
    @required this.taskUnlocked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: task.isLocked() ? "Click here to unlock task" : "Task unlocked",
      child: IgnorePointer(
        ignoring: !task.isLocked(),
        child: IconButton(
          iconSize: 75,
          icon: Icon(
            task.getProductivityRequiredToUnlock() != 0
                ? Icons.lock_rounded
                : Icons.lock_open_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => LockStatusPopup(
                getUsers: getUsers,
                taskUnlocked: taskUnlocked,
              ).show(
                context,
                task,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _UserIcon extends StatelessWidget {
  final User owner;

  _UserIcon({Key key, @required this.owner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.grey.shade700,
        child: InkWell(
          hoverColor: Colors.red,
          child: SizedBox(
            height: 90,
            width: 90,
            child: Tooltip(
              message: "${owner.getName()} is owner of this task.",
              child: Center(
                child: Icon(
                  Icons.account_circle_outlined,
                  color: owner.getColor(),
                  size: 70,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      iconSize: 35,
      color: Colors.black,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class _DeleteTaskButton extends StatelessWidget {
  final Function deleteTask;
  final Task task;

  _DeleteTaskButton({
    Key key,
    @required this.task,
    @required this.deleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Material(
          color: Colors.blue,
          child: InkWell(
            hoverColor: Colors.red,
            child: SizedBox(
              height: 90,
              width: 90,
              child: Tooltip(
                message: "Usuń zadanie",
                child: Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.white,
                  size: 65,
                ),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => ConfirmTaskDeletionPopup(
                  deleteTask: this.deleteTask,
                ).show(context, task),
              );
            },
          ),
        ),
      ),
    );
  }
}
