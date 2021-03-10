import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/main_page/main_page.dart';

class LocksStatus extends StatefulWidget {
  MainPageState parent;

  LocksStatus(MainPageState parent) {
    this.parent = parent;
  }

  @override
  State<StatefulWidget> createState() => LocksStatusState(parent);
}

class LocksStatusState extends State<LocksStatus> {
  MainPageState _parent;
  bool _areThereAnyLocks;

  LocksStatusState(MainPageState parent) {
    this._parent = parent;
  }

  void updateStatus(bool status) {
    this._areThereAnyLocks = status;
  }

  bool getStatus() {
    return this._areThereAnyLocks;
  }

  @override
  Widget build(BuildContext context) {
    _test_randStatus();

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

  void _test_randStatus() {
    this._areThereAnyLocks = Random().nextBool();
  }
}
