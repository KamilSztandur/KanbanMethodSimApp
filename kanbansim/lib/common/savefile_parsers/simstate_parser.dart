class SimStateParser {
  _SimStateWriter _writer;
  _SimStateReader _reader;

  SimStateParser() {
    this._writer = _SimStateWriter();
    this._reader = _SimStateReader();
  }

  String parseSimStateDataToString(int currentSimDay, int latestTaskID) {
    String data = "";
    
    data = _writer.writeHeadline(data);
    data = _writer.writeCurrentDay(data, currentSimDay);
    data = _writer.writeLatestTaskID(data, latestTaskID);
    data = _writer.writeEndingHeadline(data);
    
    return data;
  }

  int getCurrentDayFromString(String data) {
    return _reader.readCurrentSimDay(data);
  }

  int getLatestTaskID(String data) {
    return _reader.readLatestTaskID(data);
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
