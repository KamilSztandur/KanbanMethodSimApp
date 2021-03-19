import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card_window/lock_status_popup.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_progress.dart';
import 'package:kanbansim/models/Task.dart';

class TaskCardPopup {
  final Function taskUnlocked;
  final Function getUsers;
  final Color taskCardColor;

  TaskCardPopup({
    @required this.getUsers,
    @required this.taskUnlocked,
    @required this.taskCardColor,
  });

  Widget show(BuildContext context, Task task) {
    return new Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: _TaskCardPage(
        task: task,
        taskCardColor: this.taskCardColor,
        taskUnlocked: this.taskUnlocked,
        getUsers: this.getUsers,
      ),
    );
  }
}

class _TaskCardPage extends StatefulWidget {
  final Function taskUnlocked;
  final Function getUsers;
  final Color taskCardColor;
  final Task task;

  _TaskCardPage({
    Key key,
    @required this.task,
    @required this.taskCardColor,
    @required this.getUsers,
    @required this.taskUnlocked,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskCardPageState();
}

class _TaskCardPageState extends State<_TaskCardPage> {
  Widget _buildTitle() {
    return SelectableText(
      widget.task.getTitle(),
      textAlign: TextAlign.center,
      style: GoogleFonts.pangolin(
        fontSize: 50,
        color: Colors.black,
      ),
    );
  }

  Widget _buildLockIcon() {
    return IgnorePointer(
      ignoring: !this.widget.task.isLocked(),
      child: IconButton(
        iconSize: 75,
        icon: Icon(
          widget.task.getProductivityRequiredToUnlock() != 0
              ? Icons.lock_rounded
              : Icons.lock_open_rounded,
          color: Colors.black,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => LockStatusPopup(
              getUsers: this.widget.getUsers,
              taskUnlocked: this.widget.taskUnlocked,
            ).show(
              context,
              this.widget.task,
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserIcon() {
    return IconButton(
      iconSize: 75,
      tooltip: "${widget.task.owner.getName()} is owner of this task.",
      icon: Icon(
        Icons.account_circle_outlined,
        color: widget.task.owner.getColor(),
      ),
      onPressed: () {},
    );
  }

  Widget _buildCloseButton() {
    return IconButton(
      icon: Icon(Icons.close),
      iconSize: 35,
      color: Colors.black,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        child: _buildLockIcon(),
                      ),
                      Flexible(
                        flex: 22,
                        fit: FlexFit.tight,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 35,
                        child: _buildUserIcon(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Flexible(
                      flex: 35,
                      child: _buildCloseButton(),
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
            child: _buildTitle(),
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
    );
  }
}
