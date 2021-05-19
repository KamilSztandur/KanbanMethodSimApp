import 'package:kanbansim/common/savefile_parsers/savefile_reader.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';

class SimState {
  List<User> users;
  AllTasksContainer allTasks;
  int currentDay;
  int stageOneInProgressColumnLimit;
  int stageOneDoneColumnLimit;
  int stageTwoColumnLimit;

  SimState() {
    this.currentDay = 1;
    this.users = <User>[];
    this.allTasks = AllTasksContainer(() => this.users);
    Task.getEmpty().setLatestTaskID(0);
  }

  int getAmountOfUsers() => this.users.length;

  int getAmountOfAvailableTasks() => this.allTasks.idleTasksColumn.length;

  int getAmountOfStageOneInProgressTasks() =>
      this.allTasks.stageOneInProgressTasksColumn.length;

  int getAmountOfStageOneDoneTasks() =>
      this.allTasks.stageOneDoneTasksColumn.length;

  int getAmountOfStageTwoTasks() => this.allTasks.stageTwoTasksColumn.length;

  int getAmountOfFinishedTwoTasks() => this.allTasks.finishedTasksColumn.length;

  void createFromData(String data) {
    SavefileReader reader = SavefileReader();
    _buildCurrentDayFromData(reader, data);
    _buildColumnLimitsFromData(reader, data);
    _buildUsersFromData(reader, data);
    _buildTasksFromData(reader, data);
    _buildLatestTaskIDFromData(reader, data);
  }

  int getLatestTaskID() {
    print(this.allTasks.idleTasksColumn[0].getLatestTaskID());
    print(Task.getEmpty().getLatestTaskID());
    print(this.allTasks.idleTasksColumn[0].getLatestTaskID());
    return Task.getEmpty().getLatestTaskID();
  }

  void _buildCurrentDayFromData(SavefileReader reader, String data) {
    this.currentDay = reader.getCurrentDayFromString(data);
  }

  void _buildUsersFromData(SavefileReader reader, String data) {
    this.users = reader.readUsers(data);
  }

  void _buildLatestTaskIDFromData(SavefileReader reader, String data) {
    int latestTaskID = reader.getLatestTaskID(data);
    Task.getEmpty().setLatestTaskID(latestTaskID);
  }

  void _buildTasksFromData(SavefileReader reader, String data) {
    AllTasksContainer allTasks = AllTasksContainer(() => this.users);

    allTasks.idleTasksColumn = reader.readIdleTasks(data);
    allTasks.stageOneInProgressTasksColumn =
        reader.readStageOneInProgressTasks(data);
    allTasks.stageOneDoneTasksColumn = reader.readStageOneDoneTasks(data);
    allTasks.stageTwoTasksColumn = reader.readStageTwoTasks(data);
    allTasks.finishedTasksColumn = reader.readFinishedTasks(data);

    this.allTasks = allTasks;
  }

  void _buildColumnLimitsFromData(SavefileReader reader, String data) {
    this.stageOneInProgressColumnLimit =
        reader.getStageOneInProgressColumnLimit(data);

    this.stageOneDoneColumnLimit = reader.getStageOneDoneColumnLimit(data);

    this.stageTwoColumnLimit = reader.getStageTwoColumnLimit(data);
  }
}
