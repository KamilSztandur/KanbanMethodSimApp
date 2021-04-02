import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';

class LockStatusPopup {
  final Function taskUnlocked;
  final Function getUsers;

  LockStatusPopup({
    @required this.taskUnlocked,
    @required this.getUsers,
  });

  Widget show(BuildContext context, Task task) {
    return new Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: _LockStatus(
        task: task,
        taskUnlocked: this.taskUnlocked,
        getUsers: this.getUsers,
      ),
    );
  }
}

class _LockStatus extends StatefulWidget {
  final Function taskUnlocked;
  final Function getUsers;
  final Task task;

  _LockStatus({
    Key key,
    @required this.taskUnlocked,
    @required this.task,
    @required this.getUsers,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LockStatusState();
}

class _LockStatusState extends State<_LockStatus> {
  String _selectedValue;
  int _neededProductivity;
  bool _readyToUnlock;
  double _cornerRadius = 35;
  double _height = 400;
  double _width = 350;

  void _unlockTask() {
    User selectedUser = _getUserWithNameOf(_selectedValue);
    this.widget.task.unlockWith(selectedUser);
    this._neededProductivity = 0;
    this.widget.taskUnlocked();
  }

  void _exitPopup() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  List<String> _getAvailableUsersNames() {
    List<User> users = this.widget.getUsers();
    List<String> usersNames = <String>[];

    int minProductivity = widget.task.getProductivityRequiredToUnlock();

    int length = users.length;
    for (int i = 0; i < length; i++) {
      if (users[i].getID() != widget.task.owner.getID()) {
        if (users[i].getProductivity() >= minProductivity) {
          usersNames.add(users[i].getName());
        }
      }
    }

    return usersNames;
  }

  User _getUserWithNameOf(String name) {
    List<User> users = this.widget.getUsers();

    int length = users.length;
    for (int i = 0; i < length; i++) {
      if (users[i].getName() == name) {
        return users[i];
      }
    }

    return null;
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_cornerRadius),
          topRight: Radius.circular(_cornerRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Assign user to unlock this task",
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

  Widget _buildRequirementsInfo() {
    _neededProductivity = widget.task.getProductivityRequiredToUnlock();
    Color color = Colors.red;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$_neededProductivity",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Icon(
              Icons.settings_outlined,
              color: color,
              size: 25,
            ),
          ],
        ),
        Text(
          " productivity required",
          style: TextStyle(
            color: color,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildDropDownList() {
    List<String> names = _getAvailableUsersNames();
    if (names.length != 0) {
      _selectedValue = names[0];
      this._readyToUnlock = true;
    } else {
      names.add('Empty');
      _selectedValue = 'Empty';
      this._readyToUnlock = false;
    }

    return DropdownButton<String>(
      value: names[0],
      icon: const Icon(Icons.account_circle_outlined),
      iconSize: 24,
      isExpanded: true,
      underline: Container(
        height: 5,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (String newValue) {
        setState(() {
          _selectedValue = newValue;
        });
      },
      items: names.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildRequirementHint() {
    return Text(
      "If certain user isn't on the list it means either they are owner of this task or do not have enough productivity.",
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.grey,
        fontSize: 15,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: IgnorePointer(
            ignoring: !_readyToUnlock,
            child: ElevatedButton(
              onPressed: () {
                _unlockTask();
                _exitPopup();
                SubtleMessage.messageWithContext(
                  context,
                  'Task #${widget.task.getID()} unlocked successfully!',
                );
              },
              child: Text("Unlock"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  this._readyToUnlock
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade900,
        borderRadius: BorderRadius.all(Radius.circular(_cornerRadius)),
      ),
      child: Column(
        children: [
          _buildTitle(),
          Container(
            height: _height * 0.85,
            width: _width * 0.8,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Flexible(
                  flex: 2,
                  child: _buildRequirementsInfo(),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _buildDropDownList(),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: _buildRequirementHint(),
                ),
                Flexible(
                  flex: 2,
                  child: _buildButtons(),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
