import 'package:kanbansim/models/sim_state.dart';

class SimStateParser {
  _SimStateWriter _writer;
  _SimStateReader _reader;

  SimStateParser() {
    this._writer = _SimStateWriter();
    this._reader = _SimStateReader();
  }

  String parseSimStateDataToString(SimState state) {
    String data = "";

    data = _writer.writeHeadline(data);
    data = _writer.writeCurrentDay(data, state.currentDay);
    data = _writer.writeLatestTaskID(data, state.getLatestTaskID());
    data = _writer.writeStageOneInProgressColumnLimit(
      data,
      state.stageOneInProgressColumnLimit,
    );
    data = _writer.writeStageOneDoneColumnLimit(
      data,
      state.stageOneDoneColumnLimit,
    );
    data = _writer.writeStageTwoColumnLimit(
      data,
      state.stageTwoColumnLimit,
    );
    data = _writer.writeEndingHeadline(data);

    return data;
  }

  int getCurrentDayFromString(String data) {
    return _reader.readCurrentSimDay(data);
  }

  int getLatestTaskID(String data) {
    return _reader.readLatestTaskID(data);
  }

  int getStageOneInProgressColumnLimit(String data) {
    return _reader.readStageOneInProgressColumnLimit(data);
  }

  int getStageOneDoneColumnLimit(String data) {
    return _reader.readStageOneDoneColumnLimit(data);
  }

  int getStageTwoColumnLimit(String data) {
    return _reader.readStageTwoColumnLimit(data);
  }
}

class _SimStateWriter {
  String _headlineTabs = "";
  String _paramsTabs = "\t";

  String writeHeadline(String data) {
    data += _headlineTabs + "[BEGIN_SIM_STATE_PARAMS]" + "\n";
    return data;
  }

  String writeEndingHeadline(String data) {
    data += _headlineTabs + "[END_SIM_STATE_PARAMS]" + "\n";
    return data;
  }

  String writeCurrentDay(String data, int day) {
    data += _paramsTabs + "[CURRENT_DAY] $day" + "\n";
    return data;
  }

  String writeLatestTaskID(String data, int id) {
    data += _paramsTabs + "[LATEST_TASK_ID] $id" + "\n";
    return data;
  }

  String writeStageOneInProgressColumnLimit(String data, int limit) {
    if (limit == null) {
      limit = -1;
    }

    data += _paramsTabs + "[STAGE_ONE_IN_PROGRESS_COLUMN_LIMIT] $limit" + "\n";
    return data;
  }

  String writeStageOneDoneColumnLimit(String data, int limit) {
    if (limit == null) {
      limit = -1;
    }

    data += _paramsTabs + "[STAGE_ONE_DONE_COLUMN_LIMIT] $limit" + "\n";
    return data;
  }

  String writeStageTwoColumnLimit(String data, int limit) {
    if (limit == null) {
      limit = -1;
    }

    data += _paramsTabs + "[STAGE_TWO_COLUMN_LIMIT] $limit" + "\n";
    return data;
  }
}

class _SimStateReader {
  int readCurrentSimDay(String data) {
    List<String> formattedData = _substringSimStateData(data);
    return int.parse(formattedData[1].split(" ")[1]);
  }

  int readLatestTaskID(String data) {
    List<String> formattedData = _substringSimStateData(data);
    return int.parse(formattedData[2].split(" ")[1]);
  }

  int readStageOneInProgressColumnLimit(String data) {
    List<String> formattedData = _substringSimStateData(data);
    int value = int.parse(formattedData[3].split(" ")[1]);

    if (value == -1) {
      return null;
    } else {
      return value;
    }
  }

  int readStageOneDoneColumnLimit(String data) {
    List<String> formattedData = _substringSimStateData(data);
    int value = int.parse(formattedData[4].split(" ")[1]);

    if (value == -1) {
      return null;
    } else {
      return value;
    }
  }

  int readStageTwoColumnLimit(String data) {
    List<String> formattedData = _substringSimStateData(data);
    int value = int.parse(formattedData[5].split(" ")[1]);

    if (value == -1) {
      return null;
    } else {
      return value;
    }
  }

  List<String> _substringSimStateData(String data) {
    final userListStartSentence = "[BEGIN_SIM_STATE_PARAMS]";
    final userListEndSentence = "[END_SIM_STATE_PARAMS]";
    int userListStartLength = userListStartSentence.length;
    int userListEndLength = userListEndSentence.length;
    int columnStartIndex = data.indexOf(userListStartSentence);
    int columnEndIndex = data.indexOf(
      userListEndSentence,
      columnStartIndex + userListStartLength,
    );

    String currentData = data.substring(
      columnStartIndex,
      columnEndIndex + userListEndLength,
    );

    List<String> formattedData = currentData.split("\n");

    return formattedData;
  }
}
