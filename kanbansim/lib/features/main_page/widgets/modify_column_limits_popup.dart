import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModifyColumnLimitsPopup {
  final Function(int) stageOneInProgressLimitChanged;
  final Function(int) stageOneDoneLimitChanged;
  final Function(int) stageTwoLimitChanged;
  int stageOneInProgressLimit;
  int stageOneDoneLimit;
  int stageTwoLimit;

  ModifyColumnLimitsPopup({
    @required this.stageOneInProgressLimitChanged,
    @required this.stageOneDoneLimitChanged,
    @required this.stageTwoLimitChanged,
    @required this.stageOneDoneLimit,
    @required this.stageOneInProgressLimit,
    @required this.stageTwoLimit,
  });

  Widget show(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.transparent,
      content: _ModifyColumnLimits(
        stageOneInProgressLimit: this.stageOneInProgressLimit,
        stageOneInProgressLimitChanged: this.stageOneInProgressLimitChanged,
        stageTwoLimit: this.stageTwoLimit,
        stageTwoLimitChanged: this.stageTwoLimitChanged,
        stageOneDoneLimit: this.stageOneDoneLimit,
        stageOneDoneLimitChanged: this.stageOneDoneLimitChanged,
      ),
    );
  }
}

class _ModifyColumnLimits extends StatefulWidget {
  final Function(int) stageOneInProgressLimitChanged;
  final Function(int) stageOneDoneLimitChanged;
  final Function(int) stageTwoLimitChanged;
  final int stageOneInProgressLimit;
  int stageOneDoneLimit;
  final int stageTwoLimit;

  _ModifyColumnLimits({
    @required this.stageOneInProgressLimitChanged,
    @required this.stageOneDoneLimitChanged,
    @required this.stageTwoLimitChanged,
    @required this.stageOneInProgressLimit,
    @required this.stageTwoLimit,
    @required this.stageOneDoneLimit,
  });

  @override
  _ModifyColumnLimitsState createState() => _ModifyColumnLimitsState();
}

class _ModifyColumnLimitsState extends State<_ModifyColumnLimits> {
  int newStageOneInProgressLimit;
  int newStageOneDoneLimit;
  int newStageTwoLimit;

  @override
  Widget build(BuildContext context) {
    _initializeValuesIfNeeded();

    return Container(
      height: 475,
      width: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).accentColor
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        border: Border.all(color: Theme.of(context).primaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: _Headline(cornerRadius: 10),
          ),
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 8,
            child: _LimitSwitch(
              title:
                  "${AppLocalizations.of(context).stageOneTasks}: ${AppLocalizations.of(context).inProgressTasks}",
              limitChanged: (int newLimit) {
                setState(() {
                  this.newStageOneInProgressLimit = newLimit;
                });
              },
              selectedLimit: this.newStageOneInProgressLimit,
            ),
          ),
          Flexible(flex: 1, child: Container()),
          _WindowDivider(),
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 8,
            child: _LimitSwitch(
              title:
                  "${AppLocalizations.of(context).stageOneTasks}: ${AppLocalizations.of(context).doneTasks}",
              limitChanged: (int newLimit) {
                setState(() {
                  this.newStageOneDoneLimit = newLimit;
                });
              },
              selectedLimit: this.newStageOneDoneLimit,
            ),
          ),
          Flexible(flex: 1, child: Container()),
          _WindowDivider(),
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 8,
            child: _LimitSwitch(
              title: "${AppLocalizations.of(context).stageTwoTasks}",
              limitChanged: (int newLimit) {
                setState(() {
                  this.newStageTwoLimit = newLimit;
                });
              },
              selectedLimit: this.newStageTwoLimit,
            ),
          ),
          Flexible(flex: 1, child: Container()),
          _WindowDivider(),
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 4,
            child: _Buttons(
              saveButtonClicked: this._saveButtonPressed,
            ),
          ),
          Flexible(flex: 1, child: Container()),
        ],
      ),
    );
  }

  void _initializeValuesIfNeeded() {
    if (this.newStageOneInProgressLimit == null) {
      if (this.widget.stageOneInProgressLimit == null) {
        this.newStageOneInProgressLimit = 11;
      } else {
        this.newStageOneInProgressLimit = this.widget.stageOneInProgressLimit;
      }
    }

    if (this.newStageOneDoneLimit == null) {
      if (this.widget.stageOneDoneLimit == null) {
        this.newStageOneDoneLimit = 11;
      } else {
        this.newStageOneDoneLimit = this.widget.stageOneDoneLimit;
      }
    }

    if (this.newStageTwoLimit == null) {
      if (this.widget.stageTwoLimit == null) {
        this.newStageTwoLimit = 11;
      } else {
        this.newStageTwoLimit = this.widget.stageTwoLimit;
      }
    }
  }

  void _saveButtonPressed() {
    this.widget.stageOneInProgressLimitChanged(
          this.newStageOneInProgressLimit == 11
              ? null
              : this.newStageOneInProgressLimit,
        );

    this.widget.stageOneDoneLimitChanged(
          this.newStageOneDoneLimit == 11 ? null : this.newStageOneDoneLimit,
        );

    this.widget.stageTwoLimitChanged(
          this.newStageTwoLimit == 11 ? null : this.newStageTwoLimit,
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
      height: 50,
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
            AppLocalizations.of(context).modifyTasksLimits,
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
  final Function saveButtonClicked;

  _Buttons({
    Key key,
    @required this.saveButtonClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 6,
          child: Container(),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              this.saveButtonClicked();
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context).save),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
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
            child: Text(AppLocalizations.of(context).discard),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(),
        ),
      ],
    );
  }
}

class _LimitSwitch extends StatefulWidget {
  final Function(int) limitChanged;
  String title;
  int selectedLimit;

  _LimitSwitch({
    Key key,
    @required this.title,
    @required this.limitChanged,
    @required this.selectedLimit,
  }) : super(key: key);

  @override
  _LimitSwitchState createState() => _LimitSwitchState();
}

class _LimitSwitchState extends State<_LimitSwitch> {
  Color _rightArrowColor;
  Color _leftArrowColor;

  @override
  Widget build(BuildContext context) {
    _setArrowColors();

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${AppLocalizations.of(context).setLimitFor} \"${this.widget.title}\":",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left_outlined),
                color: this._leftArrowColor,
                iconSize: 50,
                onPressed: () {
                  _decreaseProductivity();
                },
              ),
              Container(
                alignment: Alignment.center,
                child: this.widget.selectedLimit == 11
                    ? Icon(
                        CupertinoIcons.loop,
                        size: 20,
                      )
                    : Text(
                        '${this.widget.selectedLimit}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
                  _increaseProductivity();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _increaseProductivity() {
    if (this.widget.selectedLimit + 1 <= 11) {
      this.widget.selectedLimit++;
      this.widget.limitChanged(this.widget.selectedLimit);
    }
  }

  void _decreaseProductivity() {
    if (this.widget.selectedLimit - 1 >= 1) {
      this.widget.selectedLimit--;
      this.widget.limitChanged(this.widget.selectedLimit);
    }
  }

  void _setArrowColors() {
    if (this.widget.selectedLimit == null) {
      this.widget.selectedLimit = 1;
    }

    if (this.widget.selectedLimit == 1) {
      this._leftArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._leftArrowColor = Theme.of(context).primaryColor;
    }

    if (this.widget.selectedLimit == 11) {
      this._rightArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._rightArrowColor = Theme.of(context).primaryColor;
    }
  }
}

class _WindowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2.5,
      child: Container(color: Colors.black.withOpacity(0.2)),
    );
  }
}
