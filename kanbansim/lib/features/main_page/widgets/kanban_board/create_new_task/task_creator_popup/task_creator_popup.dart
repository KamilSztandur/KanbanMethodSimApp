import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/deadline_creator.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/task_title_creator.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/task_type_selector.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/models/task.dart';
import 'package:kanbansim/models/task_type.dart';

class TaskCreatorPopup {
  final Function getMaxSimDay;
  final Function getCurrentDay;
  final Function(Task) taskCreated;
  final Function getUsers;

  TaskCreatorPopup({
    @required this.getMaxSimDay,
    @required this.getCurrentDay,
    @required this.getUsers,
    @required this.taskCreated,
  });

  Widget show(BuildContext context) {
    return new Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: _TaskCreatorPage(
        getCurrentDay: this.getCurrentDay,
        getMaxSimDay: this.getMaxSimDay,
        taskCreated: this.taskCreated,
        getUsers: this.getUsers,
      ),
    );
  }
}

class _TaskCreatorPage extends StatefulWidget {
  final Function getMaxSimDay;
  final Function getCurrentDay;
  final Function(Task) taskCreated;
  final Function getUsers;

  _TaskCreatorPage({
    @required this.getMaxSimDay,
    @required this.getCurrentDay,
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

  TaskType _selectedType;
  int _currentDeadline;

  @override
  void initState() {
    super.initState();

    this._currentTaskTitle = '';
    this._selectedType = TaskType.Standard;
    this._currentDeadline = this.widget.getMaxSimDay();
    this._readyToCreate = _checkIfReadyToCreate();
    this._cornerRadius = 35;
    this._width = 440;
    this._subWidth = this._width * 0.7;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this._width,
      height: 600,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(_cornerRadius * 1.1),
        ),
      ),
      child: Column(
        children: [
          _Headline(cornerRadius: this._cornerRadius),
          Flexible(flex: 8, child: Container()),
          Flexible(
            flex: 24,
            child: TaskTitleCreator(
              subWidth: this._subWidth,
              updateTitle: (String taskTitle) {
                setState(() {
                  this._currentTaskTitle = taskTitle;
                  this._readyToCreate = _checkIfReadyToCreate();
                });
              },
              getCurrentTitle: () => this._currentTaskTitle,
            ),
          ),
          Flexible(flex: 6, child: Container()),
          Flexible(
            flex: 14,
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
          Flexible(flex: 6, child: Container()),
          Flexible(
            flex: 24,
            child: this._selectedType != null &&
                    this._selectedType == TaskType.FixedDate
                ? DeadlineDaySwitch(
                    initialDeadlineDay: this._currentDeadline,
                    minSimDay: this.widget.getCurrentDay(),
                    maxSimDay: this.widget.getMaxSimDay(),
                    updateDeadlineDay: (int deadline) {
                      setState(
                        () {
                          this._currentDeadline = deadline;
                          this._readyToCreate = _checkIfReadyToCreate();
                        },
                      );
                    },
                  )
                : Container(),
          ),
          Flexible(flex: 9, child: Container()),
          Flexible(
            flex: 7,
            child: _Buttons(
              readyToCreate: this._readyToCreate,
              createTask: () => this._createTask(),
              getTaskTitle: () => this._currentTaskTitle,
            ),
          ),
          Flexible(flex: 8, child: Container()),
        ],
      ),
    );
  }

  void _createTask() {
    Task task = Task(
      this._currentTaskTitle,
      5,
      null,
      this._selectedType,
    );

    if (task.getTaskType() == TaskType.FixedDate) {
      task.setDeadlineDay(_currentDeadline);
    }

    this.widget.taskCreated(task);
  }

  bool _checkIfReadyToCreate() {
    if (this._currentTaskTitle == '') {
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
