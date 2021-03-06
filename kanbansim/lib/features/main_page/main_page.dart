import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/menu_bar.dart';

class MainPage extends StatefulWidget {
  MainPage({this.scaffoldKey});
  final scaffoldKey;

  @override
  MainPageState createState() => MainPageState(scaffoldKey: scaffoldKey);
}

class MainPageState extends State<MainPage> {
  MainPageState({this.scaffoldKey});
  final scaffoldKey;

  MainMenuBar menuBar;
  KanbanBoard kanbanBoard;

  @override
  Widget build(BuildContext context) {
    menuBar = MainMenuBar(this);
    kanbanBoard = KanbanBoard(this);

    return Container(
      child: Column(
        children: [
          menuBar,
          kanbanBoard,
        ],
      ),
    );
  }
}
