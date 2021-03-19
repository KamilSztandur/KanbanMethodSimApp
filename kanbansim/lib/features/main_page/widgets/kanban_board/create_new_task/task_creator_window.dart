import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanbansim/features/main_page/widgets/menu_bar.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';
import 'package:kanbansim/models/User.dart';

class TaskCreatorPopup {
  final Function(Task) taskCreated;
  final Function getUsers;

  TaskCreatorPopup({
    @required this.getUsers,
    @required this.taskCreated,
  });

  Widget show(BuildContext context) {
    return new Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: _TaskCreatorPage(
        taskCreated: this.taskCreated,
        getUsers: this.getUsers,
      ),
    );
  }
}

class _TaskCreatorPage extends StatefulWidget {
  final Function(Task) taskCreated;
  final Function getUsers;

  _TaskCreatorPage({
    @required this.getUsers,
    @required this.taskCreated,
  });

  @override
  State<StatefulWidget> createState() => _TaskCreatorPageState();
}

class _TaskCreatorPageState extends State<_TaskCreatorPage> {
  TextEditingController _controllerTitle;
  TextEditingController _controllerDate;
  bool _readyToCreate;

  double _cornerRadius;
  double _width;
  double _subWidth;
  Color _rightArrowColor;
  Color _leftArrowColor;

  String _selectedUser;
  String _selectedType;
  int _productivity;

  @override
  void initState() {
    super.initState();
    _controllerTitle = TextEditingController();
    _controllerDate = TextEditingController();
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerDate.dispose();
    super.dispose();
  }

  List<String> _getAllUsersNames() {
    List<User> users = this.widget.getUsers();
    List<String> usersNames = <String>[];

    int length = users.length;
    for (int i = 0; i < length; i++) {
      usersNames.add(users[i].getName());
    }

    return usersNames;
  }

  List<String> _getAllTaskTypesNames() {
    List<String> types = <String>[];

    TaskType.values.forEach(
      (taskType) => types.add(
        _getTaskTypeName(taskType),
      ),
    );

    return types;
  }

  String _getTaskTypeName(TaskType type) {
    return type.toString().split('.').last;
  }

