import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card.dart';

class KanbanColumn extends StatelessWidget {
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
                  color: Colors.indigoAccent.shade400,
                  borderRadius: this.isInternal
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
        Container(
          decoration: BoxDecoration(
            color: Colors.indigoAccent.shade100,
            border: Border.all(color: Colors.indigoAccent.shade400),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: _buildTaskColumn(),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Column _buildTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
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
    if (this.additionalWidget != null) {
      column.add(this.additionalWidget);
      column.add(SizedBox(height: 15));
    }

    return column;
  }

  List<Widget> _buildTaskList(List<Widget> column) {
    int n = tasks.length;
    for (int i = 0; i < n; i++) {
      column.add(tasks[i]);
      column.add(SizedBox(height: 15));
    }

    return column;
  }
}
