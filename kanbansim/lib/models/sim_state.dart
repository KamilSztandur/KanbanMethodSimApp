import 'package:kanbansim/common/savefile_parsers/savefile_creator.dart';
import 'package:kanbansim/common/savefile_parsers/savefile_reader.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';
import 'dart:io';

class SimState {
  List<User> users;
  AllTasksContainer allTasks;
  int currentDay;
  int latestTaskID;
  int stageOneInProgressColumnLimit;
  int stageOneDoneColumnLimit;
  int stageTwoColumnLimit;

  SimState() {
    this.currentDay = 1;
    this.latestTaskID = 1;
    this.users = <User>[];
    this.allTasks = AllTasksContainer(
      () => this.users,
      (Task task) {},
    );
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
    _buildUsersFromData(reader, data);
    _buildLatestTaskIDFromData(reader, data);
    _buildTasksFromData(reader, data);
  }

  void createFromFilePath(String path) {
    File loadedSavefile = File(path);
    loadedSavefile.open();
    loadedSavefile.readAsString().then((String data) {
      createFromData(data);
    });
  }

  String parseIntoStringData() {
    SavefileCreator creator = SavefileCreator();

    _parseUsersToCreator(creator);
    _parseSimStateDataToCreator(creator);
    _parseTasksListsToCreator(creator);

    String data = creator.convertDataToString();
    return data;
  }

  void _buildCurrentDayFromData(SavefileReader reader, String data) {
    this.currentDay = reader.getCurrentDayFromString(data);
  }

  void _buildUsersFromData(SavefileReader reader, String data) {
    this.users = reader.readUsers(data);
  }

  void _buildLatestTaskIDFromData(SavefileReader reader, String data) {
    this.latestTaskID = reader.getLatestTaskID(data);
  }

  void _buildTasksFromData(SavefileReader reader, String data) {
    AllTasksContainer allTasks = AllTasksContainer(
      () => this.users,
      (Task task) {},
    );

    allTasks.idleTasksColumn = reader.readIdleTasks(data);
    allTasks.stageOneInProgressTasksColumn =
        reader.readStageOneInProgressTasks(data);
    allTasks.stageOneDoneTasksColumn = reader.readStageOneDoneTasks(data);
    allTasks.stageTwoTasksColumn = reader.readStageTwoTasks(data);
    allTasks.finishedTasksColumn = reader.readFinishedTasks(data);

    Task.dummy().setLatestTaskID(this.latestTaskID);

    this.allTasks = allTasks;
  }

  void _parseUsersToCreator(SavefileCreator creator) {
    creator.setUsersList(this.users);
  }

  void _parseSimStateDataToCreator(SavefileCreator creator) {
    creator.setSimStateData(this.currentDay, this.latestTaskID);
  }

  void _parseTasksListsToCreator(SavefileCreator creator) {
    creator.addTasksListsWithTitle(allTasks.idleTasksColumn, "idle");
    creator.addTasksListsWithTitle(
        allTasks.stageOneInProgressTasksColumn, "stage one in progress");
    creator.addTasksListsWithTitle(
        allTasks.stageOneDoneTasksColumn, "stage one done");
    creator.addTasksListsWithTitle(allTasks.stageTwoTasksColumn, "stage two");
    creator.addTasksListsWithTitle(allTasks.finishedTasksColumn, "finished");
  }
}
