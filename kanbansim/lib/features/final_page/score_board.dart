import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/common/stats_calculator.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/TaskType.dart';
import 'package:kanbansim/models/User.dart';

class ScoreBoard extends StatefulWidget {
  final AllTasksContainer allTasks;
  final List<User> users;

  ScoreBoard({
    Key key,
    @required this.allTasks,
    @required this.users,
  }) : super(key: key);

  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  final double cornerRadius = 15.0;
  final double width = 500.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(
          left: 40,
          right: 40,
        ),
        height: 335,
        width: 450,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(this.cornerRadius),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              "STATYSTYKI",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            _Divider(width: this.width * 0.6, height: 2),
            SizedBox(height: 5),
            _Statistics(
              width: this.width,
              allTasks: this.widget.allTasks,
              users: this.widget.users,
            ),
            _Divider(width: this.width * 0.3, height: 2),
            _UsersStats(users: this.widget.users),
          ],
        ),
      ),
    );
  }
}

class _Statistics extends StatelessWidget {
  final double width;
  final AllTasksContainer allTasks;
  final List<User> users;

  _Statistics({
    Key key,
    @required this.width,
    @required this.allTasks,
    @required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StatsCalculator calculator = StatsCalculator(allTasks: this.allTasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TaskTypeStatistic(
              amount: calculator.countFinishedTaskWithType(
                TaskType.Standard,
              ),
              color: Colors.orange,
              type: AppLocalizations.of(context).standard,
            ),
            SizedBox(height: 5),
            _TaskTypeStatistic(
              amount: calculator.countFinishedTaskWithType(
                TaskType.Expedite,
              ),
              color: Colors.red,
              type: AppLocalizations.of(context).expedite,
            ),
            SizedBox(height: 5),
            _TaskTypeStatistic(
              amount: calculator.countFinishedTaskWithType(
                TaskType.FixedDate,
              ),
              color: Colors.cyan,
              type: AppLocalizations.of(context).fixedDate,
            ),
            SizedBox(height: 10),
            _Divider(width: this.width * 0.3, height: 2),
            SizedBox(height: 10),
            _FixedDateTasksStatistics(
              beforeDeadlineAmount:
                  calculator.getAmountOfFixedDateTasksBeforeDeadline(),
              onDeadlineAmount:
                  calculator.getAmountOfFixedDateTasksOnDeadline(),
              afterDeadlineAmount:
                  calculator.getAmountOfFixedDateTasksAfterDeadline(),
            ),
          ],
        ),
      ],
    );
  }
}

class _UsersStats extends StatelessWidget {
  final List<User> users;

  const _UsersStats({
    Key key,
    this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text:
                "${AppLocalizations.of(context).teamConsistedOf} ${this.users.length} ${AppLocalizations.of(context).teamMembers}:\n",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
          TextSpan(children: _getFormattedUsersNames()),
        ],
      ),
    );
  }

  List<TextSpan> _getFormattedUsersNames() {
    List<TextSpan> names = <TextSpan>[];

    int n = this.users.length;
    for (int i = 0; i < n; i++) {
      names.add(
        TextSpan(
          text: "${this.users[i].getName()}",
          style: TextStyle(
            color: this.users[i].getColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      names.add(TextSpan(text: ", "));
    }

    return names;
  }
}

class _TaskTypeStatistic extends StatelessWidget {
  final String type;
  final Color color;
  final int amount;

  _TaskTypeStatistic({
    Key key,
    @required this.type,
    @required this.color,
    @required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text:
                "${AppLocalizations.of(context).completed} $amount ${AppLocalizations.of(context).tasksOfType} ",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
          TextSpan(
            text: this.type.toUpperCase(),
            style: TextStyle(
              color: this.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ":",
          ),
        ],
      ),
    );
  }
}

class _FixedDateTasksStatistics extends StatelessWidget {
  final int beforeDeadlineAmount;
  final int afterDeadlineAmount;
  final int onDeadlineAmount;

  _FixedDateTasksStatistics({
    Key key,
    @required this.beforeDeadlineAmount,
    @required this.onDeadlineAmount,
    @required this.afterDeadlineAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            children: [
              TextSpan(
                text:
                    "$beforeDeadlineAmount ${AppLocalizations.of(context).tasksOfFixedDateTypeCompleted} ${AppLocalizations.of(context).beforeDeadline}.\n",
              ),
              TextSpan(
                text:
                    "$onDeadlineAmount ${AppLocalizations.of(context).tasksOfFixedDateTypeCompleted} ${AppLocalizations.of(context).onDeadline}.\n",
              ),
              TextSpan(
                text:
                    "$afterDeadlineAmount ${AppLocalizations.of(context).tasksOfFixedDateTypeCompleted} ${AppLocalizations.of(context).afterDeadline}.\n",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  final double width;
  final double height;

  _Divider({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Center(
          child: Container(
            height: this.height,
            color: Theme.of(context).primaryColor,
            width: this.width,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
