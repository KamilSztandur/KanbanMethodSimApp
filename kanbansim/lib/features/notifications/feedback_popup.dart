import 'package:flutter/material.dart';

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
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).primaryColor
                : Theme.of(context).accentColor,
            child: Text('Close'),
          ),
        ),
      ],
    );
  }
}
