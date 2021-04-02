import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card/task_card.dart';

class KanbanColumn extends StatefulWidget {
  final List<TaskCard> tasks;
  final String title;
  final bool isInternal;
  final Widget additionalWidget;

  KanbanColumn({
    Key key,
    @required this.tasks,
    @required this.title,
    @required this.isInternal,
    this.additionalWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => KanbanColumnState();
}

class KanbanColumnState extends State<KanbanColumn> {
  @override
  Widget build(BuildContext context) => _buildKanbanColumn();

  Column _buildKanbanColumn() {
    return Column(
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
                  borderRadius: this.widget.isInternal
                      ? BorderRadius.zero
                      : BorderRadius.only(
                          topLeft: Radius.circular(100.0),
                          topRight: Radius.circular(100.0),
                        ),
                ),
                child: _buildTitle(),
              ),
            ),
          ],
        ),
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
            child: Column(
              children: _buildTaskColumn(),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTaskColumn() {
    List<Widget> taskColumn = <Widget>[];
    taskColumn = _addHorizontalParentFitGuard(taskColumn);
    taskColumn = _addAdditionalWidget(taskColumn);
    taskColumn = _buildTaskList(taskColumn);

    return taskColumn;
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
    if (this.widget.additionalWidget != null) {
      column.add(this.widget.additionalWidget);
      column.add(SizedBox(height: 15));
    }

    return column;
  }

  List<Widget> _buildTaskList(List<Widget> column) {
    int n = widget.tasks.length;

    if (n % 2 == 0) {
      for (int i = 0; i < n; i++) {
        column.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.tasks[i],
              SizedBox(width: 15),
              widget.tasks[++i],
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
                widget.tasks[i],
                SizedBox(width: 15),
                widget.tasks[++i],
              ],
            ),
          );
        } else {
          column.add(widget.tasks[i]);
        }
        column.add(SizedBox(height: 15));
      }
    }

    return column;
  }
}
