import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            label: AppLocalizations.of(context).close,
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
}
