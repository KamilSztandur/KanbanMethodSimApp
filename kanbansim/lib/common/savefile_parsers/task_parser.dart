import 'package:kanbansim/models/task.dart';
import 'package:kanbansim/models/task_type.dart';
import 'package:kanbansim/models/user.dart';

class TaskParser {
  Function _getAllUsers;
  _TaskWriter _writer;
  _TaskReader _reader;

  TaskParser(Function getAllUsers) {
    this._getAllUsers = getAllUsers;
    this._writer = _TaskWriter();
    this._reader = _TaskReader(getAllUsers());
  }

  get trueList => null;

  String parseTaskToString(Task task) {
    String data = "";

    String title = task.getTitle();
    TaskType type = task.getTaskType();

    int id = task.getID();

    int ownerID;
    if (task.owner == null) {
      ownerID = -1;
    } else {
      ownerID = task.owner.getID();
    }

    int prodReqToUnlock = task.getProductivityRequiredToUnlock();
    int prodReqToComplete = task.progress.getNumberOfAllParts();
    int deadline = task.getDeadlineDay();
    int startDay = task.startDay;
    int endDay = task.endDay;
    int currentStage = task.stage;

    data = _writer.writeHeadline(data);
    data = _writer.writeTaskTitle(data, title);
    data = _writer.writeTaskType(data, type);
    data = _writer.writeTaskID(data, id);
    data = _writer.writeTaskOwnerID(data, ownerID);
    data = _writer.writeTaskProdReqToUnlock(data, prodReqToUnlock);
    data = _writer.writeTaskProdReqToComplete(data, prodReqToComplete);
    data = _writer.writeTaskDeadline(data, deadline);
    data = _writer.writeTaskStartDay(data, startDay);
    data = _writer.writeTaskEndDay(data, endDay);
    data = _writer.writeTaskCurrentStage(data, currentStage);
    data = _writer.writeTaskProgressHeadline(data);
    data = _writer.writeTaskProgressParts(data, task);
    data = _writer.writeTaskProgressEndingHeadline(data);
    data = _writer.writeEndingHeadline(data);

    return data;
  }

  Task parseStringToTask(String parsedTask) {
    List<String> data = parsedTask.split("\n");

    String title = _reader.getTaskTitle(data);
    TaskType type = _reader.getTaskType(data);
    int taskID = _reader.getTaskID(data);
    if (taskID < 0) {
      throw ArgumentError("Task ID must not be negative value.");
    }

    int ownerID = _reader.getOwnerID(data);

    int prodReqToUnlock = _reader.getProdReqToUnlock(data);
    if (prodReqToUnlock < 0) {
      throw ArgumentError("prodReqToUnlock must not be negative value.");
    }

    int prodReqToComplete = _reader.getProdReqToComplete(data);
    if (prodReqToComplete < 0) {
      throw ArgumentError("prodReqToComplete must bigger than 0.");
    }

    int deadline = _reader.getDeadlineDayNumber(data);
    int startDay = _reader.getStartDay(data);
    int endDay = _reader.getEndDay(data);
    int currentStage = _reader.getCurrentStage(data);

    User owner = _getOwner(ownerID);
    List<User> parts = _reader.getParts(data, prodReqToComplete);

    Task task = Task(title, prodReqToComplete, owner, type);
    task.loadAdditionalDataFromSavefile(taskID, parts, prodReqToUnlock);
    task.setDeadlineDay(deadline);
    task.startDay = startDay;
    task.endDay = endDay;
    task.stage = currentStage;

    return task;
  }

  User _getOwner(int ownerID) {
    if (ownerID == -1) {
      return null;
    } else {
      List<User> users = _getAllUsers();

      int n = users.length;
      for (int i = 0; i < n; i++) {
        if (ownerID == users[i].getID()) {
          return users[i];
        }
      }

      return null;
    }
  }
}

class _TaskWriter {
  String _headlineTabs = "\t\t";
  String _paramsTabs = "\t\t\t";
  String _progressParamsTabs = "\t\t\t\t";

  String writeHeadline(String data) {
    data += _headlineTabs + "[BEGIN_TASK]" + "\n";
    return data;
  }

  String writeEndingHeadline(String data) {
    data += _headlineTabs + "[END_TASK]" + "\n";
    return data;
  }

  String writeTaskProgressHeadline(String data) {
    data += _paramsTabs + "[BEGIN_TASKPROGRESS]" + "\n";
    return data;
  }

  String writeTaskProgressEndingHeadline(String data) {
    data += _paramsTabs + "[END_TASKPROGRESS]" + "\n";
    return data;
  }

