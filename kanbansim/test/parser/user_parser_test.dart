import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanbansim/common/savefile_parsers/user_parser.dart';
import 'package:kanbansim/models/User.dart';

void main() {
  group(
    'UserParser',
    () {
      UserParser userParser;

      setUp(() => userParser = UserParser());
      tearDown(() => userParser = null);

      test(
        'returns User correctly converted to String',
        () {
          User testUser = _getTestUser();
          String parsedUser = userParser.parseUserToString(testUser);

          String expectedValue = "\t[BEGIN_USER]\n" +
              "\t\t[ID] 0\n" +
              "\t\t[NAME] {Kamil}\n" +
              "\t\t[COLOR] (55,66,77)\n" +
              "\t\t[MAX_PRODUCTIVITY] 5\n" +
              "\t\t[PRODUCTIVITY] 3\n" +
              "\t[END_USER]\n";

          expect(parsedUser, expectedValue);
        },
      );

      test(
        'correctly reconstructs User from String',
        () {
          String testUser = "\t[BEGIN_USER]\n" +
              "\t\t[ID] 0\n" +
              "\t\t[NAME] {Kamil}\n" +
              "\t\t[COLOR] (55,66,77)\n" +
              "\t\t[MAX_PRODUCTIVITY] 5\n" +
              "\t\t[PRODUCTIVITY] 3\n" +
              "\t[END_USER]\n";

          User user = userParser.parseStringToUser(testUser);

          expect(user.getID(), 0);
          expect(user.getName(), "Kamil");
          expect(user.getColor(), Color.fromRGBO(55, 66, 77, 1.0));
          expect(user.getMaxProductivity(), 5);
          expect(user.getProductivity(), 3);
        },
      );

      test(
        'should throw FormatException when invalid ID\'s value in given User data (not integer)',
        () {
          String testUser = "\t[BEGIN_USER]\n" +
              "\t\t[ID] 0.5\n" +
              "\t\t[NAME] {Kamil}\n" +
              "\t\t[COLOR] (55,66,77)\n" +
              "\t\t[MAX_PRODUCTIVITY] 5\n" +
              "\t\t[PRODUCTIVITY] 3\n" +
              "\t[END_USER]\n";

          expect(
            () => userParser.parseStringToUser(testUser),
            throwsA(predicate((e) => e is FormatException)),
          );
        },
      );

      test(
        'should throw ArgumentError when invalid ID\'s value in given User data (negative integer)',
        () {
          String testUser = "\t[BEGIN_USER]\n" +
              "\t\t[ID] -1\n" +
              "\t\t[NAME] {Kamil}\n" +
              "\t\t[COLOR] (55,66,77)\n" +
              "\t\t[MAX_PRODUCTIVITY] 5\n" +
              "\t\t[PRODUCTIVITY] 3\n" +
              "\t[END_USER]\n";

          expect(
            () => userParser.parseStringToUser(testUser),
            throwsA(predicate(
              (e) =>
                  e is ArgumentError &&
                  e.message == "ID must not be negative value.",
            )),
          );
        },
      );

      test(
        'should throw FormatException when invalid maxProductivity\'s value in given User data (not integer)',
        () {
          String testUser = "\t[BEGIN_USER]\n" +
              "\t\t[ID] 0\n" +
              "\t\t[NAME] {Kamil}\n" +
              "\t\t[COLOR] (55,66,77)\n" +
              "\t\t[MAX_PRODUCTIVITY] 5.5\n" +
              "\t\t[PRODUCTIVITY] 3\n" +
              "\t[END_USER]\n";

          expect(
            () => userParser.parseStringToUser(testUser),
            throwsA(predicate((e) => e is FormatException)),
          );
        },
      );

      test(
        'should throw ArgumentError when invalid maxProductivity\'s value in given User data (negative integer)',
        () {
          String testUser = "\t[BEGIN_USER]\n" +
              "\t\t[ID] 0\n" +
              "\t\t[NAME] {Kamil}\n" +
              "\t\t[COLOR] (55,66,77)\n" +
              "\t\t[MAX_PRODUCTIVITY] -2\n" +
              "\t\t[PRODUCTIVITY] 3\n" +
              "\t[END_USER]\n";

          expect(
            () => userParser.parseStringToUser(testUser),
            throwsA(predicate(
              (e) =>
                  e is ArgumentError &&
                  e.message == "maxProductivity must not be negative value.",
            )),
          );
        },
      );

      test(
        'should throw FormatException when invalid productivity\'s value in given User data (not integer)',
        () {
          String testUser = "\t[BEGIN_USER]\n" +
              "\t\t[ID] 0\n" +
              "\t\t[NAME] {Kamil}\n" +
              "\t\t[COLOR] (55,66,77)\n" +
              "\t\t[MAX_PRODUCTIVITY] 5\n" +
              "\t\t[PRODUCTIVITY] 3.5\n" +
              "\t[END_USER]\n";

          expect(
            () => userParser.parseStringToUser(testUser),
            throwsA(predicate((e) => e is FormatException)),
          );
        },
      );

      test(
        'should throw ArgumentError when invalid productivity\'s value in given User data (negative integer)',
        () {
          String testUser = "\t[BEGIN_USER]\n" +
              "\t\t[ID] 0\n" +
              "\t\t[NAME] {Kamil}\n" +
              "\t\t[COLOR] (55,66,77)\n" +
              "\t\t[MAX_PRODUCTIVITY] 5\n" +
              "\t\t[PRODUCTIVITY] -3\n" +
              "\t[END_USER]\n";

          expect(
            () => userParser.parseStringToUser(testUser),
            throwsA(predicate(
              (e) =>
                  e is ArgumentError &&
                  e.message == "productivity must not be negative value.",
            )),
          );
        },
      );
    },
  );
}

User _getTestUser() {
  User testUser = User("Kamil", 5, Color.fromRGBO(55, 66, 77, 1.0));
  testUser.decreaseProductivity(2);

  return testUser;
}
