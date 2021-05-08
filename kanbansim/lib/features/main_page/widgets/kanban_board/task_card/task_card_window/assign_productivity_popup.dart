import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/UserSelector.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/models/User.dart';

class AssignProductivityPopup {
  final Function(Task, User, int) productivityAssigned;
  final Function getUsers;

  AssignProductivityPopup({
    @required this.getUsers,
    @required this.productivityAssigned,
  });

  Widget show(BuildContext context, Task task) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _AssignProductivityWindow(
        productivityAssigned: this.productivityAssigned,
        getUsers: this.getUsers,
        task: task,
      ),
    );
  }
}

class _AssignProductivityWindow extends StatefulWidget {
  final Function(Task, User, int) productivityAssigned;
  final Function getUsers;
  final Task task;
  final double _cornerRadius = 35;
  final double _height = 575;
  final double _width = 450;

  _AssignProductivityWindow({
    Key key,
    @required this.getUsers,
    @required this.productivityAssigned,
    @required this.task,
  }) : super(key: key);

  @override
  _AssignProductivityWindowState createState() =>
      _AssignProductivityWindowState();
}

class _AssignProductivityWindowState extends State<_AssignProductivityWindow> {
  bool _isReadyToAssign;
  String _assignedUsername;
  int _assignedProductivity;
  double _max;

