import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/create_task_button.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_column.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/set_owner_popup.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/models/User.dart';

class KanbanBoard extends StatefulWidget {
  final Function(Task, User, int) productivityAssigned;
  final Function(Task) deleteMe;
  final Function(Task) taskCreated;
  final Function taskUnlocked;
  final Function getMaxSimDay;
  final Function getCurrentDay;
  final Function getUsers;
  final Function getFinalDay;
  final Function getAllTasks;
  final Function getStageOneInProgressLimit;
  final Function getStageOneDoneLimit;
  final Function getStageTwoLimit;
  final double defaultMinColumnHeight;

  KanbanBoard({
    Key key,
    @required this.getAllTasks,
    @required this.taskCreated,
    @required this.deleteMe,
    @required this.productivityAssigned,
    @required this.taskUnlocked,
    @required this.getMaxSimDay,
    @required this.getCurrentDay,
    @required this.getFinalDay,
    @required this.getUsers,
    @required this.getStageOneInProgressLimit,
    @required this.getStageOneDoneLimit,
    @required this.getStageTwoLimit,
    @required this.defaultMinColumnHeight,
  }) : super(key: key);

  @override
  KanbanBoardState createState() => KanbanBoardState();
}

class KanbanBoardState extends State<KanbanBoard> {
  List<String> columns = [
    "available",
    "stage one in progress",
    "stage one done",
    "stage two",
    "finished",
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 20,
          child: Column(
            children: [
              KanbanColumn(
                title: AppLocalizations.of(context).availableTasks,
                isInternal: false,
                tasks:
                    _parseTaskCardsList(widget.getAllTasks().idleTasksColumn),
                getAllTasks: this.widget.getAllTasks,
                onTaskDropped: (Task task) {
                  if (_isNotFromTheSameColumn("available", task.getID())) {
                    task.owner = null;
                    this._switchTasks("available", task.getID());
                  }
                },
                additionalWidget: _NewTaskButton(
                  getCurrentDay: this.widget.getCurrentDay,
                  getMaxSimDay: this.widget.getMaxSimDay,
                  taskCreated: this.widget.taskCreated,
                  getUsers: this.widget.getUsers,
                ),
                isNotFromTheSameColumn: (int taskID) =>
                    this._isNotFromTheSameColumn("available", taskID),
                areRequirementsMet: (Task task) => false,
                defaultMinColumnHeight: this.widget.defaultMinColumnHeight,
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 40,
          child: _StageOneTasksDoubleColumn(
            inProgressTasks: widget.getAllTasks().stageOneInProgressTasksColumn,
            doneTasks: widget.getAllTasks().stageOneDoneTasksColumn,
            getAllTasks: this.widget.getAllTasks,
            ownerSet: () => setState(() {}),
            getUsers: this.widget.getUsers,
            getCurrentDay: this.widget.getCurrentDay,
            getMaxSimDay: this.widget.getMaxSimDay,
            getStageOneInProgressLimit: this.widget.getStageOneInProgressLimit,
            getStageOneDoneLimit: this.widget.getStageOneDoneLimit,
            switchTasks: this._switchTasks,
            parseTaskCardsList: (List<Task> tasks) {
              return this._parseTaskCardsList(tasks);
            },
            isNotFromTheSameColumn: this._isNotFromTheSameColumn,
            defaultMinColumnHeight: this.widget.defaultMinColumnHeight,
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 20,
          child: KanbanColumn(
            title: AppLocalizations.of(context).stageTwoTasks,
            isInternal: false,
            getAllTasks: this.widget.getAllTasks,
            onTaskDropped: (Task task) => showDialog(
              context: context,
              builder: (BuildContext context) => SetOwnerPopup(
                task: task,
                columnName: "stage two",
                moveTask: this._switchTasks,
                getAllUsers: this.widget.getUsers,
                ownerSet: () => setState(() {
                  task.stage = 2;
                }),
              ).show(),
            ),
            tasksLimit: this.widget.getStageTwoLimit(),
            defaultMinColumnHeight: this.widget.defaultMinColumnHeight,
            tasks:
                _parseTaskCardsList(widget.getAllTasks().stageTwoTasksColumn),
            isNotFromTheSameColumn: (int taskID) =>
                this._isNotFromTheSameColumn("stage two", taskID),
            areRequirementsMet: (Task task) =>
                task.stage == 1 && task.owner == null,
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 20,
          child: KanbanColumn(
            title: AppLocalizations.of(context).finishedTasks,
            isInternal: false,
            getAllTasks: this.widget.getAllTasks,
            onTaskDropped: (Task task) {
              task.owner = null;
              task.stage = 3;
              task.progress.clearInvestedProductivity();
              this._switchTasks("finished", task.getID());
            },
            areRequirementsMet: (Task task) =>
                task.stage == 2 &&
                task.progress.getNumberOfUnfulfilledParts() == 0,
            modifyTask: (Task task) =>
                task.endDay = this.widget.getCurrentDay(),
            defaultMinColumnHeight: this.widget.defaultMinColumnHeight,
            tasks:
                _parseTaskCardsList(widget.getAllTasks().finishedTasksColumn),
            isNotFromTheSameColumn: (int taskID) =>
                this._isNotFromTheSameColumn("finished", taskID),
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }

  List<TaskCard> _parseTaskCardsList(List<Task> tasksList) {
    List<TaskCard> taskCardsList = <TaskCard>[];

    int length = tasksList.length;
    for (int i = 0; i < length; i++) {
      taskCardsList.add(_parseTaskCard(tasksList[i]));
    }

    return taskCardsList;
  }

  TaskCard _parseTaskCard(Task task) {
    return TaskCard(
      task: task,
      deleteMe: this.widget.deleteMe,
      getUsers: this.widget.getUsers,
      taskUnlocked: this.widget.taskUnlocked,
      productivityAssigned: this.widget.productivityAssigned,
      getCurrentDay: this.widget.getCurrentDay,
      getFinalDay: this.widget.getFinalDay,
    );
  }

  void _switchTasks(String addToListName, int taskID) {
    int n = columns.length;
    for (int i = 0; i < n; i++) {
      int index = _getTaskListByName(columns[i]).indexWhere(
        (Task task) => task.getID() == taskID,
      );

      if (index != -1) {
        setState(() {
          Task temp = _getTaskListByName(columns[i]).removeAt(index);
          _getTaskListByName(addToListName).add(temp);
        });

        break;
      }
    }
  }

  bool _isNotFromTheSameColumn(String addToListName, int taskID) {
    int n = columns.length;
    for (int i = 0; i < n; i++) {
      int index = _getTaskListByName(columns[i]).indexWhere(
        (Task task) => task.getID() == taskID,
      );

      if (index != -1) {
        List<Task> removeFromList = _getTaskListByName(columns[i]);
        List<Task> addToList = _getTaskListByName(addToListName);

        if (removeFromList == addToList) {
          return false;
        }
      }
    }

    return true;
  }

  List<Task> _getTaskListByName(String name) {
    switch (name) {
      case "available":
        return this.widget.getAllTasks().idleTasksColumn;
      case "stage one in progress":
        return this.widget.getAllTasks().stageOneInProgressTasksColumn;
      case "stage one done":
        return this.widget.getAllTasks().stageOneDoneTasksColumn;
      case "stage two":
        return this.widget.getAllTasks().stageTwoTasksColumn;
      case "finished":
        return this.widget.getAllTasks().finishedTasksColumn;
      default:
        throw ArgumentError("Invalid tasks list name.");
    }
  }
}

class _Title extends StatelessWidget {
  final String title;

  _Title({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(9),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(
          title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).primaryColor
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _NewTaskButton extends StatelessWidget {
  final Function getCurrentDay;
  final Function getMaxSimDay;
  final Function getUsers;
  final Function(Task) taskCreated;

  _NewTaskButton({
    Key key,
    @required this.getMaxSimDay,
    @required this.getCurrentDay,
    @required this.taskCreated,
    @required this.getUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateTaskButton(
      getCurrentDay: this.getCurrentDay,
      getMaxSimDay: this.getMaxSimDay,
      getUsers: this.getUsers,
      taskCreated: this.taskCreated,
    );
  }
}

class _StageOneTasksDoubleColumn extends StatelessWidget {
  final double defaultMinColumnHeight;
  final VoidCallback ownerSet;
  final Function(String, int) switchTasks;
  final Function(List<Task>) parseTaskCardsList;
  final Function getStageOneInProgressLimit;
  final Function(String, int) isNotFromTheSameColumn;
  final Function getStageOneDoneLimit;
  final Function getMaxSimDay;
  final Function getCurrentDay;
  final Function getAllTasks;
  final Function getUsers;
  final List<Task> inProgressTasks;
  final List<Task> doneTasks;
  final double _headlineHeight = 35;

  _StageOneTasksDoubleColumn({
    Key key,
    @required this.defaultMinColumnHeight,
    @required this.isNotFromTheSameColumn,
    @required this.getStageOneInProgressLimit,
    @required this.getStageOneDoneLimit,
    @required this.getAllTasks,
    @required this.getUsers,
    @required this.getMaxSimDay,
    @required this.getCurrentDay,
    @required this.ownerSet,
    @required this.switchTasks,
    @required this.parseTaskCardsList,
    @required this.inProgressTasks,
    @required this.doneTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  height: this._headlineHeight,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child:
                      _Title(title: AppLocalizations.of(context).stageOneTasks),
                ),
              ),
            ],
          ),
          Container(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 20,
                      child: KanbanColumn(
                        title: AppLocalizations.of(context).inProgressTasks,
                        isInternal: true,
                        getAllTasks: this.getAllTasks,
                        onTaskDropped: (Task task) => showDialog(
                          context: context,
                          builder: (BuildContext context) => SetOwnerPopup(
                            task: task,
                            columnName: "stage one in progress",
                            getAllUsers: this.getUsers,
                            ownerSet: () {
                              task.startDay = this.getCurrentDay();
                              task.stage = 1;
                              this.ownerSet();
                            },
                            moveTask: this.switchTasks,
                          ).show(),
                        ),
                        tasksLimit: this.getStageOneInProgressLimit(),
                        defaultMinColumnHeight:
                            this.defaultMinColumnHeight - this._headlineHeight,
                        tasks: this.parseTaskCardsList(this.inProgressTasks),
                        isNotFromTheSameColumn: (int taskID) =>
                            isNotFromTheSameColumn(
                          "stage one in progress",
                          taskID,
                        ),
                        areRequirementsMet: (Task task) => (task.stage == 0),
                      ),
                    ),
                    Flexible(
                      flex: 20,
                      child: KanbanColumn(
                        title: AppLocalizations.of(context).doneTasks,
                        isInternal: true,
                        getAllTasks: this.getAllTasks,
                        onTaskDropped: (Task task) {
                          task.owner = null;
                          task.progress.clearInvestedProductivity();
                          this.switchTasks("stage one done", task.getID());
                        },
                        tasks: this.parseTaskCardsList(this.doneTasks),
                        tasksLimit: this.getStageOneDoneLimit(),
                        defaultMinColumnHeight:
                            this.defaultMinColumnHeight - this._headlineHeight,
                        isNotFromTheSameColumn: (int taskID) =>
                            isNotFromTheSameColumn(
                          "stage one done",
                          taskID,
                        ),
                        areRequirementsMet: (Task task) => (task.stage == 1 &&
                            task.progress.getNumberOfUnfulfilledParts() == 0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
