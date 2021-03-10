import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/menu_bar.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/day_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/locks_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/producivity_bar.dart';

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
  DayStatus dayStatus;
  LocksStatus locksStatus;
  ProductivityBar productivityBar;

  @override
  Widget build(BuildContext context) {
    kanbanBoard = KanbanBoard(this);
    menuBar = MainMenuBar(this);
    dayStatus = DayStatus(this);
    locksStatus = LocksStatus(this);
    productivityBar = ProductivityBar(this);

    return Container(
      child: Column(
        children: [
          menuBar,
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dayStatus,
              SizedBox(width: 10),
              productivityBar,
              SizedBox(width: 10),
              locksStatus,
            ],
          ),
          SizedBox(height: 25),
          kanbanBoard,
        ],
      ),
    );
  }
}
