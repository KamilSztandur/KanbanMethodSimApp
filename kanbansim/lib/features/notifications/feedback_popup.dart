import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackPopUp {
  static Widget show(BuildContext context, String title, String text) {
    return new AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text),
        ],
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                ),
                child: Text(AppLocalizations.of(context).close),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
