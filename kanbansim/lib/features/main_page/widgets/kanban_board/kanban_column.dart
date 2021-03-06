import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';

class KanbanColumn extends StatelessWidget {
  KanbanColumn({Key key, @required this.parent, @required this.tasks})
      : super(key: key);
  final List<Widget> tasks;
  final KanbanBoardState parent;

  @override
  Widget build(BuildContext context) => _buildKanbanColumn();

  Column _buildKanbanColumn() {
    return Column(
      children: _buildTaskList(),
    );
  }

  List<Widget> _buildTaskList() {
    var columnChildren = <Widget>[];

    int n = tasks.length;
    for (int i = 0; i < n; i++) {
      columnChildren.add(tasks[i]);
      columnChildren.add(SizedBox(height: 20));
    }

    return columnChildren;
  }
}
