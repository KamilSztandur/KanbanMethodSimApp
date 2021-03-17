import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card.dart';
import 'package:kanbansim/features/main_page/widgets/menu_bar.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/day_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/locks_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/producivity_bar.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/features/scroll_bar.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/User.dart';

class MainPage extends StatefulWidget {
  final VoidCallback switchTheme;
  final scaffoldKey;

  MainPage({this.scaffoldKey, @required this.switchTheme});

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
  int currentDay;

  void _initializeMainMenuBar() {
    this.menuBar = MainMenuBar(
      loadSimStateFromFilePath: (String filePath) {
        print(filePath);
      },
      saveSimStateIntoFile: () {
        // TODO
      },
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
      switchTheme: () {
        this.widget.switchTheme();
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
    dayStatus = DayStatus(
      MIN_DAY: 1,
      MAX_DAY: 15,
      dayHasChanged: () {
        // TODO
      },
    );

    locksStatus = LocksStatus(
      checkForLocks: () {
        return Random().nextBool();
      },
    );

    productivityBar = ProductivityBar(
      users: _createDummyUsers(),
    );
  }

  List<User> _createDummyUsers() {
    List<User> users = <User>[];

    users.add(User(
      "Kamil",
      5,
      Colors.blue,
    ));

    users.add(User(
      "Janek",
      5,
      Colors.limeAccent,
    ));

    users.add(User(
      "Łukasz",
      5,
      Colors.purpleAccent,
    ));

    users.add(User(
      "Agata",
      3,
      Colors.orangeAccent,
    ));

    users[0].decreaseProductivity(2);
    users[1].decreaseProductivity(3);
    users[2].decreaseProductivity(0);
    users[3].decreaseProductivity(1);

    return users;
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

    return ListView(
      children: [
        menuBar,
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor.withOpacity(
                  Theme.of(context).brightness == Brightness.light ? 0.6 : 0.5,
                ),
            border: Border.all(
              width: 2.0,
              color: Colors.black.withOpacity(
                Theme.of(context).brightness == Brightness.light ? 0.3 : 0.5,
              ),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 15),
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
              SizedBox(height: 15),
            ],
          ),
        ),
        Container(
          height: (MediaQuery.of(context).size.height) * 0.825,
          child: ScrollBar(
            child: kanbanBoard,
          ),
        ),
      ],
    );
  }

  /*
      return ListView(
      padding: EdgeInsets.all(20),
      physics: BouncingScrollPhysics(),
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
        SizedBox(height: 10),
        ScrollBar(
          child: kanbanBoard,
        ),
      ],
    );
    /*
    Container(
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
          ScrollBar(
            context: context,
            child: kanbanBoard,
          ),
        ],
      ),
    );
    */
  }
  */
}
