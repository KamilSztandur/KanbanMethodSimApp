import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/tasks_limit_reached_popup.dart';
import 'package:kanbansim/models/Task.dart';

class KanbanColumn extends StatefulWidget {
  final Function getAllTasks;
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
    @required this.tasks,
    @required this.title,
    @required this.isInternal,
    this.modifyTask,
    this.tasksLimit,
    this.onTaskDropped,
    this.additionalWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => KanbanColumnState();
}

class KanbanColumnState extends State<KanbanColumn> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          _HeadLine(title: widget.title, isInternal: widget.isInternal),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.35,
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
                  int n = this.widget.tasksLimit;
                  if (n != null && this.widget.tasks.length + 1 > n) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          TasksLimitReachedPopup().show(
                        this.widget.title,
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
                },
              ),
            ),
          ),
        ],
      );
}

class _HeadLine extends StatelessWidget {
  final String title;
  final bool isInternal;

  _HeadLine({
    Key key,
    @required this.title,
    @required this.isInternal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
              borderRadius: this.isInternal
                  ? BorderRadius.zero
                  : BorderRadius.only(
                      topLeft: Radius.circular(100.0),
                      topRight: Radius.circular(100.0),
                    ),
            ),
            child: _Title(title: this.title),
          ),
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
      padding: EdgeInsets.all(15),
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
            color: Colors.white,
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
              Draggable<Task>(
                data: this.tasks[i].task,
                dragAnchor: DragAnchor.pointer,
                feedback: this.tasks[i],
                child: this.tasks[i],
              ),
              SizedBox(width: 15),
              Draggable<Task>(
                data: this.tasks[++i].task,
                dragAnchor: DragAnchor.pointer,
                feedback: this.tasks[i],
                child: this.tasks[i],
              ),
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
                Draggable<Task>(
                  data: this.tasks[i].task,
                  dragAnchor: DragAnchor.pointer,
                  feedback: this.tasks[i],
                  child: this.tasks[i],
                ),
                SizedBox(width: 15),
                Draggable<Task>(
                  data: this.tasks[++i].task,
                  dragAnchor: DragAnchor.pointer,
                  feedback: this.tasks[i],
                  child: this.tasks[i],
                ),
              ],
            ),
          );
        } else {
          column.add(
            Draggable<Task>(
              data: this.tasks[i].task,
              dragAnchor: DragAnchor.pointer,
              feedback: this.tasks[i],
              child: this.tasks[i],
            ),
          );
        }
        column.add(SizedBox(height: 15));
      }
    }

    return column;
  }
}
