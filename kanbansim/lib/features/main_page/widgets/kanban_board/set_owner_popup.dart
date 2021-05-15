import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/UserSelector.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';

class SetOwnerPopup {
  final VoidCallback ownerSet;
  final Function getAllUsers;
  final Function(String, int) moveTask;
  final String columnName;
  final Task task;

  SetOwnerPopup({
    @required this.ownerSet,
    @required this.getAllUsers,
    @required this.moveTask,
    @required this.columnName,
    @required this.task,
  });

  Widget show() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _SetOwnerWindow(
        ownerSet: this.ownerSet,
        moveTask: this.moveTask,
        getAllUsers: this.getAllUsers,
        columnName: this.columnName,
        task: this.task,
      ),
    );
  }
}

class _SetOwnerWindow extends StatefulWidget {
  final VoidCallback ownerSet;
  final Function(String, int) moveTask;
  final Function getAllUsers;
  final String columnName;
  final Task task;

  _SetOwnerWindow({
    @required this.ownerSet,
    @required this.moveTask,
    @required this.getAllUsers,
    @required this.columnName,
    @required this.task,
  });

  @override
  _SetOwnerWindowState createState() => _SetOwnerWindowState();
}

class _SetOwnerWindowState extends State<_SetOwnerWindow> {
  String _selectedValue;
  double _cornerRadius;
  double _height;
  double _width;
  double _subWidth;

  @override
  Widget build(BuildContext context) {
    _initializeParameters();

    return Container(
      width: this._width,
      height: _height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(_cornerRadius * 1.1),
        ),
      ),
      child: Column(
        children: [
          _Headline(cornerRadius: this._cornerRadius),
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 3,
            child: UserSelector(
              initialUserName: _selectedValue,
              names: this._getAvailableUsersNames(),
              subWidth: this._subWidth,
              updateSelectedUserName: (String selectedUser) =>
                  this._selectedValue = selectedUser,
              ownerName: null,
            ),
          ),
          Flexible(
            flex: 2,
            child: _Buttons(
              getOwnerName: () => this._selectedValue,
              ownerSet: () {
                this.widget.task.owner = _getUserWithNameOf(_selectedValue);
                this.widget.ownerSet();

                this.widget.moveTask(
                      this.widget.columnName,
                      this.widget.task.getID(),
                    );
              },
              taskName: this.widget.task.getTitle(),
            ),
          ),
          Flexible(flex: 1, child: Container()),
        ],
      ),
    );
  }

  void _initializeParameters() {
    this._cornerRadius = 35;
    this._width = 390;
    this._height = 250;
    this._subWidth = this._width * 0.7;

    if (_selectedValue == null) {
      _selectedValue = this._getAvailableUsersNames()[0];
    }
  }

  List<String> _getAvailableUsersNames() {
    List<User> users = this.widget.getAllUsers();
    List<String> usersNames = <String>[];

    int length = users.length;
    for (int i = 0; i < length; i++) {
      usersNames.add(users[i].getName());
    }

    return usersNames;
  }

  User _getUserWithNameOf(String name) {
    List<User> users = this.widget.getAllUsers();

    int length = users.length;
    for (int i = 0; i < length; i++) {
      if (users[i].getName() == name) {
        return users[i];
      }
    }

    return null;
  }
}

class _Headline extends StatelessWidget {
  final double cornerRadius;

  _Headline({Key key, @required this.cornerRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(this.cornerRadius),
          topRight: Radius.circular(this.cornerRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).selectTasksOwner,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final VoidCallback ownerSet;
  final Function getOwnerName;
  final String taskName;

  _Buttons({
    Key key,
    @required this.getOwnerName,
    @required this.ownerSet,
    @required this.taskName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Container(),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              this.ownerSet();

              String userName = this.getOwnerName();

              Navigator.of(context).pop();
              SubtleMessage.messageWithContext(
                context,
                '$userName ${AppLocalizations.of(context).successfullySetAsOwnerOf} ${this.taskName}.',
              );
            },
            child: Text(AppLocalizations.of(context).selectOwner),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(),
        ),
      ],
    );
  }
}
