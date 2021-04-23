import 'package:kanbansim/common/savefile_parsers/task_parser.dart';
import 'package:kanbansim/models/Task.dart';

class TasksListParser {
  _TasksListWriter _writer;
  TaskParser _parser;

  TasksListParser(Function getAllUsers) {
    this._writer = _TasksListWriter(getAllUsers);
    this._parser = TaskParser(getAllUsers);
  }

  String parseTasksListToString(List<Task> tasks, String title) {
    int n = tasks.length;
    String data = "";

    data = _writer.writeHeadline(data, title);
    for (int i = 0; i < n; i++) {
      data = _writer.writeTask(data, tasks[i]);
    }
    data = _writer.writeEndingHeadline(data, title);

    return data;
  }

  List<Task> parseStringToTasksList(String data, String title) {
    final formattedTitle = _writer.formatTitle(title);
    final startSentence = "[BEGIN_${formattedTitle}_TASKS_COLUMN]";
    final endSentence = "[END_${formattedTitle}_TASKS_COLUMN]";
    int startLength = startSentence.length;
    int endLength = endSentence.length;

    int columnStartIndex = data.indexOf(startSentence);
    int columnEndIndex = data.indexOf(
      endSentence,
      columnStartIndex + startLength,
    );

    List<Task> tasks = <Task>[];
    String currentData = data.substring(
      columnStartIndex,
      columnEndIndex + endLength,
    );

    final taskStartSentence = "[BEGIN_TASK]";
    final taskEndSentence = "[END_TASK]";
    while (true) {
      int dataLength = currentData.length;
      int startIndex = currentData.indexOf(taskStartSentence);
      int taskStartLength = taskStartSentence.length;
      int taskEndLength = taskEndSentence.length;
      int endIndex = currentData.indexOf(
        taskEndSentence,
        startIndex + taskStartLength,
      );

      if (startIndex == -1 || endIndex == -1) {
        break;
      }

      String currentTaskData = currentData.substring(
        startIndex,
        endIndex + taskEndLength,
      );
      tasks.add(_parser.parseStringToTask(currentTaskData));

      currentData = currentData.substring(endIndex + taskEndLength, dataLength);
    }

    return tasks;
  }
}

class _TasksListWriter {
  TaskParser _taskParser;
  String _headlineTabs = "\t";

  _TasksListWriter(Function getAllUsers) {
    this._taskParser = TaskParser(getAllUsers);
  }

  String writeHeadline(String data, String title) {
    data += _headlineTabs + "[BEGIN_${formatTitle(title)}_TASKS_COLUMN]" + "\n";
    return data;
  }

  String writeEndingHeadline(String data, String title) {
    data += _headlineTabs + "[END_${formatTitle(title)}_TASKS_COLUMN]" + "\n";
    return data;
  }

  String writeTask(String data, Task task) {
    String taskData = _taskParser.parseTaskToString(task);
    data += taskData;
    return data;
  }

  String formatTitle(String title) {
    return title.toUpperCase().replaceAll(" ", "_");
  }
}
