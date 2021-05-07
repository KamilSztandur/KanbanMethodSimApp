import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card_window/assign_productivity_popup.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card_window/confirm_task_deletion_popup.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card_window/lock_status_popup.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_progress.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskCardPopup {
  final Function(Task, User, int) productivityAssigned;
  final Function getCurrentDay;
  final Function getFinalDay;
  final Function taskUnlocked;
  final Function deleteTask;
  final Function getUsers;
  final Color taskCardColor;

  TaskCardPopup({
    @required this.getUsers,
    @required this.productivityAssigned,
    @required this.getCurrentDay,
    @required this.getFinalDay,
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
        productivityAssigned: this.productivityAssigned,
        getCurrentDay: this.getCurrentDay,
        getFinalDay: this.getFinalDay,
      ),
    );
  }
}

class _TaskCardPage extends StatefulWidget {
  final Function(Task, User, int) productivityAssigned;
  final Function getCurrentDay;
  final Function getFinalDay;
  final Function deleteTask;
  final Function taskUnlocked;
  final Function getUsers;
  final Color taskCardColor;
  final Task task;

  _TaskCardPage({
    Key key,
    @required this.task,
    @required this.deleteTask,
    @required this.productivityAssigned,
    @required this.getCurrentDay,
    @required this.getFinalDay,
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
        clipBehavior: Clip.none,
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
                  flex: 13,
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
                Flexible(flex: 3, child: Container()),
                Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: TaskProgress(
                    mode: Size.big,
                    task: this.widget.task,
                  ),
                ),
                Flexible(flex: 3, child: Container()),
              ],
            ),
          ),
          this.widget.task.getDeadlineDay() != -1
              ? Positioned(
                  top: -100,
                  child: _DeadlineDayInfo(
                    getCurrentDay: this.widget.getCurrentDay,
                    finalDay: this.widget.task.getDeadlineDay(),
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DeleteTaskButton(
                task: this.widget.task,
                deleteTask: this.widget.deleteTask,
              ),
              SizedBox(width: 550),
              _AssignProductivityButton(
                task: this.widget.task,
                getUsers: this.widget.getUsers,
                productivityAssigned: (Task task, User user, int value) {
                  setState(() {
                    this.widget.productivityAssigned(task, user, value);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeadlineDayInfo extends StatelessWidget {
  final Function getCurrentDay;
  final int finalDay;

  _DeadlineDayInfo({
    Key key,
    @required this.getCurrentDay,
    @required this.finalDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int daysLeft = _calcDaysLeft();

    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      height: 75,
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).accentColor
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
        border: Border.all(color: Theme.of(context).primaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.alarm_outlined,
              size: 70,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          Center(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: daysLeft > 0
                        ? "${AppLocalizations.of(context).timeLeftToCompleteTask}:\n"
                        : "",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: daysLeft > 0
                        ? "${daysLeft} ${AppLocalizations.of(context).days}"
                        : daysLeft == 0
                            ? "${AppLocalizations.of(context).theDeadlineIsToday}."
                            : "${AppLocalizations.of(context).theDeadlineWas} ${daysLeft.abs()} ${AppLocalizations.of(context).daysAgo}.",
                    style: TextStyle(
                      color: daysLeft > 0
                          ? Theme.of(context).primaryColor
                          : daysLeft == 0
                              ? Colors.amber
                              : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  int _calcDaysLeft() {
    return this.finalDay - this.getCurrentDay();
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
      message: task.isLocked()
          ? AppLocalizations.of(context).clickHereToUnlock
          : AppLocalizations.of(context).taskUnlocked,
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
            child: owner == null
                ? Container()
                : Tooltip(
                    message:
                        "${owner.getName()} ${AppLocalizations.of(context).isOwnerOfThisTask}",
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

class _AssignProductivityButton extends StatelessWidget {
  final Function(Task, User, int) productivityAssigned;
  final Function getUsers;
  final Task task;

  _AssignProductivityButton({
    Key key,
    @required this.productivityAssigned,
    @required this.getUsers,
    @required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return task.owner == null
        ? Container(width: 90)
        : Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Material(
                color: task.isLocked() ? Colors.grey : Colors.blue,
                child: InkWell(
                  hoverColor: task.isLocked() ? Colors.grey : Colors.purple,
                  child: SizedBox(
                    height: 90,
                    width: 90,
                    child: Tooltip(
                      message: task.isLocked()
                          ? AppLocalizations.of(context).unlockThisTaskFirst
                          : AppLocalizations.of(context).assignProductivity,
                      child: Icon(
                        Icons.assignment_ind_outlined,
                        color: Colors.white,
                        size: 65,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (!task.isLocked()) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AssignProductivityPopup(
                          getUsers: this.getUsers,
                          productivityAssigned: this.productivityAssigned,
                        ).show(context, task),
                      );
                    }
                  },
                ),
              ),
            ),
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
                message: AppLocalizations.of(context).deleteTask,
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
