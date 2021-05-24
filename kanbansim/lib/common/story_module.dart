import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/features/notifications/note_from_management.dart';
import 'package:kanbansim/features/notifications/story_notification.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/User.dart';

class StoryModule {
  final Function getAllTasks;
  final Function getUsers;
  final Function getCurrentDay;
  final Function(String) addLog;

  final BuildContext context;
  final int _MAX_DAYS = 10;
  final double _LOCK_PROBABILITY = 0.15;
  final List<int> _POSSIBLE_PRODUCTIVITIES_TO_UNLOCK = [2, 3, 4];

  List<String> _scriptedMessages;

  StoryModule({
    @required this.context,
    @required this.addLog,
    @required this.getCurrentDay,
    @required this.getAllTasks,
    @required this.getUsers,
  });

  int getMaxDays() {
    return this._MAX_DAYS;
  }

  void _initializeScriptedMessagesIfNeeded() {
    if (this._scriptedMessages == null) {
      this._scriptedMessages = [
        AppLocalizations.of(context).storyMessageDay1,
        AppLocalizations.of(context).storyMessageDay2,
        AppLocalizations.of(context).storyMessageDay3,
        AppLocalizations.of(context).storyMessageDay4,
        AppLocalizations.of(context).storyMessageDay5,
        AppLocalizations.of(context).storyMessageDay6,
        AppLocalizations.of(context).storyMessageDay7,
        AppLocalizations.of(context).storyMessageDay8,
        AppLocalizations.of(context).storyMessageDay9,
        AppLocalizations.of(context).storyMessageDay10,
      ];
    }
  }

  void simulationHasBegun() {
    _showNoteFromManagement(0);
    _pushNotificationForDay(0);
    _restoreProductivitiesAfterNewDay();
  }

  void switchedToNextDay() {
    int currentDay = this.getCurrentDay();

    this._eventOccured(
      EventType.INFO,
      "${AppLocalizations.of(context).day} $currentDay ${AppLocalizations.of(context).hasCome}.",
      true,
    );

    _showNoteFromManagement(currentDay);
    _pushNotificationForDay(currentDay);
    _restoreProductivitiesAfterNewDay();
    lockTasksRandomly();
  }

  void switchedToPreviousDay() {
    this._eventOccured(
      EventType.INFO,
      "${AppLocalizations.of(context).cheatWasUsed}. ${AppLocalizations.of(context).additionalDayAdded}.",
      true,
    );
  }

  void newTaskAppeared(Task task) {
    this._eventOccured(
      EventType.NEWTASK,
      "${AppLocalizations.of(context).newTaskAppeared}! ${_getTranslatedTaskTypeName(task.getTaskTypeName())} '${task.getTitle()}'.",
      true,
    );
  }

  void taskDeleted(Task task) {
    this._eventOccured(
      EventType.DELETE,
      "${AppLocalizations.of(context).elementDeleted}! ${_getTranslatedTaskTypeName(task.getTaskTypeName())} '${task.getTitle()}'.",
      true,
    );
  }

  void taskUnlocked(Task task) {
    this._eventOccured(
      EventType.LOCK,
      "${AppLocalizations.of(context).task} ${task.getTitle()} ${AppLocalizations.of(context).hasBeenUnlocked}.",
      true,
    );
  }

  void productivityAssigned(Task task, User user, int value) {
    this._eventOccured(
      EventType.INFO,
      "${user.getName()} ${AppLocalizations.of(context).invested} $value ${AppLocalizations.of(context).productivityInTask} ${task.getTitle()}.",
      true,
    );
  }

  void lockTask(Task task) {
    bool taskIsNotAlreadyBlocked = task.getProductivityRequiredToUnlock() == 0;
    bool taskProgressBarIsNotFull =
        task.progress.getNumberOfUnfulfilledParts() != 0;

    if (taskIsNotAlreadyBlocked && taskProgressBarIsNotFull) {
      int diceRoll = Random().nextInt(
        _POSSIBLE_PRODUCTIVITIES_TO_UNLOCK.length,
      );

      int productivityToUnlock = _POSSIBLE_PRODUCTIVITIES_TO_UNLOCK[diceRoll];

      task.block(productivityToUnlock);
      this._eventOccured(
        EventType.LOCK,
        "${AppLocalizations.of(context).task} ${task.getTitle()} ${AppLocalizations.of(context).hasBeenLocked}}.",
        true,
      );
    }
  }

  void lockTasksRandomly() {
    AllTasksContainer allTasks = this.getAllTasks();
    _lockTasksInListRandomly(allTasks.stageOneInProgressTasksColumn);
    _lockTasksInListRandomly(allTasks.stageTwoTasksColumn);
  }

  void _restoreProductivitiesAfterNewDay() {
    List<User> users = this.getUsers();

    int n = users.length;
    for (int i = 0; i < n; i++) {
      _restoreRandomProductivity(users[i]);
    }
  }

  void _restoreRandomProductivity(User user) {
    int diceRoll = Random().nextInt(5) + 1;

    user.addProductivity(diceRoll);

    this._eventOccured(
      EventType.INFO,
      "${AppLocalizations.of(context).teamMember} ${user.getName()} ${AppLocalizations.of(context).startedDayWithProductivityEqualTo} ${user.getProductivity()}.",
      false,
    );
  }

  bool _isInRange(int number, int min, int max) {
    return (number <= max && number >= min);
  }

  void _lockTasksInListRandomly(List<Task> tasks) {
    int n = tasks.length;
    for (int i = 0; i < n; i++) {
      double diceRoll = Random().nextInt(100) / 100;

      if (diceRoll < this._LOCK_PROBABILITY) {
        lockTask(tasks[i]);
      }
    }
  }

  void _pushNotificationForDay(int dayNumber) {
    this._eventOccured(EventType.INFO, _scriptedMessages[dayNumber], false);
  }

  String _getTranslatedTaskTypeName(String type) {
    switch (type) {
      case "Standard":
        return AppLocalizations.of(context).standard;
        break;

      case "Expedite":
        return AppLocalizations.of(context).expedite;
        break;

      case "FixedDate":
        return AppLocalizations.of(context).fixedDate;
        break;

      default:
        return AppLocalizations.of(context).standard;
    }
  }

  void _eventOccured(EventType type, String text, bool withNotification) {
    if (withNotification) {
      _printNotification(type, text);
    }
    this.addLog(text);
  }

  void _printNotification(EventType type, String text) {
    StoryNotification(
      context: this.context,
      type: type,
      message: text,
    ).show();
  }

  void _showNoteFromManagement(int currentDay) {
    _initializeScriptedMessagesIfNeeded();
    String message = this._scriptedMessages[currentDay];

    showDialog(
      context: context,
      builder: (BuildContext context) => NoteFromManagementPopup(
        message: message,
        users: this.getUsers(),
      ).show(),
    );
  }
}
