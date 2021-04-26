import 'package:kanbansim/common/savefile_parsers/tasks_lists_list_parser.dart';
import 'package:kanbansim/common/savefile_parsers/users_list_parser.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';

class SavefileCreator {
  List<User> _users;
  Map<String, List<Task>> _lists;

  SavefileCreator() {
    _users = <User>[];
    _lists = Map<String, List<Task>>();
  }

  void setUsersList(List<User> users) {
    this._users = users;
  }

  void addTasksListsWithTitle(List<Task> tasks, String title) {
    if (_lists.containsKey(title)) {
      throw ArgumentError("Task list with this title already exists.");
    } else {
      _lists[title] = tasks;
    }
  }

  void clearUsersList() {
    this._users = <User>[];
  }

  void clearTasksLists() {
    this._lists = Map<String, List<Task>>();
  }

  String convertDataToString() {
    String data = "";
    data = _writeUsers(data);
    data = _writeBlankLine(data);
    data = _writeTasks(data);

    return data;
  }

  String _writeUsers(String data) {
    UsersListsParser usersListsParser = UsersListsParser();
    data += usersListsParser.parseUsersListToString(_users);
    return data;
  }

  String _writeTasks(String data) {
    TasksListsListParser taskListsParser = TasksListsListParser(() => _users);
    data += taskListsParser.parseTasksListsListToString(_lists);
    return data;
  }

  String _writeBlankLine(String data) {
    return data + "\n";
  }
}