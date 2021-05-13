import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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
  final List<int> _POSSIBLE_PRODUCTIVITIES_AFTER_NEW_DAY = [3, 4, 5];
  final List<int> _POSSIBLE_PRODUCTIVITIES_TO_UNLOCK = [2, 3, 4];
  final List<int> _UNLOCK_POSSIBILITIES_RANGES = [1, 30, 31, 75, 76, 100];
  final List<String> _scriptedMessages = [
    "Rozpoczynacie pracę w nowym zespole. Zdefiniujcie zadania standardowe i zacznijcie nad nimi pracować.",
    "Nie zapomnijcie o wypełnieniu wszystkich pól w skrypcie.",
    "System płatności uległ awarii. Z każdą godziną firma traci duże pieniądze. Zdefiniujcie 4 zadania pilne (Expedite) i natychmiast zacznijcie nad nimi pracować. Ich ukończenie ma najwyższy priorytet.",
    "Specjaliści od marketingu wymyślili promocję z okazji „Dnia Słonecznika”. Zdefiniujcie 3 zadania z ustaloną datą (Fixed Date). By przynieść wartość dla naszej organizacji muszą być ukończone najpóźniej 10 dnia. Ich wcześniejsze ukończenie nie jest ważne bo i tak promocja nie zostanie upubliczniona do końca 10 dnia.",
    "To ostatni dzień w tygodniu. Pamiętajcie by po zakończeniu pracy podsumować tydzień tak jak zostało to opisane w skrypcie.",
    "Nowy tydzień, nowe możliwości. Powodzenia.",
    "Dobra robota, pracujcie dalej.",
    "Jeden z menedżerów wpadł na pomysł dodania nowej funkcji do naszego produktu. Wymagałoby to zrealizowania 4 standardowych zadań (wszystkie muszą być ukończone by nowa funkcja działała). Prosi was o podanie szacowanego czasu zrealizowania tych zadań. Szacowany dzień ukończenia tych 4 zadań zapiszcie w skrypcie.",
    "Zostały już tylko dwa dni na ukończenie zadań z ustaloną datą.",
    "Ostatni dzień symulacji. Dokończcie pracę i podsumujcie ją w skrypcie.",
  ];

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

  void switchedToNextDay() {
    int currentDay = this.getCurrentDay();

    this._eventOccured(
      EventType.INFO,
      "Nadszedł dzień $currentDay.",
    );

    _pushNotificationForDay(currentDay);
    _restoreProductivitiesAfterNewDay();
    lockTasksRandomly();
  }

  void switchedToPreviousDay() {
    this._eventOccured(
      EventType.INFO,
      "Skorzystano z oszustwa. Przyznano dodatkowy dzień.",
    );
  }

  void newTaskAppeared(Task task) {
    this._eventOccured(
      EventType.NEWTASK,
      "${AppLocalizations.of(context).newTaskAppeared}! ${_getTranslatedTaskTypeName(task.getTaskTypeName())} '${task.getTitle()}'.",
    );
  }

  void taskDeleted(Task task) {
    this._eventOccured(
      EventType.DELETE,
      "${AppLocalizations.of(context).elementDeleted}! ${_getTranslatedTaskTypeName(task.getTaskTypeName())} '${task.getTitle()}'.",
    );
  }

  void lockTask(Task task) {
    int diceRoll = Random().nextInt(3);
    int productivityToUnlock = _POSSIBLE_PRODUCTIVITIES_TO_UNLOCK[diceRoll];

    task.block(productivityToUnlock);
    this._eventOccured(
      EventType.LOCK,
      "Zadanie ${task.getTitle()} zostało zablokowane.",
    );
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
    int diceRoll = Random().nextInt(100 + 1) + 1;

    if (_isInRange(
      diceRoll,
      _UNLOCK_POSSIBILITIES_RANGES[0],
      _UNLOCK_POSSIBILITIES_RANGES[1],
    )) {
      user.addProductivity(_POSSIBLE_PRODUCTIVITIES_AFTER_NEW_DAY[1]);
    } else if (_isInRange(
      diceRoll,
      _UNLOCK_POSSIBILITIES_RANGES[2],
      _UNLOCK_POSSIBILITIES_RANGES[3],
    )) {
      user.addProductivity(_POSSIBLE_PRODUCTIVITIES_AFTER_NEW_DAY[2]);
    } else if (_isInRange(
      diceRoll,
      _UNLOCK_POSSIBILITIES_RANGES[4],
      _UNLOCK_POSSIBILITIES_RANGES[5],
    )) {
      user.addProductivity(_POSSIBLE_PRODUCTIVITIES_AFTER_NEW_DAY[3]);
    }

    this._eventOccured(
      EventType.INFO,
      "Członek zespołu ${user.getName()} rozpoczął dzień z produktywnością równą ${user.getProductivity()}.",
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
    this._eventOccured(EventType.INFO, _scriptedMessages[dayNumber - 1]);
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

  void _eventOccured(EventType type, String text) {
    _printNotification(type, text);
    this.addLog(text);
  }

  void _printNotification(EventType type, String text) {
    StoryNotification(
      context: this.context,
      type: type,
      message: text,
    ).show();
  }
}
