import 'package:flutter/material.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DayStatus extends StatelessWidget {
  final Function(int) dayHasChanged;
  final Function getCurrentDay;
  final int MAX_DAY;
  final int MIN_DAY;
  int _daysPassed;

  DayStatus({
    Key key,
    @required this.MAX_DAY,
    @required this.MIN_DAY,
    @required this.dayHasChanged,
    @required this.getCurrentDay,
  }) : super(key: key);

  void updateCurrentDay(int day) {
    this._daysPassed = day;
  }

  @override
  Widget build(BuildContext context) {
    if (_daysPassed == 0 || _daysPassed == null) {
      this._daysPassed = this.getCurrentDay();
    }

    return Center(
      child: Container(
        height: 100,
        width: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
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
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              _Title(),
              SizedBox(height: 10),
              _subRow(
                (int delta) {
                  this._daysPassed += delta;
                  this.dayHasChanged(_daysPassed);
                },
                MAX_DAY,
                MIN_DAY,
                _daysPassed,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).day,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _subRow extends StatefulWidget {
  Function(int) dayHasChanged;
  int MAX_DAY;
  int MIN_DAY;
  int daysPassed;

  _subRow(Function(int) dayHasChanged, int MAX_DAY, int MIN_DAY, int days) {
    this.MAX_DAY = MAX_DAY;
    this.MIN_DAY = MIN_DAY;
    this.dayHasChanged = dayHasChanged;
    this.daysPassed = days;
  }

  @override
  _subRowState createState() => _subRowState();
}

class _subRowState extends State<_subRow> {
  bool _switchToNextDay() {
    if (widget.daysPassed < this.widget.MAX_DAY) {
      widget.daysPassed++;
      this.widget.dayHasChanged(1);
      return true;
    } else {
      return false;
    }
  }

  bool _switchToPreviousDay() {
    if (widget.daysPassed > this.widget.MIN_DAY) {
      widget.daysPassed--;
      this.widget.dayHasChanged(-1);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 150,
      height: 50,
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left_outlined),
                color: Theme.of(context).primaryColor,
                splashRadius: 55,
                splashColor: Theme.of(context).primaryColor,
                iconSize: 50,
                onPressed: () {
                  bool isSuccessful = false;

                  setState(() {
                    isSuccessful = _switchToPreviousDay();
                  });

                  SubtleMessage.messageWithContext(
                    context,
                    isSuccessful
                        ? AppLocalizations.of(context)
                            .switchToPreviousDaySuccess
                        : AppLocalizations.of(context).previousDaysLimitReached,
                  );
                },
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '${widget.daysPassed}',
                  style: TextStyle(
                    fontSize: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                      Theme.of(context).brightness == Brightness.light
                          ? (0.9)
                          : (0.0)),
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right_outlined),
                color: Theme.of(context).primaryColor,
                splashRadius: 15,
                splashColor: Theme.of(context).primaryColor,
                iconSize: 50,
                onPressed: () {
                  bool isSuccessful = false;
                  setState(() {
                    isSuccessful = _switchToNextDay();
                  });

                  SubtleMessage.messageWithContext(
                    context,
                    isSuccessful
                        ? AppLocalizations.of(context).switchToNextDaySuccess
                        : AppLocalizations.of(context).nextDaysLimitReached,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
