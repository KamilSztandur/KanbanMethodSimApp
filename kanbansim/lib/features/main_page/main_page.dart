import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/common/story_module.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_board.dart';
import 'package:kanbansim/features/main_page/widgets/menu_bar.dart';
import 'package:kanbansim/features/main_page/widgets/story_logs/logs_button.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/day_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/locks_status.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/producivity_bar.dart';
import 'package:kanbansim/features/scroll_bar.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';
import 'package:kanbansim/models/sim_engine.dart';
import 'package:kanbansim/models/sim_state.dart';

class MainPage extends StatefulWidget {
  final SimState loadedSimState;

  MainPage({Key key, @required this.loadedSimState}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  MainMenuBar menuBar;
  KanbanBoard kanbanBoard;
  DayStatus dayStatus;
  LocksStatus locksStatus;
  ProductivityBar productivityBar;

  StoryModule storyModule;
  SimState currentSimState;
  SimEngine simEngine;

  @override
  void initState() {
    super.initState();
    this.simEngine = SimEngine();

    if (this.simEngine.justLaunched(this)) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => this.storyModule.simulationHasBegun(),
      );
    }

    this.simEngine.initializeSimStateIfNeeded(this);
    this.simEngine.initializeStoryLogs();
    this.simEngine.initializeStoryModule(this);
  }

  @override
  Widget build(BuildContext context) {
    _initializeMainMenuBar();
    _initializeStatusBar();
    _initializeKanbanBoard();

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
          child: Column(
            children: [
              menuBar,
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
                height: this.simEngine.calcKanbanBoardHeight(this),
                child: ScrollBar(
                  child: kanbanBoard,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: LogsButton(messages: this.simEngine.messages),
      ),
    );
  }

  void _initializeMainMenuBar() {
    this.menuBar = MainMenuBar(
      getCurrentDay: () => this.currentSimState.currentDay,
      getAllTasks: () => this.currentSimState.allTasks,
      getAllUsers: () => this.currentSimState.users,
      getStageOneInProgressLimit: () =>
          this.currentSimState.stageOneInProgressColumnLimit,
      getStageOneDoneLimit: () => this.currentSimState.stageOneDoneColumnLimit,
      getStageTwoLimit: () => this.currentSimState.stageTwoColumnLimit,
      loadSimStateFromFilePath: (String filePath) =>
          this.simEngine.loadSimStateFromFilePath(this, filePath),
      loadSimStateFromFileContent: (String data) =>
          this.simEngine.loadSimStateFromFileContent(this, data),
      stageOneInProgressLimitChanged: (int newLimit) =>
          this.simEngine.stageOneInProgressLimitChanged(this, newLimit),
      stageTwoLimitChanged: (int newLimit) =>
          this.simEngine.stageTwoLimitChanged(this, newLimit),
      stageOneDoneLimitChanged: (int newLimit) =>
          this.simEngine.stageOneDoneLimitChanged(this, newLimit),
      resetSimulation: () => this.simEngine.resetSimulationState(this),
    );
  }

  void _initializeStatusBar() {
    dayStatus = DayStatus(
      MIN_DAY: this.simEngine.MIN_DAY,
      MAX_DAY: this.simEngine.MAX_DAY,
      getCurrentDay: () => this.currentSimState.currentDay,
      simulationCompleted: () => this.simEngine.simulationCompleted(this),
      dayHasChanged: (int daysPassed) =>
          this.simEngine.dayHasChanged(this, daysPassed),
    );

    locksStatus = LocksStatus(
      checkForLocks: () => this.simEngine.checkForLocks(this),
    );

    productivityBar = ProductivityBar(
      users: this.currentSimState.users,
    );
  }

  void _initializeKanbanBoard() {
    kanbanBoard = KanbanBoard(
      defaultMinColumnHeight: this.simEngine.calcKanbanColumnHeight(this),
      getFinalDay: () => this.simEngine.MAX_DAY,
      getCurrentDay: () => this.currentSimState.currentDay,
      getMaxSimDay: () => this.simEngine.MAX_DAY,
      getAllTasks: () => this.currentSimState.allTasks,
      getUsers: () => this.currentSimState.users,
      getStageOneInProgressLimit: () =>
          this.currentSimState.stageOneInProgressColumnLimit,
      getStageTwoLimit: () => this.currentSimState.stageTwoColumnLimit,
      getStageOneDoneLimit: () => this.currentSimState.stageOneDoneColumnLimit,
      taskCreated: (Task task) => this.simEngine.taskCreated(this, task),
      deleteMe: (Task task) => this.simEngine.deleteTask(this, task),
      taskUnlocked: (Task task) => this.simEngine.taskUnlocked(this, task),
      productivityAssigned: (Task task, User user, int value) =>
          this.simEngine.productivityAssigned(this, task, user, value),
    );
  }
}
