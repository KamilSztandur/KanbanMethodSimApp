import 'package:kanbansim/common/savefile_parsers/user_parser.dart';
import 'package:kanbansim/models/user.dart';

class UsersListsParser {
  _UsersListsWriter _writer;
  UserParser _parser;

  UsersListsParser() {
    this._writer = _UsersListsWriter();
    this._parser = UserParser();
  }

  String parseUsersListToString(List<User> users) {
    int n = users.length;
    String data = "";

    data = _writer.writeHeadline(data);
    for (int i = 0; i < n; i++) {
      data = _writer.writeUser(data, users[i]);
    }
    data = _writer.writeEndingHeadline(data);

    return data;
  }

  List<User> parseStringToUsersList(String data) {
    final userListStartSentence = "[BEGIN_USERS_LIST]";
    final userListEndSentence = "[END_USERS_LIST]";
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

    final startSentence = "[BEGIN_USER]";
    final endSentence = "[END_USER]";
    int startLength = startSentence.length;
    int endLength = endSentence.length;
    List<User> users = <User>[];

    while (true) {
      int dataLength = currentData.length;
      int startIndex = currentData.indexOf(startSentence);
      int endIndex = currentData.indexOf(endSentence, startIndex + startLength);

      if (startIndex == -1 || endIndex == -1) {
        break;
      }

      String currentUserData = currentData.substring(
        startIndex,
        endIndex + endLength,
      );
      users.add(_parser.parseStringToUser(currentUserData));

      currentData = currentData.substring(endIndex + endLength, dataLength);
    }

    return users;
  }
}

class _UsersListsWriter {
  UserParser _userParser;
  String _headlineTabs = "";

  _UsersListsWriter() {
    this._userParser = UserParser();
  }

  String writeHeadline(String data) {
    data += _headlineTabs + "[BEGIN_USERS_LIST]" + "\n";
    return data;
  }

  String writeEndingHeadline(String data) {
    data += _headlineTabs + "[END_USERS_LIST]" + "\n";
    return data;
  }

  String writeUser(String data, User user) {
    String userData = _userParser.parseUserToString(user);
    data += userData;
    return data;
  }
}
