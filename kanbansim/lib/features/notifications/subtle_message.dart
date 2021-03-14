import 'package:flutter/material.dart';

class SubtleMessage {
  static void messageWithContext(BuildContext context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: _countDisplayTime(text)),
        backgroundColor: Theme.of(context).primaryColor,
        action: SnackBarAction(
            textColor: Colors.white,
            label: "Close",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }),
      ),
    );
  }

  static int _countDisplayTime(String message) {
    int charsAmount = message.length;
    double averageEnglishWordLength = 4.7;
    double averageReadingSpeedPerSecond = (450 * averageEnglishWordLength) / 60;

    double displayTimeInSeconds = charsAmount / averageReadingSpeedPerSecond;

    return displayTimeInSeconds.ceil();
  }

  static void message(final scaffoldKey, String text) {
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: _countDisplayTime(text)),
        action: SnackBarAction(
            textColor: Colors.white,
            label: "Close",
            onPressed: () {
              scaffoldKey.currentState.hideCurrentSnackBar();
            }),
      ),
    );
  }
}
