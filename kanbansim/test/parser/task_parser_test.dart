import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanbansim/common/savefile_parsers/task_parser.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';
import 'package:kanbansim/models/User.dart';

void main() {
  group(
    'TaskParser',
    () {
      TaskParser _taskParser;
      List<User> _users;

      setUpAll(() {
        _users = <User>[];
        _users.add(_getTestUser());
        _users.add(_getAnotherTestUser());

        _taskParser = TaskParser(() => _users);
      });

      tearDownAll(() {
        _taskParser = null;
        _users = null;
      });

      test(
        'returns Task correctly converted to String',
        () {
          Task task = _getSampleTask(_users);

          String parsedTask = _taskParser.parseTaskToString(task);

          expect(parsedTask, _getParsedSampleTask());
        },
      );

      test(
        'correctly reconstructs task from String',
        () {
          String parsedTask = _getParsedSampleTask();

          Task task = _taskParser.parseStringToTask(parsedTask);

          expect(task.getTitle(), "Sample task");
          expect(task.getTaskType(), TaskType.Standard);
          expect(task.getID(), 1);
          expect(task.owner.getID(), 0);
          expect(task.getProductivityRequiredToUnlock(), 0);
          expect(task.getDeadlineDay(), -1);
          expect(task.progress.getNumberOfAllParts(), 5);
          expect(task.progress.getNumberOfUnfulfilledParts(), 2);
          expect(task.progress.getUserID(0), 0);
          expect(task.progress.getUserID(1), 1);
          expect(task.progress.getUserID(2), 1);
          expect(task.progress.getUserID(3), -1);
          expect(task.progress.getUserID(4), -1);
        },
      );

      test(
        'should throw FormatException when invalid task ID\'s value in given Task data (not integer)',
        () {
          String testTask = "\t\t[BEGIN_TASK]\n" +
              "\t\t\t[TITLE] {Sample task}\n" +
              "\t\t\t[TASKTYPE] TaskType.Standard\n" +
              "\t\t\t[TASK_ID] 1.5\n" +
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
              "\t\t[END_TASK]\n";

          expect(
            () => _taskParser.parseStringToTask(testTask),
            throwsA(predicate((e) => e is FormatException)),
          );
        },
      );

      test(
        'should throw FormatException when invalid owner ID\'s value in given Task data (not integer)',
        () {
          String testTask = "\t\t[BEGIN_TASK]\n" +
              "\t\t\t[TITLE] {Sample task}\n" +
              "\t\t\t[TASKTYPE] TaskType.Standard\n" +
              "\t\t\t[TASK_ID] 1\n" +
              "\t\t\t[OWNER_ID] 0.5\n" +
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
              "\t\t[END_TASK]\n";

          expect(
            () => _taskParser.parseStringToTask(testTask),
            throwsA(predicate((e) => e is FormatException)),
          );
        },
      );

      test(
        'should throw ArgumentError when invalid task ID\'s value in given Task data (negative integer)',
        () {
          String testTask = "\t\t[BEGIN_TASK]\n" +
              "\t\t\t[TITLE] {Sample task}\n" +
              "\t\t\t[TASKTYPE] TaskType.Standard\n" +
              "\t\t\t[TASK_ID] -1\n" +
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
              "\t\t[END_TASK]\n";

          expect(
            () => _taskParser.parseStringToTask(testTask),
            throwsA(predicate(
              (e) =>
                  e is ArgumentError &&
                  e.message == "Task ID must not be negative value.",
            )),
          );
        },
      );

      test(
        'should throw ArgumentError when invalid owner ID\'s value in given Task data (negative integer)',
        () {
          String testTask = "\t\t[BEGIN_TASK]\n" +
              "\t\t\t[TITLE] {Sample task}\n" +
              "\t\t\t[TASKTYPE] TaskType.Standard\n" +
              "\t\t\t[TASK_ID] 0\n" +
              "\t\t\t[OWNER_ID] -1\n" +
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
              "\t\t[END_TASK]\n";

          expect(
            () => _taskParser.parseStringToTask(testTask),
            throwsA(predicate(
              (e) =>
                  e is ArgumentError &&
                  e.message == "Owner ID must not be negative value.",
            )),
          );
        },
      );

      test(
        'should throw ArgumentError when invalid prodReqToUnlock\'s value in given Task data (negative integer)',
        () {
          String testTask = "\t\t[BEGIN_TASK]\n" +
              "\t\t\t[TITLE] {Sample task}\n" +
              "\t\t\t[TASKTYPE] TaskType.Standard\n" +
              "\t\t\t[TASK_ID] 0\n" +
              "\t\t\t[OWNER_ID] 0\n" +
              "\t\t\t[PROD_REQ_TO_UNLOCK] -1\n" +
              "\t\t\t[PROD_REQ_TO_COMPLETE] 5\n" +
              "\t\t\t[DEADLINE] -1\n" +
              "\t\t\t[BEGIN_TASKPROGRESS]\n" +
              "\t\t\t\t[PART] 0\n" +
              "\t\t\t\t[PART] 1\n" +
              "\t\t\t\t[PART] 1\n" +
              "\t\t\t\t[PART] -1\n" +
              "\t\t\t\t[PART] -1\n" +
              "\t\t\t[END_TASKPROGRESS]\n" +
              "\t\t[END_TASK]\n";

          expect(
            () => _taskParser.parseStringToTask(testTask),
            throwsA(predicate(
              (e) =>
                  e is ArgumentError &&
                  e.message == "prodReqToUnlock must not be negative value.",
            )),
          );
        },
      );

      test(
        'should throw ArgumentError when invalid prodReqToComplete\'s value in given Task data (less than 0)',
        () {
          String testTask = "\t\t[BEGIN_TASK]\n" +
              "\t\t\t[TITLE] {Sample task}\n" +
              "\t\t\t[TASKTYPE] TaskType.Standard\n" +
              "\t\t\t[TASK_ID] 0\n" +
              "\t\t\t[OWNER_ID] 0\n" +
              "\t\t\t[PROD_REQ_TO_UNLOCK] 0\n" +
              "\t\t\t[PROD_REQ_TO_COMPLETE] -1\n" +
              "\t\t\t[DEADLINE] -1\n" +
              "\t\t\t[BEGIN_TASKPROGRESS]\n" +
              "\t\t\t\t[PART] 0\n" +
              "\t\t\t\t[PART] 1\n" +
              "\t\t\t\t[PART] 1\n" +
              "\t\t\t\t[PART] -1\n" +
              "\t\t\t\t[PART] -1\n" +
              "\t\t\t[END_TASKPROGRESS]\n" +
              "\t\t[END_TASK]\n";

          expect(
            () => _taskParser.parseStringToTask(testTask),
            throwsA(predicate(
              (e) =>
                  e is ArgumentError &&
                  e.message == "prodReqToComplete must bigger than 0.",
            )),
          );
        },
      );
    },
  );
}

Task _getSampleTask(List<User> users) {
  Task task = Task("Sample task", 5, users[0], TaskType.Standard);
  task.investProductivityFrom(users[0], 1);
  task.investProductivityFrom(users[1], 2);

  return task;
}

String _getParsedSampleTask() {
  return "" +
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
      "\t\t[END_TASK]\n";
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