  @override
  Widget build(BuildContext context) {
    if (_assignedUsername == null) {
      _assignInitialValues();
    }

    return Container(
      height: widget._height,
      width: widget._width,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade900,
        borderRadius: BorderRadius.all(Radius.circular(widget._cornerRadius)),
      ),
      child: ListView(
        children: [
          _Headline(cornerRadius: widget._cornerRadius),
          Container(
            height: widget._height - 60,
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: Column(
              children: [
                Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: UserSelector(
                    initialUserName: _assignedUsername,
                    names: _getAvailableUsersNames(),
                    subWidth: widget._width * 0.7,
                    updateSelectedUserName: (String name) {
                      setState(() {
                        this._assignedUsername = name;
                        this._max = _getMaxProductivityValuePossibleToAssign()
                            .toDouble();
                      });
                      _checkIfReadyToAssign();
                    },
                    ownerName: this.widget.task.owner.getName(),
                  ),
                ),
                Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: _ProductivityAvailabilityInfoLabel(
                    taskProdRequired:
                        widget.task.progress.getNumberOfUnfulfilledParts(),
                    userProdAvailable:
                        _getUserWithNameOf(_assignedUsername).getProductivity(),
                    maxProdPossible: _getMaxProductivityValuePossibleToAssign(),
                    isOwner: _getUserWithNameOf(_assignedUsername).getID() ==
                        widget.task.owner.getID(),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _ProductivitySelection(
                    max: _getMaxProductivityValuePossibleToAssign().toDouble(),
                    productivityChanged: (int value) {
                      this._assignedProductivity = value;
                      _checkIfReadyToAssign();
                    },
                  ),
                ),
                Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _Buttons(
                    isReadyToAssign: this._isReadyToAssign,
                    assignProductivity: () {
                      this.widget.productivityAssigned(
                            this.widget.task,
                            _getUserWithNameOf(this._assignedUsername),
                            _assignedProductivity,
                          );
                    },
                  ),
                ),
                Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _assignInitialValues() {
    this._isReadyToAssign = false;
    this._assignedProductivity = 0;
    this._assignedUsername = _getAvailableUsersNames()[0];
    this._max = _getMaxProductivityValuePossibleToAssign().toDouble();
  }

  void _checkIfReadyToAssign() {
    setState(() {
      if (this._assignedProductivity != 0 && this._assignedUsername != null) {
        this._isReadyToAssign = true;
      } else {
        this._isReadyToAssign = false;
      }
    });
  }

  int _getMaxProductivityValuePossibleToAssign() {
    User assignedUser = _getUserWithNameOf(_assignedUsername);
    int userProd = assignedUser.getProductivity();
    int taskProdReq = widget.task.progress.getNumberOfUnfulfilledParts();

    if (widget.task.owner.getID() != assignedUser.getID()) {
      userProd = (userProd / 2).floor();
    }

    return userProd > taskProdReq ? taskProdReq : userProd;
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

  List<String> _getAvailableUsersNames() {
    List<User> users = this.widget.getUsers();
    List<String> usersNames = <String>[];

    int length = users.length;
    for (int i = 0; i < length; i++) {
      usersNames.add(users[i].getName());
    }

    return usersNames;
  }
}

class _ProductivityAvailabilityInfoLabel extends StatelessWidget {
  final int taskProdRequired;
  final int userProdAvailable;
  final int maxProdPossible;
  final bool isOwner;

  _ProductivityAvailabilityInfoLabel({
    Key key,
    @required this.taskProdRequired,
    @required this.userProdAvailable,
    @required this.maxProdPossible,
    @required this.isOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (maxProdPossible == 0) {
      return Center(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: AppLocalizations.of(context)
                    .cannotAssignProductivityFromThisUser,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text:
                  "${AppLocalizations.of(context).productivityAvailableFromThisUser}: ",
              style: TextStyle(
                color: Theme.of(context).textTheme.headline6.color,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: "$userProdAvailable\n",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            TextSpan(text: "\n"),
            TextSpan(
              text:
                  "${AppLocalizations.of(context).productivitiyNeededToFinishThisTask}: ",
              style: TextStyle(
                color: Theme.of(context).textTheme.headline6.color,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: "$taskProdRequired\n",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            TextSpan(text: "\n"),
            TextSpan(
              text:
                  "${AppLocalizations.of(context).maxProductivityAvailableToAsign}: ",
              style: TextStyle(
                color: Theme.of(context).textTheme.headline6.color,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text:
                  "${maxProdPossible} (${AppLocalizations.of(context).productivityCost} = ${maxProdPossible * (isOwner ? 1 : 2)})\n",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            TextSpan(text: "\n"),
            TextSpan(
              text: this.isOwner
                  ? ""
                  : AppLocalizations.of(context).productivityDoubleCostInfo,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _ProductivitySelection extends StatefulWidget {
  final Function(int) productivityChanged;
  final double max;

  _ProductivitySelection({
    Key key,
    @required this.productivityChanged,
    @required this.max,
  }) : super(key: key);

  @override
  _ProductivitySelectionState createState() => _ProductivitySelectionState();
}

class _ProductivitySelectionState extends State<_ProductivitySelection> {
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    if (this.widget.max == 0.0) {
      return Container();
    } else {
      return SfSlider(
        min: 0.0,
        max: 5.0,
        value: _value,
        stepSize: 1,
        interval: 1,
        showTicks: true,
        showLabels: true,
        onChanged: (dynamic value) {
          setState(() {
            if (value > this.widget.max) {
              this._value = this.widget.max;
            } else {
              _value = value;
            }
          });

          widget.productivityChanged(_value.toInt());
        },
      );
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
          topLeft: Radius.circular(cornerRadius),
          topRight: Radius.circular(cornerRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).assignProductivityTitle,
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
  final Function assignProductivity;
  final bool isReadyToAssign;

  _Buttons({
    Key key,
    @required this.assignProductivity,
    @required this.isReadyToAssign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 2, fit: FlexFit.tight, child: Container()),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: IgnorePointer(
            ignoring: !this.isReadyToAssign,
            child: ElevatedButton(
              onPressed: () {
                this.assignProductivity();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  this.isReadyToAssign
                      ? Colors.green
                      : Theme.of(context).backgroundColor,
                ),
              ),
              child: Text(AppLocalizations.of(context).assign),
            ),
          ),
        ),
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
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ),
        Flexible(flex: 2, fit: FlexFit.tight, child: Container()),
      ],
    );
  }
}
