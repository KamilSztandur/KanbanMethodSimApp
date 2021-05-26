import 'package:kanbansim/common/savefile_parsers/task_list_parser.dart';
import 'package:kanbansim/models/task.dart';

class TasksListsListParser {
  _TasksListsListWriter _writer;
  _TasksListsListReader _reader;

  TasksListsListParser(Function getAllUsers) {
    this._writer = _TasksListsListWriter(getAllUsers);
    this._reader = _TasksListsListReader(getAllUsers);
  }

  String parseTasksListsListToString(Map<String, List<Task>> taskListsList) {
    String data = "";

    data = _writer.writeHeadline(data);
    taskListsList.keys.forEach(
      (key) => data = _writer.writeTaskList(data, taskListsList[key], key),
    );
    data = _writer.writeEndingHeadline(data);

    return data;
  }

  List<Task> getTaskListFromDataString(String data, String taskListTitle) {
    return _reader.readTaskListTitledAs(data, taskListTitle);
  }
}

class _TasksListsListWriter {
  TasksListParser _parser;
  String _headlineTabs = "";

  _TasksListsListWriter(Function getAllUsers) {
    this._parser = TasksListParser(getAllUsers);
  }

  String writeHeadline(String data) {
    data += _headlineTabs + "[BEGIN_TASK_LISTS]" + "\n";
    return data;
  }

  String writeEndingHeadline(String data) {
    data += _headlineTabs + "[END_TASK_LISTS]" + "\n";
    return data;
  }

  String writeTaskList(String data, List<Task> list, String title) {
    data += _parser.parseTasksListToString(list, title);
    return data;
  }
}

class _TasksListsListReader {
  TasksListParser _parser;

  _TasksListsListReader(Function getAllUsers) {
    this._parser = TasksListParser(getAllUsers);
  }

  List<Task> readTaskListTitledAs(String data, String taskListTitle) {
    final startSentence = "[BEGIN_TASK_LISTS]";
    final endSentence = "[END_TASK_LISTS]";

    int startLength = startSentence.length;
    int endLength = endSentence.length;

    int columnStartIndex = data.indexOf(startSentence);
    int columnEndIndex = data.indexOf(
      endSentence,
      columnStartIndex + startLength,
    );

    String taskListsData = data.substring(
      columnStartIndex,
      columnEndIndex + endLength,
    );

    return _parser.parseStringToTasksList(taskListsData, taskListTitle);
  }
}
