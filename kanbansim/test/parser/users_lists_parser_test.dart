import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanbansim/common/savefile_parsers/users_list_parser.dart';
import 'package:kanbansim/models/User.dart';

void main() {
  group(
    'UsersListsParser',
    () {
      UsersListsParser _parser;
      List<User> _users;

      setUpAll(() {
        _users = _getSampleUserList();
        _parser = UsersListsParser();
      });

      tearDownAll(() {
        _parser = null;
        _users = null;
      });

      test(
        'returns Users list correctly converted to String',
        () {
          String parsedList = _parser.parseUsersListToString(_users);

          expect(parsedList, _getSampleParsedUserList());
        },
      );

      test(
        'returns Users list correctly reconstructed from String',
        () {
          String parsedList = _getSampleParsedUserList();
          List<User> loadedUsers = _parser.parseStringToUsersList(parsedList);

          expect(loadedUsers.length, _users.length);

          int n = loadedUsers.length;
          for (int i = 0; i < n; i++) {
            expect(loadedUsers[i].getID(), _users[i].getID());
            expect(loadedUsers[i].getName(), _users[i].getName());
            expect(loadedUsers[i].getColor(), _users[i].getColor());

            expect(
              loadedUsers[i].getMaxProductivity(),
              _users[i].getMaxProductivity(),
            );

            expect(
              loadedUsers[i].getProductivity(),
              _users[i].getProductivity(),
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

String _getSampleParsedUserList() {
  return "" +
      "[BEGIN_USERS_LIST]\n" +
      "\t[BEGIN_USER]\n" +
      "\t\t[ID] 0\n" +
      "\t\t[NAME] {Kamil}\n" +
      "\t\t[COLOR] (55,66,77)\n" +
      "\t\t[MAX_PRODUCTIVITY] 5\n" +
      "\t\t[PRODUCTIVITY] 3\n" +
      "\t[END_USER]\n" +
      "\t[BEGIN_USER]\n" +
      "\t\t[ID] 1\n" +
      "\t\t[NAME] {Bartek}\n" +
      "\t\t[COLOR] (11,22,33)\n" +
      "\t\t[MAX_PRODUCTIVITY] 5\n" +
      "\t\t[PRODUCTIVITY] 4\n" +
      "\t[END_USER]\n" +
      "[END_USERS_LIST]\n";
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
