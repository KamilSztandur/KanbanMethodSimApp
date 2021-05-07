import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kanbansim/models/TaskType.dart';
import 'package:kanbansim/models/User.dart';

class Task {
  static int _latestTaskID = 1;
  int _taskID;
  String _title;
  User owner;
  _TaskProgress progress;
  bool _isCompleted;
  int _productivityRequiredToUnlock;
  TaskType _type;
  int _deadlineDay;
  int startDay;
  int endDay;

  Task.dummy() {
    //
  }

  Task(String title, int productivityRequired, User owner, TaskType type) {
    this._taskID = _latestTaskID;
    _latestTaskID++;

    this._title = title;
    this.progress = _TaskProgress(
      productivityRequired,
    );
    this.owner = owner;
    this._productivityRequiredToUnlock = 0;
    this._type = type;
    blockTaskRandomly();
  }

  int getLatestTaskID() {
    return _latestTaskID;
  }

  void setLatestTaskID(int latestTaskID) {
    _latestTaskID = latestTaskID;
  }

  void loadAdditionalDataFromSavefile(int taskID, List<User> parts, int prod) {
    this._taskID = taskID;
    this.progress._parts = parts;
    this._productivityRequiredToUnlock = prod;

    int fulfilledPartsAmount = 0;
    int n = parts.length;
    for (int i = 0; i < n; i++) {
      if (parts[i] != null) {
        fulfilledPartsAmount++;
      }
    }

    this.progress._fulfilledPartsAmount = fulfilledPartsAmount;
  }

  TaskType getTaskType() {
    return this._type;
  }

  void setDeadlineDay(int day) {
    this._deadlineDay = day;
  }

  int getDeadlineDay() {
    if (this._type == TaskType.FixedDate) {
      return this._deadlineDay;
    } else {
      return -1;
    }
  }

  String getTaskTypeName() {
    return this._type.toString().split('.').last;
  }

  void blockTaskRandomly() {
    var dice = Random().nextInt(6) + 1;
    if (dice == 1) {
      this._productivityRequiredToUnlock = Random().nextInt(3) + 1;
    } else {
      this._productivityRequiredToUnlock = 0;
    }
  }

  void unlock() {
    this._productivityRequiredToUnlock = 0;
  }

  void unlockWith(User user) {
    user.decreaseProductivity(this._productivityRequiredToUnlock);
    this.unlock();
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
    if (this._parts[index] == null) {
      return Colors.transparent;
    } else {
      return this._parts[index].getColor();
    }
  }

  int getUserID(int index) {
    if (this._parts[index] == null) {
      return -1;
    } else {
      return this._parts[index].getID();
    }
  }
}