  String writeTaskTitle(String data, String title) {
    data += _paramsTabs + "[TITLE] {$title}" + "\n";
    return data;
  }

  String writeTaskID(String data, int id) {
    data += _paramsTabs + "[TASK_ID] $id" + "\n";
    return data;
  }

  String writeTaskOwnerID(String data, int ownerID) {
    data += _paramsTabs + "[OWNER_ID] $ownerID" + "\n";
    return data;
  }

  String writeTaskProdReqToUnlock(String data, int prodReqToUnlock) {
    data += _paramsTabs + "[PROD_REQ_TO_UNLOCK] $prodReqToUnlock" + "\n";
    return data;
  }

  String writeTaskProdReqToComplete(String data, int prodReqToComplete) {
    data += _paramsTabs + "[PROD_REQ_TO_COMPLETE] $prodReqToComplete" + "\n";
    return data;
  }

  String writeTaskDeadline(String data, int deadline) {
    data += _paramsTabs + "[DEADLINE] $deadline" + "\n";
    return data;
  }

  String writeTaskStartDay(String data, int startDay) {
    if (startDay == null) {
      startDay = -1;
    }

    data += _paramsTabs + "[START_DAY] $startDay" + "\n";
    return data;
  }

  String writeTaskEndDay(String data, int endDay) {
    if (endDay == null) {
      endDay = -1;
    }

    data += _paramsTabs + "[END_DAY] $endDay" + "\n";
    return data;
  }

  String writeTaskCurrentStage(String data, int currentStage) {
    data += _paramsTabs + "[CURRENT_STAGE] $currentStage" + "\n";
    return data;
  }

  String writeTaskProgressParts(String data, Task task) {
    int n = task.progress.getNumberOfAllParts();
    int n_unfullfilled = task.progress.getNumberOfUnfulfilledParts();
    int n_fulfilled = n - n_unfullfilled;

    for (int i = 0; i < n_fulfilled; i++) {
      int id = task.progress.getUserID(i);

      data += _progressParamsTabs + "[PART] $id" + "\n";
    }

    for (int i = 0; i < n_unfullfilled; i++) {
      data += _progressParamsTabs + "[PART] -1" + "\n";
    }

    return data;
  }

  String writeTaskType(String data, TaskType type) {
    data += _paramsTabs + "[TASKTYPE] $type" + "\n";
    return data;
  }
}

class _TaskReader {
  List<User> users;

  _TaskReader(List<User> users) {
    this.users = users;
  }

  String getTaskTitle(List<String> data) {
    RegExp getTitleRegExp = RegExp('\{(.*?)\}');
    String name = getTitleRegExp
        .stringMatch(data[1])
        .replaceAll("{", "")
        .replaceAll("}", "");

    return name;
  }

  TaskType getTaskType(List<String> data) {
    String type = data[2].split(" ")[1];
    return TaskType.values.firstWhere((e) => e.toString() == type);
  }

  int getTaskID(List<String> data) {
    return int.parse(data[3].split(" ")[1]);
  }

  int getOwnerID(List<String> data) {
    return int.parse(data[4].split(" ")[1]);
  }

  int getProdReqToUnlock(List<String> data) {
    return int.parse(data[5].split(" ")[1]);
  }

  int getProdReqToComplete(List<String> data) {
    return int.parse(data[6].split(" ")[1]);
  }

  int getDeadlineDayNumber(List<String> data) {
    return int.parse(data[7].split(" ")[1]);
  }

  int getStartDay(List<String> data) {
    int value = int.parse(data[8].split(" ")[1]);

    if (value == -1) {
      return null;
    } else {
      return value;
    }
  }

  int getEndDay(List<String> data) {
    int value = int.parse(data[9].split(" ")[1]);

    if (value == -1) {
      return null;
    } else {
      return value;
    }
  }

  int getCurrentStage(List<String> data) {
    int value = int.parse(data[10].split(" ")[1]);

    if (value == -1) {
      return null;
    } else {
      return value;
    }
  }

  List<User> getParts(List<String> data, int prodReqToComplete) {
    int startLineNumber = 12;

    List<User> parts = <User>[];
    for (int i = 0; i < prodReqToComplete; i++) {
      int id = int.parse(data[startLineNumber + i].split(" ")[1]);
      if (id == -1) {
        parts.add(null);
      } else {
        User part = _getUser(id);
        parts.add(part);
      }
    }

    return parts;
  }

  User _getUser(int userID) {
    int n = this.users.length;
    for (int i = 0; i < n; i++) {
      if (userID == this.users[i].getID()) {
        return this.users[i];
      }
    }

    return null;
  }
}
