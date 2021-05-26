import 'package:flutter/material.dart';
import 'package:kanbansim/models/user.dart';

class UserParser {
  _UserWriter _writer;
  _UserReader _reader;

  UserParser() {
    this._writer = _UserWriter();
    this._reader = _UserReader();
  }

  String parseUserToString(User user) {
    int userID = user.getID();
    String username = user.getName();
    int maxProductivity = user.getMaxProductivity();
    int productivity = user.getProductivity();
    List<int> rgb_values = _getUserRGBValues(user);

    String data = "";
    data = _writer.writeHeadline(data);
    data = _writer.writeUserID(data, userID);
    data = _writer.writeUserName(data, username);
    data = _writer.writeUserRGB(data, rgb_values);
    data = _writer.writeMaxProductivity(data, maxProductivity);
    data = _writer.writeProductivity(data, productivity);
    data = _writer.writeEndingHeadline(data);

    return data;
  }

  User parseStringToUser(String parsedUser) {
    List<String> data = parsedUser.split("\n");

    int id = _reader.getUserID(data);
    if (id < 0) {
      throw ArgumentError("ID must not be negative value.");
    }

    String name = _reader.getUserName(data);
    Color color = _reader.getUserColor(data);

    int maxProductivity = _reader.getMaxProductivity(data);
    if (maxProductivity < 0) {
      throw ArgumentError("maxProductivity must not be negative value.");
    }

    int productivity = _reader.getProductivity(data);
    if (productivity < 0) {
      throw ArgumentError("productivity must not be negative value.");
    }

    User user = User(name, maxProductivity, color);
    user.loadAdditionalDataFromSavefile(id, productivity);

    return user;
  }

  List<int> _getUserRGBValues(User user) {
    List<int> rgb_values = <int>[];
    rgb_values.add(user.getColor().red);
    rgb_values.add(user.getColor().green);
    rgb_values.add(user.getColor().blue);

    return rgb_values;
  }
}

class _UserReader {
  int getUserID(List<String> data) {
    return int.parse(data[1].split(" ")[1]);
  }

  String getUserName(List<String> data) {
    RegExp getNameRegExp = RegExp('\{(.*?)\}');
    String name = getNameRegExp
        .stringMatch(data[2])
        .replaceAll("{", "")
        .replaceAll("}", "");

    return name;
  }

  Color getUserColor(List<String> data) {
    List<String> rgb_values = data[3]
        .split(" ")[1]
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll(" ", "")
        .split(",");

    int red = int.parse(rgb_values[0]);
    int green = int.parse(rgb_values[1]);
    int blue = int.parse(rgb_values[2]);

    return Color.fromRGBO(red, green, blue, 1.0);
  }

  int getMaxProductivity(List<String> data) {
    return int.parse(data[4].split(" ")[1]);
  }

  int getProductivity(List<String> data) {
    return int.parse(data[5].split(" ")[1]);
  }
}

class _UserWriter {
  String _headlineTabs = "\t";
  String _paramsTabs = "\t\t";

  String writeHeadline(String data) {
    data += _headlineTabs + "[BEGIN_USER]" + "\n";
    return data;
  }

  String writeEndingHeadline(String data) {
    data += _headlineTabs + "[END_USER]" + "\n";
    return data;
  }

  String writeUserID(String data, int userID) {
    data += _paramsTabs + "[ID] ${userID}" + "\n";
    return data;
  }

  String writeUserName(String data, String username) {
    data += _paramsTabs + "[NAME] {${username}}" + "\n";
    return data;
  }

  String writeUserRGB(String data, List<int> rgb) {
    data += _paramsTabs + "[COLOR] (${rgb[0]},${rgb[1]},${rgb[2]})" + "\n";
    return data;
  }

  String writeMaxProductivity(String data, int maxProductivity) {
    data += _paramsTabs + "[MAX_PRODUCTIVITY] ${maxProductivity}" + "\n";
    return data;
  }

  String writeProductivity(String data, int productivity) {
    data += _paramsTabs + "[PRODUCTIVITY] ${productivity}" + "\n";
    return data;
  }
}
