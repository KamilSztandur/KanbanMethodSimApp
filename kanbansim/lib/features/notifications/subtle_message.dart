import 'package:flutter/material.dart';

class SubtleMessage {
  static void messageWithContext(BuildContext context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Theme.of(context).primaryColor,
        action: SnackBarAction(
            textColor: Theme.of(context).accentColor,
            label: "Close",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }),
      ),
    );
  }

  static void message(final scaffoldKey, String text) {
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: 1),
        action: SnackBarAction(
            label: "Close",
            onPressed: () {
              scaffoldKey.currentState.hideCurrentSnackBar();
            }),
      ),
    );
  }
}
