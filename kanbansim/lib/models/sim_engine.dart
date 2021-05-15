import 'package:flutter/material.dart';
import 'package:kanbansim/common/story_module.dart';
import 'package:kanbansim/features/final_page/final_page.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';
import 'package:kanbansim/models/sim_state.dart';

class SimEngine {
  final int MIN_DAY = 1;
  int MAX_DAY;
  List<String> messages;

  /* ==== Backend ==== */

  /* StoryModule */
  void initializeStoryModule(MainPageState mainPageState) {
    mainPageState.storyModule = StoryModule(
      addLog: (String text) => mainPageState.setState(() => _addLog(text)),
      context: mainPageState.context,
      getAllTasks: () => mainPageState.currentSimState.allTasks,
      getCurrentDay: () => mainPageState.currentSimState.currentDay,
      getUsers: () => mainPageState.currentSimState.users,
    );

    this.MAX_DAY = mainPageState.storyModule.getMaxDays();
  }

  bool justLaunched(MainPageState mainPageState) {
    bool loadedDayIsTheFirstDay =
        mainPageState.widget.loadedSimState.currentDay == 1;

    bool currentSimStateNotInitializedYet =
        mainPageState.currentSimState == null;

    return (loadedDayIsTheFirstDay && currentSimStateNotInitializedYet);
  }

  /* Logs */
  void initializeStoryLogs() {
    if (this.messages == null) {
      this.messages = <String>[];
    }
  }

  void _addLog(String text) {
    this.messages.add(text);
  }

  void clearAllLogs(MainPageState mainPageState) {
    this.messages = <String>[];
  }

  /* SimState */
  void initializeSimStateIfNeeded(MainPageState mainPageState) {
    if (mainPageState.currentSimState == null) {
      if (mainPageState.widget.loadedSimState == null) {
        mainPageState.currentSimState = SimState();
      } else {
        mainPageState.currentSimState = mainPageState.widget.loadedSimState;
      }
    }
  }

  void restoreUsersProductivities(MainPageState mainPageState) {
    int n = mainPageState.currentSimState.users.length;
    for (int i = 0; i < n; i++) {
      mainPageState.currentSimState.users[i].addProductivity(5);
    }
  }

  void clearAllTasks(MainPageState mainPageState) {
    mainPageState.currentSimState.allTasks.clearAllTasks();
  }

  /* ==== Widgets ==== */

  /* MenuBar */
  void resetSimulationState(MainPageState mainPageState) {
    mainPageState.setState(() {
      clearAllTasks(mainPageState);
      restoreUsersProductivities(mainPageState);
      clearAllLogs(mainPageState);
      mainPageState.currentSimState.currentDay = 1;
    });
  }

  void loadSimStateFromFilePath(MainPageState mainPageState, String path) {
    mainPageState.setState(() {
      SimState loadedSimState = SimState();
      loadedSimState.createFromFilePath(path);
      mainPageState.currentSimState = loadedSimState;
    });
  }

  void loadSimStateFromFileContent(MainPageState mainPageState, String data) {
    mainPageState.setState(() {
      SimState loadedSimState = SimState();
      loadedSimState.createFromData(data);
      mainPageState.currentSimState = loadedSimState;
    });
  }

  void stageOneInProgressLimitChanged(MainPageState mainPageState, int limit) {
    mainPageState.setState(() {
      mainPageState.currentSimState.stageOneInProgressColumnLimit = limit;
    });
  }

  void stageOneDoneLimitChanged(MainPageState mainPageState, int limit) {
    mainPageState.setState(() {
      mainPageState.currentSimState.stageOneDoneColumnLimit = limit;
    });
  }

  void stageTwoLimitChanged(MainPageState mainPageState, int limit) {
    mainPageState.setState(() {
      mainPageState.currentSimState.stageTwoColumnLimit = limit;
    });
  }

  /* StatusBar */

  void dayHasChanged(MainPageState mainPageState, int daysPassed) {
    if (daysPassed < mainPageState.currentSimState.currentDay) {
      mainPageState.storyModule.switchedToPreviousDay();
    } else if (daysPassed > mainPageState.currentSimState.currentDay) {
      mainPageState.storyModule.switchedToNextDay();
    }

    mainPageState.setState(() {
      mainPageState.currentSimState.currentDay = daysPassed;
    });
  }

  void simulationCompleted(MainPageState mainPageState) {
    BuildContext context = mainPageState.context;

    if (Theme.of(context).brightness == Brightness.light) {
      KanbanSimApp.of(context).switchTheme();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinalPage(
          allTasks: mainPageState.currentSimState.allTasks,
          users: mainPageState.currentSimState.users,
        ),
      ),
    );
  }

  bool checkForLocks(MainPageState mainPageState) {
    return mainPageState.currentSimState.allTasks.areThereAnyLocks();
  }

  /* KanbanBoard */
  void taskCreated(MainPageState mainPageState, Task task) {
    mainPageState.storyModule.newTaskAppeared(task);
    mainPageState.setState(() {
      mainPageState.currentSimState.allTasks.idleTasksColumn.add(task);
    });
  }

  void deleteTask(MainPageState mainPageState, Task task) {
    mainPageState.storyModule.taskDeleted(task);
    mainPageState.setState(
      () {
        mainPageState.currentSimState.allTasks.removeTask(task);
      },
    );
  }

  void taskUnlocked(MainPageState mainPageState, Task task) {
    mainPageState.storyModule.taskUnlocked(task);
    mainPageState.setState(() {
      mainPageState.locksStatus.checkForLocks();
    });
  }

  void productivityAssigned(
    MainPageState mainPageState,
    Task task,
    User user,
    int value,
  ) {
    mainPageState.storyModule.productivityAssigned(task, user, value);
    mainPageState.setState(() {
      task.investProductivityFrom(
        user,
        value,
      );
    });
  }

  double calcKanbanColumnHeight(MainPageState mainPageState) {
    double kanbanBoardHeight = calcKanbanBoardHeight(mainPageState);
    double columnHeadlineHeightModifier = 100.0;

    return kanbanBoardHeight - columnHeadlineHeightModifier;
  }

  double calcKanbanBoardHeight(MainPageState mainPageState) {
    bool isWeb = KanbanSimApp.of(mainPageState.context).isWeb();

    double defaultHeight = MediaQuery.of(mainPageState.context).size.height;
    double topBarHeightModifier = 180.0 + (isWeb ? 0.0 : 33.0);

    return defaultHeight - topBarHeightModifier;
  }
}
