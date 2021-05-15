import 'package:kanbansim/common/savefile_parsers/simstate_parser.dart';
import 'package:kanbansim/common/savefile_parsers/tasks_lists_list_parser.dart';
import 'package:kanbansim/common/savefile_parsers/users_list_parser.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';

class SavefileReader {
  List<User> _users;

  SavefileReader() {
    this._users = <User>[];
  }

  List<User> readUsers(String data) {
    _readAndUpdateUsers(data);
    return this._users;
  }

  List<Task> readIdleTasks(String data) {
    TasksListsListParser taskListsParser = TasksListsListParser(() => _users);
    return taskListsParser.getTaskListFromDataString(data, "idle");
  }

  List<Task> readStageOneInProgressTasks(String data) {
    TasksListsListParser taskListsParser = TasksListsListParser(() => _users);
    return taskListsParser.getTaskListFromDataString(
        data, "stage one in progress");
  }

  List<Task> readStageOneDoneTasks(String data) {
    TasksListsListParser taskListsParser = TasksListsListParser(() => _users);
    return taskListsParser.getTaskListFromDataString(data, "stage one done");
  }

  List<Task> readStageTwoTasks(String data) {
    TasksListsListParser taskListsParser = TasksListsListParser(() => _users);
    return taskListsParser.getTaskListFromDataString(data, "stage two");
  }

  List<Task> readFinishedTasks(String data) {
    TasksListsListParser taskListsParser = TasksListsListParser(() => _users);
    return taskListsParser.getTaskListFromDataString(data, "finished");
  }

  List<Task> readCustomListWithTitle(String data, String title) {
    TasksListsListParser taskListsParser = TasksListsListParser(() => _users);
    return taskListsParser.getTaskListFromDataString(data, title);
  }

  int getCurrentDayFromString(String data) {
    SimStateParser simStateParser = SimStateParser();
    return simStateParser.getCurrentDayFromString(data);
  }

  int getLatestTaskID(String data) {
    SimStateParser simStateParser = SimStateParser();
    return simStateParser.getLatestTaskID(data);
  }

  int getStageOneInProgressColumnLimit(String data) {
    SimStateParser simStateParser = SimStateParser();
    return simStateParser.getStageOneInProgressColumnLimit(data);
  }

  int getStageOneDoneColumnLimit(String data) {
    SimStateParser simStateParser = SimStateParser();
    return simStateParser.getStageOneDoneColumnLimit(data);
  }

  int getStageTwoColumnLimit(String data) {
    SimStateParser simStateParser = SimStateParser();
    return simStateParser.getStageTwoColumnLimit(data);
  }

  void _readAndUpdateUsers(String data) {
    UsersListsParser usersListsParser = UsersListsParser();
    this._users = usersListsParser.parseStringToUsersList(data);
  }
}