  Widget _buildHeadline() {
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
            "Create new task",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTitleCreator() {
    return Container(
      width: this._subWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubTitle("Set title:"),
          TextField(
            maxLength: 20,
            controller: _controllerTitle,
            textAlign: TextAlign.left,
            maxLines: 1,
            onSubmitted: (String value) {
              setState(() {
                this._readyToCreate = _checkIfReadyToCreate();
              });
            },
            decoration: new InputDecoration(
              hintText: "Enter your task title here",
              labelStyle: new TextStyle(color: const Color(0xFF424242)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
              border: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDeadlineCreator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: 'Set task deadline day\'s number:\n',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: 'Available only for Fixed Date tasks!',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        Container(
          width: this._subWidth,
          child: TextField(
            maxLength: 2,
            controller: _controllerDate,
            textAlign: TextAlign.left,
            onSubmitted: (String value) {
              setState(() {
                this._readyToCreate = _checkIfReadyToCreate();
              });
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              hintText: "Enter deadline day number",
              labelStyle: new TextStyle(color: const Color(0xFF424242)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserSelection() {
    List<String> names = _getAllUsersNames();
    if (this._selectedUser == null) {
      _selectedUser = names[0];
    }

    return Container(
      width: this._subWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubTitle("Asign task to:"),
          DropdownButton<String>(
            value: _selectedUser,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 35,
            iconEnabledColor: Theme.of(context).primaryColor,
            isExpanded: true,
            underline: Container(
              height: 2,
              color: Theme.of(context).primaryColor,
            ),
            onChanged: (String newValue) {
              setState(() {
                _selectedUser = newValue;
              });
            },
            items: names.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTypeSelection() {
    List<String> types = _getAllTaskTypesNames();
    if (this._selectedType == null) {
      _selectedType = types[0];
    }

    return Container(
      width: this._subWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubTitle("Set task type as:"),
          DropdownButton<String>(
            value: _selectedType,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 35,
            iconEnabledColor: Theme.of(context).primaryColor,
            isExpanded: true,
            underline: Container(
              height: 2,
              color: Theme.of(context).primaryColor,
            ),
            onChanged: (String newValue) {
              setState(() {
                _selectedType = newValue;
              });
            },
            items: types.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
    );
  }

  void _increaseProductivityRequired() {
    if (this._productivity + 1 <= 5) {
      this._productivity++;
    }
  }

  void _decreaseProductivityRequired() {
    if (this._productivity - 1 >= 1) {
      this._productivity--;
    }
  }

  void _setArrowColors() {
    if (this._productivity == null) {
      this._productivity = 1;
    }

    if (this._productivity == 1) {
      this._leftArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._leftArrowColor = Theme.of(context).primaryColor;
    }

    if (this._productivity == 5) {
      this._rightArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._rightArrowColor = Theme.of(context).primaryColor;
    }
  }

  Widget _buildProductivitySwitch() {
    _setArrowColors();

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSubTitle("Set productivity to required:"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left_outlined),
                color: this._leftArrowColor,
                iconSize: 50,
                onPressed: () {
                  setState(() {
                    _decreaseProductivityRequired();
                  });
                },
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '$_productivity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right_outlined),
                color: this._rightArrowColor,
                splashRadius: 15,
                splashColor: Theme.of(context).primaryColor,
                iconSize: 50,
                onPressed: () {
                  setState(() {
                    _increaseProductivityRequired();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
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

  void _createTask() {
    Task task = Task(
      this._controllerTitle.text,
      this._productivity,
      _getUserWithNameOf(_selectedUser),
      TaskType.values.firstWhere(
        (type) => type.toString().split('.').last == _selectedType,
      ),
    );

    if (task.getTaskType() == TaskType.FixedDate) {
      task.setDeadlineDay(int.parse(_controllerDate.text));
    }

    this.widget.taskCreated(task);
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Container(),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: IgnorePointer(
            ignoring: !_readyToCreate,
            child: ElevatedButton(
              onPressed: () {
                _createTask();
                Navigator.of(context).pop();
                SubtleMessage.messageWithContext(
                  context,
                  'Task "${_controllerTitle.text}" created successfully!',
                );
              },
              child: Text("Create"),
              style: ElevatedButton.styleFrom(
                primary: _readyToCreate ? Colors.green : Colors.transparent,
                onPrimary: Colors.white,
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
          flex: 3,
          child: Container(),
        ),
      ],
    );
  }

  bool _checkIfReadyToCreate() {
    if (this._controllerTitle.text == '') {
      return false;
    } else if (this._selectedType == "FixedDate" &&
        this._controllerDate.text == '') {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    this._readyToCreate = _checkIfReadyToCreate();
    this._cornerRadius = 35;
    this._width = 440;
    this._subWidth = this._width * 0.7;

    return Container(
      width: this._width,
      height: 800,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(_cornerRadius * 1.1),
        ),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 2,
            child: _buildHeadline(),
          ),
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 3,
            child: _buildTaskTitleCreator(),
          ),
          Flexible(
            flex: 3,
            child: _buildUserSelection(),
          ),
          Flexible(
            flex: 3,
            child: _buildTaskTypeSelection(),
          ),
          Flexible(
            flex: 3,
            child: _buildProductivitySwitch(),
          ),
          Flexible(
            flex: 5,
            child: this._selectedType == "FixedDate"
                ? _buildTaskDeadlineCreator()
                : Container(),
          ),
          Flexible(
            flex: 2,
            child: _buildButtons(),
          ),
          Flexible(flex: 1, child: Container()),
        ],
      ),
    );
  }
}
