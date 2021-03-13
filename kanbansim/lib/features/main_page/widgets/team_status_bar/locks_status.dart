import 'package:flutter/material.dart';

class LocksStatus extends StatefulWidget {
  final Function checkForLocks;

  LocksStatus({
    Key key,
    @required this.checkForLocks,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocksStatusState();
}

class LocksStatusState extends State<LocksStatus> {
  bool _areThereAnyLocks;

  void _updateStatus() {
    this._areThereAnyLocks = this.widget.checkForLocks();
  }

  bool getStatus() {
    return this._areThereAnyLocks;
  }

  @override
  Widget build(BuildContext context) {
    _updateStatus();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              Text(
                "Locks",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                width: 75,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: this._areThereAnyLocks
                      ? Colors.redAccent
                      : Colors.lightGreenAccent,
                ),
                child: Text(
                  this._areThereAnyLocks ? "YES" : "NO",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
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
