import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/UserSelector.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/deadline_creator.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/productivity_switch.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/task_title_creator.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/task_type_selector.dart';
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
  String _currentTaskTitle;
  bool _readyToCreate;

  double _cornerRadius;
  double _width;
  double _subWidth;

  String _selectedUser;
  TaskType _selectedType;
  int _productivity;
  String _currentDeadline;

  @override
  void initState() {
    super.initState();

    this._currentTaskTitle = '';
    this._productivity = 1;
    this._selectedType = TaskType.Standard;
    this._selectedUser = _getAllUsersNames()[0];
    this._currentDeadline = '';
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
          _Headline(cornerRadius: this._cornerRadius),
          Flexible(flex: 1, child: Container()),
          TaskTitleCreator(
            subWidth: this._subWidth,
            updateTitle: (String taskTitle) {
              setState(() {
                this._currentTaskTitle = taskTitle;
                this._readyToCreate = _checkIfReadyToCreate();
              });
            },
            getCurrentTitle: () => this._currentTaskTitle,
          ),
          Flexible(
            flex: 3,
            child: UserSelector(
              initialUserName: _selectedUser,
              names: this._getAllUsersNames(),
              subWidth: this._subWidth,
              updateSelectedUserName: (String selectedUser) =>
                  this._selectedUser = selectedUser,
            ),
          ),
          Flexible(
            flex: 3,
            child: TaskTypeSelector(
              subWidth: this._subWidth,
              initialTaskType: TaskType.Standard,
              updateSelectedType: (TaskType type) {
                setState(() {
                  this._selectedType = type;
                });
              },
            ),
          ),
          Flexible(
            flex: 3,
            child: ProductivitySwitch(
              initialProductivity: this._productivity,
              updateProductivity: (int productivity) {
                setState(() {
                  this._productivity = productivity;
                });
              },
            ),
          ),
          Flexible(
            flex: 5,
            child: this._selectedType != null &&
                    this._selectedType == TaskType.FixedDate
                ? DeadlineCreator(
                    subWidth: this._subWidth,
                    updateDeadline: (String deadline) {
                      setState(
                        () {
                          this._currentDeadline = deadline;
                          this._readyToCreate = _checkIfReadyToCreate();
                        },
                      );
                    },
                    getCurrentDeadline: () => int.parse(this._currentDeadline),
                  )
                : Container(),
          ),
          Flexible(
            flex: 2,
            child: _Buttons(
              readyToCreate: this._readyToCreate,
              createTask: () => this._createTask(),
              getTaskTitle: () => this._currentTaskTitle,
            ),
          ),
          Flexible(flex: 1, child: Container()),
        ],
      ),
    );
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
      this._currentTaskTitle,
      this._productivity,
      _getUserWithNameOf(_selectedUser),
      this._selectedType,
    );

    if (task.getTaskType() == TaskType.FixedDate) {
      task.setDeadlineDay(int.parse(_currentDeadline));
    }

    print(task.getDeadlineDay());
    this.widget.taskCreated(task);
  }

  bool _checkIfReadyToCreate() {
    if (this._currentTaskTitle == '') {
      return false;
    } else if (this._selectedType != null &&
        this._selectedType == TaskType.FixedDate &&
        this._currentDeadline == '') {
      return false;
    } else {
      return true;
    }
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
          topLeft: Radius.circular(this.cornerRadius),
          topRight: Radius.circular(this.cornerRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).createNewTask,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Function getTaskTitle;
  final VoidCallback createTask;
  final bool readyToCreate;

  _Buttons({
    Key key,
    @required this.readyToCreate,
    @required this.getTaskTitle,
    @required this.createTask,
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
          flex: 2,
          fit: FlexFit.tight,
          child: IgnorePointer(
            ignoring: !readyToCreate,
            child: ElevatedButton(
              onPressed: () {
                this.createTask();
                Navigator.of(context).pop();
                SubtleMessage.messageWithContext(
                  context,
                  '${this.getTaskTitle()}: ${AppLocalizations.of(context).taskCreationSuccess}',
                );
              },
              child: Text(AppLocalizations.of(context).create),
              style: ElevatedButton.styleFrom(
                primary: readyToCreate ? Colors.green : Colors.transparent,
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
