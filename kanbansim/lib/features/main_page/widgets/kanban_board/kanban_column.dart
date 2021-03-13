import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card.dart';

class KanbanColumn extends StatelessWidget {
  KanbanColumn({
    Key key,
    @required this.parent,
    @required this.tasks,
    @required this.title,
  }) : super(key: key);
  final List<TaskCard> tasks;
  final KanbanBoardState parent;
  final title;

  @override
  Widget build(BuildContext context) => _buildKanbanColumn();

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
                  borderRadius: BorderRadius.only(
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
            children: _buildTaskList(),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  List<Widget> _buildTaskList() {
    var columnChildren = <Widget>[];

    columnChildren.add(
      Row(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(),
          )
        ],
      ),
    );

    columnChildren.add(SizedBox(height: 15));

    int n = tasks.length;
    for (int i = 0; i < n; i++) {
      columnChildren.add(tasks[i]);
      columnChildren.add(SizedBox(height: 15));
    }

    return columnChildren;
  }
}
