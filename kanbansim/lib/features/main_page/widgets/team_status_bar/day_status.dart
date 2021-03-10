import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';

class DayStatus extends StatefulWidget {
  MainPageState parent;

  DayStatus(MainPageState parent) {
    this.parent = parent;
  }

  @override
  State<StatefulWidget> createState() => DayStatusState(parent);
}

class DayStatusState extends State<DayStatus> {
  MainPageState _parent;
  /* dummies, it awaits to be replaced by values stored in user settings class */
  final int MAX_DAY = 15;
  final int MIN_DAY = 0;
  /* end of dummies */
  int _daysPassed = 0;

  DayStatusState(MainPageState parent) {
    this._parent = parent;
  }

  bool _switchToNextDay() {
    if (_daysPassed < this.MAX_DAY) {
      this._daysPassed++;
      return true;
    } else {
      return false;
    }
  }

  bool _switchToPreviousDay() {
    if (_daysPassed > this.MIN_DAY) {
      this._daysPassed--;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
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
              Text(
                "Day",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Container(
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
                          splashRadius: 15,
                          splashColor: Colors.grey,
                          iconSize: 50,
                          onPressed: () {
                            bool isSuccessful = false;

                            setState(() {
                              isSuccessful = _switchToPreviousDay();
                            });

                            SubtleMessage.messageWithContext(
                              context,
                              isSuccessful
                                  ? "Switched to previous day!"
                                  : "Previous day's limit reached.",
                            );
                          },
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$_daysPassed',
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right_outlined),
                          color: Theme.of(context).primaryColor,
                          splashRadius: 15,
                          splashColor: Colors.grey,
                          iconSize: 50,
                          onPressed: () {
                            bool isSuccessful = false;
                            setState(() {
                              isSuccessful = _switchToNextDay();
                            });

                            SubtleMessage.messageWithContext(
                              context,
                              isSuccessful
                                  ? "Switched to next day!"
                                  : "Next day's limit reached.",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
