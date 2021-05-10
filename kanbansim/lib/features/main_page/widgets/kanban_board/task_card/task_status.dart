import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_completed_icon.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_completed_text.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_progress.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';

class TaskStatus extends StatefulWidget {
  final Task task;

  TaskStatus({@required this.task});

  @override
  State<StatefulWidget> createState() => TaskStatusState();
}

class TaskStatusState extends State<TaskStatus> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(flex: 3, fit: FlexFit.tight, child: Container()),
        Flexible(
          flex: 13,
          fit: FlexFit.tight,
          child: Row(
            children: [
              Flexible(flex: 3, fit: FlexFit.tight, child: Container()),
              Flexible(flex: 10, child: _LockIcon(task: this.widget.task)),
              Flexible(flex: 6, fit: FlexFit.tight, child: Container()),
              Flexible(
                flex: 10,
                child: _UserIcon(
                  owner: this.widget.task.owner,
                  isFinished: this.widget.task.stage == 3,
                ),
              ),
              Flexible(flex: 20, fit: FlexFit.tight, child: Container()),
            ],
          ),
        ),
        Flexible(flex: 3, child: Container()),
        Flexible(
          flex: 20,
          fit: FlexFit.tight,
          child: _Title(title: this.widget.task.getTitle()),
        ),
        Flexible(flex: 3, child: Container()),
        Flexible(
          flex: 8,
          fit: FlexFit.tight,
          child: this.widget.task.stage == 3
              ? TaskCompletedText(size: 10)
              : TaskProgress(
                  task: this.widget.task,
                  mode: Size.small,
                ),
        ),
        Flexible(flex: 5, child: Container()),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  _Title({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.pangolin(
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }
}

class _LockIcon extends StatelessWidget {
  final Task task;

  _LockIcon({Key key, @required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: this.task.stage == 3,
      child: IgnorePointer(
        ignoring: true,
        child: SizedBox(
          height: 20,
          width: 20,
          child: Center(
            child: Icon(
              task.getProductivityRequiredToUnlock() != 0
                  ? Icons.lock_rounded
                  : Icons.lock_open_rounded,
              color: this.task.stage == 3 ? Colors.transparent : Colors.black,
              size: 17,
            ),
          ),
        ),
      ),
    );
  }
}

class _UserIcon extends StatelessWidget {
  final bool isFinished;
  final User owner;

  _UserIcon({Key key, @required this.isFinished, @required this.owner})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: this.isFinished ? Colors.green : Colors.grey.shade700,
        child: InkWell(
          hoverColor: Colors.red,
          child: SizedBox(
            height: 20,
            width: 20,
            child: Center(
              child: this.isFinished
                  ? TaskCompletedIcon(size: 15)
                  : owner == null
                      ? Container()
                      : Icon(
                          Icons.account_circle_outlined,
                          color: owner.getColor(),
                          size: 16,
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
