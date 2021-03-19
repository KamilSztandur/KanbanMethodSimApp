import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/menu_bar.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/day_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/locks_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/producivity_bar.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/features/scroll_bar.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
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
  List<User> users;
  int currentDay;

  void _restoreUsersProductivities() {
    int n = this.users.length;
    for (int i = 0; i < n; i++) {
      this.users[i].restoreProductivity();
    }
  }

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
          _restoreUsersProductivities();
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
      taskCreated: (Task task) {
        setState(() {
          this.allTasks.idleTasksColumn.add(task);
        });
      },
      deleteMe: (Task task) {
        setState(
          () {
            this.allTasks.removeTask(task);
          },
        );

        SubtleMessage.messageWithContext(
          context,
          'Successfully deleted task #${task.getID()}.',
        );
      },
      getUsers: () {
        return this.users;
      },
      taskUnlocked: () {
        setState(() {
          this.locksStatus.checkForLocks();
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
        return this.allTasks.areThereAnyLocks();
      },
    );

    productivityBar = ProductivityBar(
      users: this.users,
    );
  }

  void _initializeDummyUsers() {
    if (this.users == null) {
      this.users = <User>[];

      this.users.add(User(
            "Kamil",
            5,
            Colors.blue,
          ));

      this.users.add(User(
            "Janek",
            5,
            Colors.limeAccent,
          ));

      this.users.add(User(
            "Łukasz",
            5,
            Colors.purpleAccent,
          ));

      this.users.add(User(
            "Agata",
            3,
            Colors.orangeAccent,
          ));
    }
  }

  void _initializeAllTasksContainer() {
    if (this.allTasks == null) {
      this.allTasks = AllTasksContainer(
        () {
          return this.users;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeDummyUsers();
    _initializeAllTasksContainer();

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
