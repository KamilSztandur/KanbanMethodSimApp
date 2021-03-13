import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card.dart';
import 'package:kanbansim/features/main_page/widgets/menu_bar.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/day_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/locks_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/producivity_bar.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';

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

  AllTasksContainer allTasks;

  void _initializeMainMenuBar() {
    this.menuBar = MainMenuBar(
      clearAllTasks: () {
        setState(() {
          this.allTasks.clearAllTasks();
        });
      },
      addRandomTasks: () {
        setState(() {
          this.allTasks.addRandomTasksForAllColumns();
        });
      },
    );
  }

  void _initializeKanbanBoard() {
    kanbanBoard = KanbanBoard(
      allTasks: this.allTasks,
      createNewTask: () {
        setState(() {
          this.allTasks.createTask();
        });
      },
    );
  }

  void _initializeStatusBar() {
    dayStatus = DayStatus(this);
    locksStatus = LocksStatus(this);
    productivityBar = ProductivityBar(this);
  }

  @override
  Widget build(BuildContext context) {
    if (this.allTasks == null) {
      this.allTasks = AllTasksContainer(
        (TaskCard taskCard) {
          setState(
            () {
              this.allTasks.removeTask(taskCard);
            },
          );

          SubtleMessage.messageWithContext(
            context,
            'Successfully deleted task #${taskCard.getID()}.',
          );
        },
      );
    }

    _initializeKanbanBoard();
    _initializeMainMenuBar();
    _initializeStatusBar();

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
