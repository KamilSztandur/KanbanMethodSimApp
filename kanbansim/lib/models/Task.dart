import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kanbansim/models/User.dart';

class Task {
  static int _tasksNumber = 1;
  int _taskID;
  String _title;
  User owner;
  _TaskProgress progress;
  bool _isCompleted;
  int _productivityRequiredToUnlock;

  Task(String title, int productivityRequired, User owner) {
    this._taskID = _tasksNumber;
    _tasksNumber++;

    this._title = "Task number #$_taskID";
    this.progress = _TaskProgress(
      productivityRequired,
    );
    this.owner = owner;
    this._productivityRequiredToUnlock = 0;
  }

  void blockTaskRandomly() {
    var dice = Random().nextInt(6) + 1;
    this._productivityRequiredToUnlock = dice == 1 ? 1 : 0;
  }

  bool unlockTaskWith(User user) {
    if (user.getProductivity() >= this._productivityRequiredToUnlock) {
      user.decreaseProductivity(this._productivityRequiredToUnlock);
      this._productivityRequiredToUnlock = 0;

      return true;
    } else {
      return false;
    }
  }

  bool investProductivity(int amount) {
    return investProductivityFrom(this.owner, amount);
  }

  bool investProductivityFrom(User user, int amount) {
    if (amount < 1) {
      return false;
    }

    if (this.progress.getNumberOfUnfulfilledParts() >= amount) {
      bool status = this.progress.fulfillPartsWith(
            user,
            amount,
            user.getID() != owner.getID(),
          );
      _checkIfCompleted();

      return status;
    } else {
      return false;
    }
  }

  void _checkIfCompleted() {
    if (this.progress.getNumberOfUnfulfilledParts() == 0) {
      this._isCompleted = true;
    }
  }

  bool isLocked() {
    return this._productivityRequiredToUnlock != 0;
  }

  bool isCompleted() {
    return this._isCompleted;
  }

  int getProductivityRequiredToUnlock() {
    return this._productivityRequiredToUnlock;
  }

  String getTitle() {
    return this._title;
  }

  int getID() {
    return this._taskID;
  }
}

class _TaskProgress {
  List<User> _parts;
  int _fulfilledPartsAmount;

  _TaskProgress(int maxProductivity) {
    this._parts = <User>[];
    this._parts.length = maxProductivity;
    this._fulfilledPartsAmount = 0;
  }

  bool fulfillPartsWith(User user, int howManyParts, bool isDoubled) {
    if (this.getNumberOfUnfulfilledParts() < howManyParts) {
      return false;
    }

    int cost = isDoubled ? howManyParts * 2 : howManyParts;
    if (user.getProductivity() >= cost) {
      int firstUnfulfilledTaskIndex = this._fulfilledPartsAmount;

      for (int i = 0; i < howManyParts; i++) {
        this._parts[firstUnfulfilledTaskIndex + i] = user;
        _fulfilledPartsAmount++;
      }

      user.decreaseProductivity(cost);

      return true;
    } else {
      return false;
    }
  }

  int getNumberOfAllParts() {
    return this._parts.length;
  }

  int getNumberOfUnfulfilledParts() {
    return (this._parts.length - this._fulfilledPartsAmount);
  }

  bool isFulfilled(int index) {
    return this._parts[index] != null;
  }

  Color getUserColor(int index) {
    return this._parts[index].getColor();
  }
}
