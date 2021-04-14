import 'package:flutter/material.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmTaskDeletionPopup {
  final Function deleteTask;

  ConfirmTaskDeletionPopup({@required this.deleteTask});

  Widget show(BuildContext context, Task task) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _ConfirmTaskDeletionWindow(
        deleteTask: this.deleteTask,
        task: task,
      ),
    );
  }
}

class _ConfirmTaskDeletionWindow extends StatelessWidget {
  final Function deleteTask;
  final Task task;

  _ConfirmTaskDeletionWindow({
    Key key,
    @required this.deleteTask,
    @required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _cornerRadius = 35;

    return Container(
      height: 250,
      width: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade900,
        borderRadius: BorderRadius.all(Radius.circular(_cornerRadius)),
      ),
      child: ListView(
        children: [
          _Headline(cornerRadius: _cornerRadius),
          Container(
            height: 180,
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: Column(
              children: [
                Flexible(flex: 2, child: Container()),
                Flexible(
                  flex: 3,
                  child: _TextLabel(title: this.task.getTitle()),
                ),
                Flexible(flex: 2, child: Container()),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: _Buttons(deleteTask: this.deleteTask),
                ),
                Flexible(flex: 2, child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextLabel extends StatelessWidget {
  final String title;

  _TextLabel({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text:
                "${AppLocalizations.of(context).areYouSureYouWantToDeleteTask} ",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: this.title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: '?',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,
              fontSize: 18,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Headline extends StatelessWidget {
  final double cornerRadius;

  _Headline({Key key, @required this.cornerRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(cornerRadius),
          topRight: Radius.circular(cornerRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).taskDeletionTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Function deleteTask;

  _Buttons({
    Key key,
    @required this.deleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 2, fit: FlexFit.tight, child: Container()),
        Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: ElevatedButton(
              onPressed: () {
                this.deleteTask();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text(
                AppLocalizations.of(context).delete,
                textAlign: TextAlign.center,
              ),
            )),
        Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
            ),
            child: Text(
              AppLocalizations.of(context).cancel,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(flex: 2, fit: FlexFit.tight, child: Container()),
      ],
    );
  }
}
