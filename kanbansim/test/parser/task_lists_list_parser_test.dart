import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanbansim/common/savefile_parsers/tasks_lists_list_parser.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';
import 'package:kanbansim/models/User.dart';

void main() {
  group(
    'TaskListsListParser',
    () {
      List<User> _users;
      TasksListsListParser _parser;

      setUpAll(() {
        _users = _getSampleUserList();
        _parser = TasksListsListParser(() => _users);
      });

      tearDownAll(() {
        _parser = null;
        _users = null;
      });

      test(
        'returns correctly parsed Task List List to String.',
        () {
          Map<String, List<Task>> lists = _getSampleTaskListsList(_users);

          String parsedTaskListsList =
              _parser.parseTasksListsListToString(lists);

          expect(parsedTaskListsList, _getSampleParsedTaskListsList());
        },
      );

      test(
        'return correctly reconstructed task list with certain title from data.',
        () {
          String parsedTaskListsList = _getSampleParsedTaskListsList();

          List<Task> reconstructedTaskList = _parser.getTaskListFromDataString(
              parsedTaskListsList, 'second test list');
          reconstructedTaskList.forEach(
            (task) => {},
          );
        },
      );
    },
  );
}

List<User> _getSampleUserList() {
  List<User> users = <User>[];
  users.add(_getTestUser());
  users.add(_getAnotherTestUser());

  return users;
}

Map<String, List<Task>> _getSampleTaskListsList(List<User> users) {
  Map<String, List<Task>> lists = Map<String, List<Task>>();
  lists['first test list'] = _getSampleTasksList(users);
  lists['second test list'] = _getSampleTasksList(users);

  return lists;
}

String _getSampleParsedTaskListsList() {
  return "" +
      "[BEGIN_TASK_LISTS]\n" +
      "\t[BEGIN_FIRST_TEST_LIST_TASKS_COLUMN]\n" +
      "\t\t[BEGIN_TASK]\n" +
      "\t\t\t[TITLE] {Sample task}\n" +
      "\t\t\t[TASKTYPE] TaskType.Standard\n" +
      "\t\t\t[TASK_ID] 1\n" +
      "\t\t\t[OWNER_ID] 0\n" +
      "\t\t\t[PROD_REQ_TO_UNLOCK] 0\n" +
      "\t\t\t[PROD_REQ_TO_COMPLETE] 5\n" +
      "\t\t\t[DEADLINE] -1\n" +
      "\t\t\t[BEGIN_TASKPROGRESS]\n" +
      "\t\t\t\t[PART] 0\n" +
      "\t\t\t\t[PART] 1\n" +
      "\t\t\t\t[PART] 1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t[END_TASKPROGRESS]\n" +
      "\t\t[END_TASK]\n" +
      "\t\t[BEGIN_TASK]\n" +
      "\t\t\t[TITLE] {Another sample task}\n" +
      "\t\t\t[TASKTYPE] TaskType.Expedite\n" +
      "\t\t\t[TASK_ID] 2\n" +
      "\t\t\t[OWNER_ID] 1\n" +
      "\t\t\t[PROD_REQ_TO_UNLOCK] 0\n" +
      "\t\t\t[PROD_REQ_TO_COMPLETE] 5\n" +
      "\t\t\t[DEADLINE] -1\n" +
      "\t\t\t[BEGIN_TASKPROGRESS]\n" +
      "\t\t\t\t[PART] 0\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t[END_TASKPROGRESS]\n" +
      "\t\t[END_TASK]\n" +
      "\t[END_FIRST_TEST_LIST_TASKS_COLUMN]\n" +
      "\t[BEGIN_SECOND_TEST_LIST_TASKS_COLUMN]\n" +
      "\t\t[BEGIN_TASK]\n" +
      "\t\t\t[TITLE] {Sample task}\n" +
      "\t\t\t[TASKTYPE] TaskType.Standard\n" +
      "\t\t\t[TASK_ID] 3\n" +
      "\t\t\t[OWNER_ID] 0\n" +
      "\t\t\t[PROD_REQ_TO_UNLOCK] 0\n" +
      "\t\t\t[PROD_REQ_TO_COMPLETE] 5\n" +
      "\t\t\t[DEADLINE] -1\n" +
      "\t\t\t[BEGIN_TASKPROGRESS]\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t[END_TASKPROGRESS]\n" +
      "\t\t[END_TASK]\n" +
      "\t\t[BEGIN_TASK]\n" +
      "\t\t\t[TITLE] {Another sample task}\n" +
      "\t\t\t[TASKTYPE] TaskType.Expedite\n" +
      "\t\t\t[TASK_ID] 4\n" +
      "\t\t\t[OWNER_ID] 1\n" +
      "\t\t\t[PROD_REQ_TO_UNLOCK] 0\n" +
      "\t\t\t[PROD_REQ_TO_COMPLETE] 5\n" +
      "\t\t\t[DEADLINE] -1\n" +
      "\t\t\t[BEGIN_TASKPROGRESS]\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t\t[PART] -1\n" +
      "\t\t\t[END_TASKPROGRESS]\n" +
      "\t\t[END_TASK]\n" +
      "\t[END_SECOND_TEST_LIST_TASKS_COLUMN]\n" +
      "[END_TASK_LISTS]\n";
}

User _getTestUser() {
  User testUser = User("Kamil", 5, Color.fromRGBO(55, 66, 77, 1.0));
  testUser.decreaseProductivity(2);

  return testUser;
}

User _getAnotherTestUser() {
  User testUser = User("Bartek", 5, Color.fromRGBO(11, 22, 33, 1.0));
  testUser.decreaseProductivity(1);

  return testUser;
}

List<Task> _getSampleTasksList(List<User> users) {
  List<Task> tasks = <Task>[];
  tasks.add(_getSampleTask(users));
  tasks.add(_getAnotherSampleTask(users));

  return tasks;
}

Task _getSampleTask(List<User> users) {
  Task task = Task("Sample task", 5, users[0], TaskType.Standard);
  task.investProductivityFrom(users[0], 1);
  task.investProductivityFrom(users[1], 2);

  return task;
}

Task _getAnotherSampleTask(List<User> users) {
  Task task = Task("Another sample task", 5, users[1], TaskType.Expedite);
  task.investProductivityFrom(users[0], 1);
  task.investProductivityFrom(users[1], 2);

  return task;
}
