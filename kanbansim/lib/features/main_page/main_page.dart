import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/common/savefile_parsers/savefile_reader.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/menu_bar.dart';
import 'package:kanbansim/features/main_page/widgets/story_logs/logs_button.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/day_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/locks_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/producivity_bar.dart';
import 'package:kanbansim/features/notifications/story_notification.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/features/scroll_bar.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  List<User> createdUsers;

  MainPage({Key key, @required this.createdUsers}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MainMenuBar menuBar;
  KanbanBoard kanbanBoard;
  DayStatus dayStatus;
  LocksStatus locksStatus;
  ProductivityBar productivityBar;

  AllTasksContainer allTasks;
  List<String> messages;
  List<User> currentUsers;

  final int MIN_DAY = 1;
  final int MAX_DAY = 25;
  int currentDay;

  int stageOneInProgressColumnLimit;
  int stageOneDoneColumnLimit;
  int stageTwoColumnLimit;

  void _restoreUsersProductivities() {
    int n = this.currentUsers.length;
    for (int i = 0; i < n; i++) {
      this.currentUsers[i].restoreProductivity();
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
        loadedSavefile.readAsString().then((String data) {
          SavefileReader reader = SavefileReader();

          setState(() {
            this.currentUsers = reader.readUsers(data);
            this.allTasks.idleTasksColumn = reader.readIdleTasks(data);
            this.allTasks.stageOneInProgressTasksColumn =
                reader.readStageOneInProgressTasks(data);
            this.allTasks.stageOneDoneTasksColumn =
                reader.readStageOneDoneTasks(data);
            this.allTasks.stageTwoTasksColumn = reader.readStageTwoTasks(data);
            this.allTasks.finishedTasksColumn = reader.readFinishedTasks(data);
            Task.dummy().setLatestTaskID(reader.getLatestTaskID(data));

            this.currentDay = reader.getCurrentDayFromString(data);
            this.dayStatus.updateCurrentDay(this.currentDay);
          });
        });

        SubtleMessage.messageWithContext(
            context, "Pomyślnie załadowano plik zapisu.}");
      },
      getCurrentDay: () => this.currentDay,
      clearAllTasks: () {
        setState(() {
          _clearAllTasks();
          _restoreUsersProductivities();
          _clearAllLogs();
          this.currentDay = 1;
        });
      },
      addRandomTasks: () {
        setState(() {
          this.allTasks.addRandomTasksForAllColumns();
        });
      },
      getAllTasks: () => this.allTasks,
      getAllUsers: () => this.currentUsers,
      loadSimStateFromFileContent: (String data) {
        SavefileReader reader = SavefileReader();

        setState(() {
          this.currentUsers = reader.readUsers(data);
          this.allTasks.idleTasksColumn = reader.readIdleTasks(data);
          this.allTasks.stageOneInProgressTasksColumn =
              reader.readStageOneInProgressTasks(data);
          this.allTasks.stageOneDoneTasksColumn =
              reader.readStageOneDoneTasks(data);
          this.allTasks.stageTwoTasksColumn = reader.readStageTwoTasks(data);
          this.allTasks.finishedTasksColumn = reader.readFinishedTasks(data);
          Task.dummy().setLatestTaskID(reader.getLatestTaskID(data));

          this.currentDay = reader.getCurrentDayFromString(data);
          this.dayStatus.updateCurrentDay(this.currentDay);
        });
      },
      getStageOneInProgressLimit: () => this.stageOneInProgressColumnLimit,
      getStageTwoLimit: () => this.stageTwoColumnLimit,
      stageOneInProgressLimitChanged: (int newLimit) {
        setState(() {
          this.stageOneInProgressColumnLimit = newLimit;
        });
      },
      stageTwoLimitChanged: (int newLimit) {
        setState(() {
          this.stageTwoColumnLimit = newLimit;
        });
      },
      getStageOneDoneLimit: () => this.stageOneDoneColumnLimit,
      stageOneDoneLimitChanged: (int newLimit) {
        setState(() {
          this.stageOneDoneColumnLimit = newLimit;
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
      getFinalDay: () => this.MAX_DAY,
      getCurrentDay: () => this.currentDay,
      getMaxSimDay: () => this.MAX_DAY,
      getAllTasks: () => this.allTasks,
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
        return this.currentUsers;
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
      getStageOneInProgressLimit: () => this.stageOneInProgressColumnLimit,
      getStageTwoLimit: () => this.stageTwoColumnLimit,
      getStageOneDoneLimit: () => this.stageOneDoneColumnLimit,
    );
  }

  void _initializeStoryLogs() {
    if (this.messages == null) {
      this.messages = <String>[];
    }
  }

  void _initializeStatusBar() {
    if (this.currentDay == null) {
      this.currentDay = 1;
    }

    dayStatus = DayStatus(
      MIN_DAY: this.MIN_DAY,
      MAX_DAY: this.MAX_DAY,
      dayHasChanged: (int daysPassed) {
        this.currentDay = daysPassed;
      },
      getCurrentDay: () => this.currentDay,
    );

    locksStatus = LocksStatus(
      checkForLocks: () {
        return this.allTasks.areThereAnyLocks();
      },
    );

    productivityBar = ProductivityBar(
      users: this.currentUsers,
    );
  }

  void _initializeAllTasksContainer() {
    if (this.allTasks == null) {
      this.allTasks = AllTasksContainer(
        () {
          return this.currentUsers;
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

  void _initializeUsersIfNeeded() {
    if (this.currentUsers == null) {
      this.currentUsers = this.widget.createdUsers;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeUsersIfNeeded();
    _initializeAllTasksContainer();

    _initializeKanbanBoard();
    _initializeMainMenuBar();
    _initializeStatusBar();
    _initializeStoryLogs();

    return Container(
      decoration: BoxDecoration(
        image: KanbanSimApp.of(context).getBackgroundImage(),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: WindowBorder(
          color: Theme.of(context).primaryColor,
          width: 1,
          child: ListView(
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
                      Theme.of(context).brightness == Brightness.light
                          ? 0.3
                          : 0.5,
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
<<<<<<< Updated upstream
                height: (MediaQuery.of(context).size.height) * 0.72,
=======
                height: MediaQuery.of(context).size.height -
                    (180 +
                        (KanbanSimApp.of(context).isWeb()
                            ? 0
                            : 33)), // appbar makes the difference
>>>>>>> Stashed changes
                child: ScrollBar(
                  child: kanbanBoard,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: LogsButton(messages: this.messages),
      ),
    );
  }
}
