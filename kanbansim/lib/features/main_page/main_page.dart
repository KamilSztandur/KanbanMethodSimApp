import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kanbansim/common/savefile_parsers/savefile_reader.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/menu_bar.dart';
import 'package:kanbansim/features/main_page/widgets/story_logs/story_panel.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/day_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/locks_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/producivity_bar.dart';
import 'package:kanbansim/features/notifications/story_notification.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/features/scroll_bar.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  final scaffoldKey;

  MainPage({this.scaffoldKey});

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
  StoryPanel storyPanel;

  AllTasksContainer allTasks;
  List<String> messages;
  List<User> users;
  int currentDay;

  void _restoreUsersProductivities() {
    int n = this.users.length;
    for (int i = 0; i < n; i++) {
      this.users[i].restoreProductivity();
    }
  }

  void _eventOccured(EventType type, String text) {
    _printNotification(type, text);
    _addLog(text);
  }

  String _getTranslatedTaskTypeName(String type) {
    switch (type) {
      case "Standard":
        return AppLocalizations.of(context).standard;
        break;

      case "Expedite":
        return AppLocalizations.of(context).expedite;
        break;

      case "FixedDate":
        return AppLocalizations.of(context).fixedDate;
        break;

      default:
        return AppLocalizations.of(context).standard;
    }
  }

  void _addLog(String text) {
    setState(() {
      this.messages.add(text);
    });
  }

  void _printNotification(EventType type, String text) {
    StoryNotification(
      context: this.context,
      type: type,
      message: text,
    ).show();
  }

  void _initializeMainMenuBar() {
    this.menuBar = MainMenuBar(
      loadSimStateFromFilePath: (String filePath) {
        File loadedSavefile = File(filePath);
        loadedSavefile.open();
        loadedSavefile.readAsString().then((String data){
          SavefileReader reader = SavefileReader();
          
          setState((){
            this.users = reader.readUsers(data);
          this.allTasks.idleTasksColumn = reader.readIdleTasks(data);
          this.allTasks.stageOneInProgressTasksColumn = reader.readStageOneInProgressTasks(data);
          this.allTasks.stageOneDoneTasksColumn = reader.readStageOneDoneTasks(data);
          this.allTasks.stageTwoTasksColumn = reader.readStageTwoTasks(data);
          this.allTasks.finishedTasksColumn = reader.readFinishedTasks(data);
          });
        });      

        SubtleMessage.messageWithContext(context, "Pomyślnie załadowano plik zapisu.}");
      },
      saveSimStateIntoFile: () {
        // TODO
      },
      clearAllTasks: () {
        setState(() {
          _clearAllTasks();
          _restoreUsersProductivities();
          _clearAllLogs();
        });
      },
      addRandomTasks: () {
        setState(() {
          this.allTasks.addRandomTasksForAllColumns();
        });
      }, 
      getAllTasks: () => this.allTasks, 
      getAllUsers: () => this.users, loadSimStateFromFileContent: (String data) {
        SavefileReader reader = SavefileReader();
        setState((){
          this.users = reader.readUsers(data);
          this.allTasks.idleTasksColumn = reader.readIdleTasks(data);
          this.allTasks.stageOneInProgressTasksColumn = reader.readStageOneInProgressTasks(data);
          this.allTasks.stageOneDoneTasksColumn = reader.readStageOneDoneTasks(data);
          this.allTasks.stageTwoTasksColumn = reader.readStageTwoTasks(data);
          this.allTasks.finishedTasksColumn = reader.readFinishedTasks(data);
        });
      },
    );
  }

  void _clearAllTasks() {
    this.allTasks.clearAllTasks();
  }

  void _clearAllLogs() {
    this.messages = <String>[];
  }

  void _initializeKanbanBoard() {
    kanbanBoard = KanbanBoard(
      allTasks: this.allTasks,
      taskCreated: (Task task) {
        setState(() {
          this.allTasks.idleTasksColumn.add(task);
        });

        _eventOccured(
          EventType.NEWTASK,
          "${AppLocalizations.of(context).newTaskAppeared}! ${_getTranslatedTaskTypeName(task.getTaskTypeName())} '${task.getTitle()}'.",
        );
      },
      deleteMe: (Task task) {
        setState(
          () {
            this.allTasks.removeTask(task);
          },
        );

        _eventOccured(
          EventType.DELETE,
          "${AppLocalizations.of(context).elementDeleted}! ${_getTranslatedTaskTypeName(task.getTaskTypeName())} '${task.getTitle()}'.",
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
      productivityAssigned: (Task task, User user, int value) {
        setState(() {
          task.investProductivityFrom(
            user,
            value,
          );
        });
      },
    );
  }

  void _initializeStoryLogs() {
    if (this.messages == null) {
      this.messages = <String>[];
    }

    this.storyPanel = StoryPanel(messages: messages);
  }

  void _initializeStatusBar() {
    dayStatus = DayStatus(
      MIN_DAY: 1,
      MAX_DAY: 15,
      dayHasChanged: (int daysPassed) {
        print("Passed days: $daysPassed");
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
        (Task task) {
          _eventOccured(
            EventType.NEWTASK,
            "${AppLocalizations.of(context).newTaskAppeared}! ${_getTranslatedTaskTypeName(task.getTaskTypeName())} '${task.getTitle()}'.",
          );
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
    _initializeStoryLogs();

    return ListView(
      children: [
        menuBar,
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 1.0],
              tileMode: TileMode.clamp,
              colors: [
                Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).accentColor
                    : Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).accentColor,
              ],
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
          height: (MediaQuery.of(context).size.height) * 0.72,
          child: ScrollBar(
            child: kanbanBoard,
          ),
        ),
        storyPanel,
      ],
    );
  }
}
