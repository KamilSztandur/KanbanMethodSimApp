import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/sub_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeadlineDaySwitch extends StatefulWidget {
  final Function(int) updateDeadlineDay;
  final int initialDeadlineDay;
  final int maxSimDay;
  final int minSimDay;

  DeadlineDaySwitch({
    Key key,
    @required this.maxSimDay,
    @required this.minSimDay,
    @required this.initialDeadlineDay,
    @required this.updateDeadlineDay,
  }) : super(key: key);

  @override
  DeadlineDaySwitchState createState() => DeadlineDaySwitchState();
}

class DeadlineDaySwitchState extends State<DeadlineDaySwitch> {
  int deadlineDay;
  Color _rightArrowColor;
  Color _leftArrowColor;

  void setUp() {
    if (this.deadlineDay == 0) {
      this.deadlineDay = widget.initialDeadlineDay;
    }
    _setArrowColors();
  }

  @override
  Widget build(BuildContext context) {
    setUp();

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubTitle(
            title: AppLocalizations.of(context).setDeadline + ":",
          ),
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
                  '$deadlineDay',
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

  void _increaseProductivityRequired() {
    if (this.deadlineDay + 1 <= this.widget.maxSimDay) {
      this.deadlineDay++;
    }

    this.widget.updateDeadlineDay(this.deadlineDay);
  }

  void _decreaseProductivityRequired() {
    if (this.deadlineDay - 1 >= this.widget.minSimDay) {
      this.deadlineDay--;
    }

    this.widget.updateDeadlineDay(this.deadlineDay);
  }

  void _setArrowColors() {
    if (this.deadlineDay == null) {
      this.deadlineDay = this.widget.minSimDay;
    }

    if (this.deadlineDay == this.widget.minSimDay) {
      this._leftArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._leftArrowColor = Theme.of(context).primaryColor;
    }

    if (this.deadlineDay == this.widget.maxSimDay) {
      this._rightArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._rightArrowColor = Theme.of(context).primaryColor;
    }
  }
}
