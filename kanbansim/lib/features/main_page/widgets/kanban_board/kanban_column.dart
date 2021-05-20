import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/tasks_limit_reached_popup.dart';
import 'package:kanbansim/models/Task.dart';

class KanbanColumn extends StatefulWidget {
  final double defaultMinColumnHeight;
  final Function getAllTasks;
  final Function(int) isNotFromTheSameColumn;
  final Function(Task) areRequirementsMet;
  final Function(Task) onTaskDropped;
  final Function(Task) modifyTask;
  final List<TaskCard> tasks;
  final String title;
  final int tasksLimit;
  final bool isInternal;
  final Widget additionalWidget;

  KanbanColumn({
    Key key,
    @required this.getAllTasks,
    @required this.isNotFromTheSameColumn,
    @required this.tasks,
    @required this.title,
    @required this.isInternal,
    @required this.defaultMinColumnHeight,
    this.modifyTask,
    this.tasksLimit,
    this.onTaskDropped,
    this.areRequirementsMet,
    this.additionalWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => KanbanColumnState();
}

class KanbanColumnState extends State<KanbanColumn> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          _HeadLine(
            title: widget.title,
            isInternal: widget.isInternal,
            limit: this.widget.tasksLimit,
            tasksAmount: this.widget.tasks.length,
          ),
          Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: this.widget.defaultMinColumnHeight,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 1.0],
                      tileMode: TileMode.clamp,
                      colors: [
                        Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).accentColor
                            : Theme.of(context).bottomAppBarColor,
                        Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).backgroundColor
                            : Theme.of(context).accentColor,
                      ],
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
                  child: DragTarget<Task>(
                    builder: (context, candidateItems, rejectedItems) {
                      return _TaskColumn(
                        tasks: widget.tasks,
                        additionalWidget: widget.additionalWidget,
                      );
                    },
                    onAccept: (task) {
                      if (this.widget.isNotFromTheSameColumn(task.getID())) {
                        if (this.widget.areRequirementsMet != null &&
                            !this.widget.areRequirementsMet(task)) {
                          return;
                        }

                        int n = this.widget.tasksLimit;
                        if (n != null && this.widget.tasks.length + 1 > n) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                TasksLimitReachedPopup().show(
                              this.widget.title,
                              this.widget.tasks.length,
                              this.widget.tasksLimit,
                            ),
                          );
                        } else {
                          if (this.widget.modifyTask != null) {
                            this.widget.modifyTask(task);
                          }

                          if (this.widget.onTaskDropped != null) {
                            this.widget.onTaskDropped(task);
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
              this.widget.tasksLimit == null
                  ? Container()
                  : _LimitInfo(
                      limit: this.widget.tasksLimit,
                      tasksAmount: this.widget.tasks.length,
                    ),
            ],
          ),
        ],
      );
}

class _HeadLine extends StatelessWidget {
  final String title;
  final bool isInternal;
  final int limit;
  final int tasksAmount;

  _HeadLine({
    Key key,
    @required this.title,
    @required this.isInternal,
    @required this.limit,
    @required this.tasksAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: this.isInternal
            ? BorderRadius.zero
            : BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: _Title(title: this.title),
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
    return Container(
      padding: EdgeInsets.all(9),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(
          this.title,
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

class _TaskColumn extends StatelessWidget {
  final List<TaskCard> tasks;
  final Widget additionalWidget;

  _TaskColumn({
    Key key,
    @required this.tasks,
    @required this.additionalWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> taskColumn = <Widget>[];
    taskColumn = _addHorizontalParentFitGuard(taskColumn);
    taskColumn = _addAdditionalWidget(taskColumn);
    taskColumn = _buildTaskList(taskColumn);

    return Column(
      children: taskColumn,
    );
  }

  List<Widget> _addHorizontalParentFitGuard(List<Widget> column) {
    column.add(Row(children: [
      Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: Container(),
      )
    ]));
    column.add(SizedBox(height: 15));

    return column;
  }

  List<Widget> _addAdditionalWidget(List<Widget> column) {
    if (this.additionalWidget != null) {
      column.add(this.additionalWidget);
      column.add(SizedBox(height: 15));
    }

    return column;
  }

  List<Widget> _buildTaskList(List<Widget> column) {
    int n = this.tasks.length;

    if (n % 2 == 0) {
      for (int i = 0; i < n; i++) {
        column.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _parseDraggableIfNotLocked(this.tasks[i]),
              SizedBox(width: 15),
              _parseDraggableIfNotLocked(this.tasks[++i])
            ],
          ),
        );
        column.add(SizedBox(height: 15));
      }
    } else {
      for (int i = 0; i < n; i++) {
        if (i + 1 < n) {
          column.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _parseDraggableIfNotLocked(this.tasks[i]),
                SizedBox(width: 15),
                _parseDraggableIfNotLocked(this.tasks[++i])
              ],
            ),
          );
        } else {
          column.add(_parseDraggableIfNotLocked(this.tasks[i]));
        }
        column.add(SizedBox(height: 15));
      }
    }

    return column;
  }

  Widget _parseDraggableIfNotLocked(TaskCard taskCard) {
    if (taskCard.task.isLocked()) {
      return taskCard;
    } else {
      return Draggable<Task>(
        data: taskCard.task,
        dragAnchor: DragAnchor.pointer,
        childWhenDragging: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
        ),
        feedback: taskCard,
        child: taskCard,
      );
    }
  }
}

class _LimitInfo extends StatelessWidget {
  final int limit;
  final int tasksAmount;

  _LimitInfo({
    Key key,
    @required this.limit,
    @required this.tasksAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 25,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).accentColor
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
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
      child: Center(
        child: Text(
          '$tasksAmount/$limit',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).primaryColor
                : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
