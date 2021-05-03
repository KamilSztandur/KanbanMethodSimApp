import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksLimitReachedPopup {
  Widget show(String columnName, int limit) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _TasksLimitWarningWindow(
        columnName: columnName,
        limit: limit,
      ),
    );
  }
}

class _TasksLimitWarningWindow extends StatelessWidget {
  final String columnName;
  final int limit;

  _TasksLimitWarningWindow({
    Key key,
    @required this.columnName,
    @required this.limit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 187,
      width: 210,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade800,
      ),
      child: ListView(
        children: [
          Row(
            children: [
              SizedBox(width: 237),
              _CloseButton(),
            ],
          ),
          _TextLabel(columnName: columnName, limit: limit),
          SizedBox(height: 27),
        ],
      ),
    );
  }
}

class _TextLabel extends StatelessWidget {
  final String columnName;
  final int limit;

  _TextLabel({
    Key key,
    @required this.columnName,
    @required this.limit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Couldn\' add new task to\n\n',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: "${this.columnName}",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ".\n\n",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: "Tasks limit reached ($limit/$limit).\n",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,
              fontSize: 14,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      iconSize: 25,
      color: Theme.of(context).textTheme.bodyText1.color,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
