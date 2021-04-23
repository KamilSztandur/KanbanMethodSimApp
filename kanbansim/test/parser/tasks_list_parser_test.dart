import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanbansim/common/savefile_parsers/task_list_parser.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';
import 'package:kanbansim/models/User.dart';

void main() {
  group(
    'TasksListParser',
    () {
      TasksListParser _parser;
      List<User> _users;
      List<Task> _tasks;

      setUpAll(() {
        _users = _getSampleUserList();
        _tasks = _getSampleTasksList(_users);
        _parser = TasksListParser(() => _users);
      });

      tearDownAll(() {
        _parser = null;
        _tasks = null;
        _users = null;
      });

      test(
        'returns Tasks list correctly converted to String',
        () {
          String parsedTasksList = _parser.parseTasksListToString(
            _tasks,
            "test",
          );

          expect(parsedTasksList, _getSampleParsedTasksList());
        },
      );

      test(
        'returns Tasks list correctly reconstructed from String',
        () {
          String parsedTaskList = _getSampleParsedTasksList();
          List<Task> tasks = _parser.parseStringToTasksList(
            parsedTaskList,
            "test",
          );

          expect(tasks.length, _tasks.length);

          int n = tasks.length;
          for (int i = 0; i < n; i++) {
            expect(tasks[i].getTitle(), _tasks[i].getTitle());
            expect(tasks[i].getTaskType(), _tasks[i].getTaskType());
            expect(tasks[i].getID(), _tasks[i].getID());
            expect(tasks[i].owner.getID(), _tasks[i].owner.getID());
            expect(
              tasks[i].getProductivityRequiredToUnlock(),
              _tasks[i].getProductivityRequiredToUnlock(),
            );
            expect(tasks[i].getDeadlineDay(), _tasks[i].getDeadlineDay());
            expect(
              tasks[i].progress.getNumberOfAllParts(),
              _tasks[i].progress.getNumberOfAllParts(),
            );
            expect(
              tasks[i].progress.getNumberOfUnfulfilledParts(),
              _tasks[i].progress.getNumberOfUnfulfilledParts(),
            );
            expect(
              tasks[i].progress.getUserID(0),
              _tasks[i].progress.getUserID(0),
            );
            expect(
              tasks[i].progress.getUserID(1),
              _tasks[i].progress.getUserID(1),
            );
            expect(
              tasks[i].progress.getUserID(2),
              _tasks[i].progress.getUserID(2),
            );
            expect(
              tasks[i].progress.getUserID(3),
              _tasks[i].progress.getUserID(3),
            );
            expect(
              tasks[i].progress.getUserID(4),
              _tasks[i].progress.getUserID(4),
            );
          }
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

String _getSampleParsedTasksList() {
  return "" +
      "\t[BEGIN_TEST_TASKS_COLUMN]\n" +
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
      "\t[END_TEST_TASKS_COLUMN]\n";
}
