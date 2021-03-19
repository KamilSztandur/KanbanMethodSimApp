import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_progress.dart';
import 'package:kanbansim/models/Task.dart';

class TaskStatus extends StatefulWidget {
  final Task task;

  TaskStatus({@required this.task});

  @override
  State<StatefulWidget> createState() => TaskStatusState();
}

class TaskStatusState extends State<TaskStatus> {
  TaskProgress _buildTaskProgressBar() {
    return TaskProgress(
      task: this.widget.task,
      mode: Size.small,
    );
  }

  Widget _buildUserIcon() {
    return IgnorePointer(
      ignoring: true,
      child: IconButton(
        iconSize: 15,
        icon: Icon(
          Icons.account_circle_outlined,
          color: widget.task.owner.getColor(),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildLockIcon() {
    return IgnorePointer(
      ignoring: true,
      child: IconButton(
        iconSize: 17,
        icon: Icon(
          widget.task.getProductivityRequiredToUnlock() != 0
              ? Icons.lock_rounded
              : Icons.lock_open_rounded,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      widget.task.getTitle(),
      textAlign: TextAlign.center,
      style: GoogleFonts.pangolin(
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 10,
          child: Row(
            children: [
              Flexible(
                flex: 5,
                child: _buildLockIcon(),
              ),
              Flexible(flex: 5, fit: FlexFit.tight, child: Container()),
              Flexible(flex: 5, child: _buildUserIcon()),
              Flexible(flex: 15, fit: FlexFit.tight, child: Container()),
            ],
          ),
        ),
        Flexible(flex: 5, child: Container()),
        Flexible(
          flex: 20,
          child: _buildTitle(),
        ),
        Flexible(flex: 5, child: Container()),
        Flexible(
          flex: 8,
          fit: FlexFit.tight,
          child: _buildTaskProgressBar(),
        ),
        Flexible(flex: 3, child: Container()),
      ],
    );
  }
}
