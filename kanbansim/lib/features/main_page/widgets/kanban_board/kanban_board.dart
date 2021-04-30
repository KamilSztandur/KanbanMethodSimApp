import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/create_task_button.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_column.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/models/User.dart';

class KanbanBoard extends StatefulWidget {
  final Function(Task, User, int) productivityAssigned;
  final Function taskUnlocked;
  final Function getMaxSimDay;
  final Function getCurrentDay;
  final Function getUsers;
  final Function(Task) taskCreated;
  final AllTasksContainer allTasks;
  final Function(Task) deleteMe;

  KanbanBoard({
    Key key,
    @required this.allTasks,
    @required this.taskCreated,
    @required this.deleteMe,
    @required this.productivityAssigned,
    @required this.taskUnlocked,
    @required this.getMaxSimDay,
    @required this.getCurrentDay,
    @required this.getUsers,
  }) : super(key: key);

  @override
  KanbanBoardState createState() => KanbanBoardState();
}

class KanbanBoardState extends State<KanbanBoard> {
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
    );
  }

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
              SizedBox(height: 15),
              KanbanColumn(
                title: AppLocalizations.of(context).availableTasks,
                isInternal: false,
                tasks: _parseTaskCardsList(widget.allTasks.idleTasksColumn),
                additionalWidget: _NewTaskButton(
                  getCurrentDay: this.widget.getCurrentDay,
                  getMaxSimDay: this.widget.getMaxSimDay,
                  taskCreated: this.widget.taskCreated,
                  getUsers: this.widget.getUsers,
                ),
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
            inProgressTasks: widget.allTasks.stageOneInProgressTasksColumn,
            doneTasks: widget.allTasks.stageOneDoneTasksColumn,
            parseTaskCardsList: (List<Task> tasks) {
              return this._parseTaskCardsList(tasks);
            },
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
            tasks: _parseTaskCardsList(widget.allTasks.stageTwoTasksColumn),
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
            tasks: _parseTaskCardsList(widget.allTasks.finishedTasksColumn),
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  _Title({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
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
            color: Colors.white,
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
  final Function(List<Task>) parseTaskCardsList;
  final List<Task> inProgressTasks;
  final List<Task> doneTasks;

  _StageOneTasksDoubleColumn({
    Key key,
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
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.0, 0.8],
                      tileMode: TileMode.clamp,
                      colors: [
                        Colors.blueAccent.shade200,
                        Colors.blueAccent.shade400,
                      ],
                    ),
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100.0),
                      topRight: Radius.circular(100.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child:
                      _Title(title: AppLocalizations.of(context).stageOneTasks),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 20,
                      child: KanbanColumn(
                        title: AppLocalizations.of(context).inProgressTasks,
                        isInternal: true,
                        tasks: this.parseTaskCardsList(this.inProgressTasks),
                      ),
                    ),
                    Flexible(
                      flex: 20,
                      child: KanbanColumn(
                        title: AppLocalizations.of(context).doneTasks,
                        isInternal: true,
                        tasks: this.parseTaskCardsList(this.doneTasks),
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
