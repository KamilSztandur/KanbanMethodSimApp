import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/common/score_calculator.dart';
import 'package:kanbansim/features/welcome_page/welcome_page.dart';
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
  final double width = 900.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(
          left: 50,
          right: 50,
        ),
        height: 660,
        width: this.width,
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
          children: [
            SizedBox(height: 10),
            _Headline(
              cornerRadius: this.cornerRadius,
            ),
            SizedBox(height: 10),
            _Divider(width: this.width * 0.8, height: 2),
            SizedBox(height: 10),
            _Statistics(
              width: this.width,
              allTasks: this.widget.allTasks,
              users: this.widget.users,
            ),
            SizedBox(height: 20),
            _CloseButton(),
          ],
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  final double cornerRadius;

  _Headline({Key key, @required this.cornerRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).simulationCompleted,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 40,
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
    ScoreCalculator calculator = ScoreCalculator(
      allTasks: this.allTasks,
      users: this.users,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "${AppLocalizations.of(context).summary.toUpperCase()}:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 20),
        Column(
          children: [
            _TaskTypeStatistic(
              amount: calculator.countFinishedTaskWithType(
                TaskType.Standard,
              ),
              score: calculator.sumAllStandardTasks(),
              color: Colors.orange,
              type: AppLocalizations.of(context).standard,
            ),
            SizedBox(height: 15),
            _TaskTypeStatistic(
              amount: calculator.countFinishedTaskWithType(
                TaskType.Expedite,
              ),
              score: calculator.sumAllExpediteTasks(),
              color: Colors.red,
              type: AppLocalizations.of(context).expedite,
            ),
            SizedBox(height: 15),
            _TaskTypeStatistic(
              amount: calculator.countFinishedTaskWithType(
                TaskType.FixedDate,
              ),
              score: calculator.sumAllFixedDateTasks(),
              color: Colors.cyan,
              type: AppLocalizations.of(context).fixedDate,
            ),
            SizedBox(height: 15),
            _Divider(width: this.width * 0.4, height: 2),
            SizedBox(height: 15),
            _FixedDateTasksStatistics(
              beforeDeadlineAmount:
                  calculator.getAmountOfFixedDateTasksBeforeDeadline(),
              onDeadlineAmount:
                  calculator.getAmountOfFixedDateTasksOnDeadline(),
              afterDeadlineAmount:
                  calculator.getAmountOfFixedDateTasksAfterDeadline(),
              beforeDeadlineScore:
                  calculator.calcScoreFromFixedDateTasksBeforeDeadline(),
              onDeadlineScore:
                  calculator.calcScoreFromFixedDateTasksAfterDeadline(),
              afterDeadlineScore:
                  calculator.calcScoreFromFixedDateTasksAfterDeadline(),
            ),
          ],
        ),
        _Divider(width: this.width * 0.4, height: 1),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BonusesInfo(
              maxUsersAmountForBonus: calculator.getMaxUsersAmountForBonus(),
              amountOfTasksAfterFirstStage:
                  calculator.getAmountOfTasksAfterFirstStage(),
              amountOfUsers: this.users.length,
              smallTeamBonus: calculator.smallTeamBonus,
              afterFirstStageTasksBonus:
                  calculator.afterFirstStageTasksBonusWeight,
            ),
            Center(
                child: _ScoreInfo(
              score: calculator.calculate(),
            )),
          ],
        ),
      ],
    );
  }
}

class _TaskTypeStatistic extends StatelessWidget {
  final String type;
  final Color color;
  final int amount;
  final double score;

  _TaskTypeStatistic({
    Key key,
    @required this.type,
    @required this.color,
    @required this.amount,
    @required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    "${AppLocalizations.of(context).completed} $amount ${AppLocalizations.of(context).tasksOfType} ",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color),
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
        ),
        Text("$score ${AppLocalizations.of(context).pts}"),
      ],
    );
  }
}

class _FixedDateTasksStatistics extends StatelessWidget {
  final int beforeDeadlineAmount;
  final int afterDeadlineAmount;
  final int onDeadlineAmount;
  final double beforeDeadlineScore;
  final double onDeadlineScore;
  final double afterDeadlineScore;

  _FixedDateTasksStatistics({
    Key key,
    @required this.beforeDeadlineAmount,
    @required this.onDeadlineAmount,
    @required this.afterDeadlineAmount,
    @required this.beforeDeadlineScore,
    @required this.onDeadlineScore,
    @required this.afterDeadlineScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text:
                    "$beforeDeadlineAmount ${AppLocalizations.of(context).tasksOfFixedDateTypeCompleted} ${AppLocalizations.of(context).beforeDeadline}:\n",
              ),
            ),
            Text("$beforeDeadlineScore ${AppLocalizations.of(context).pts}"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text:
                    "$onDeadlineAmount ${AppLocalizations.of(context).tasksOfFixedDateTypeCompleted} ${AppLocalizations.of(context).onDeadline}:\n",
              ),
            ),
            Text("$onDeadlineScore ${AppLocalizations.of(context).pts}"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text:
                    "$afterDeadlineAmount ${AppLocalizations.of(context).tasksOfFixedDateTypeCompleted} ${AppLocalizations.of(context).afterDeadline}:\n",
              ),
            ),
            Text("$afterDeadlineScore ${AppLocalizations.of(context).pts}"),
          ],
        ),
      ],
    );
  }
}

class _BonusesInfo extends StatelessWidget {
  final double smallTeamBonus;
  final double afterFirstStageTasksBonus;
  final int maxUsersAmountForBonus;
  final int amountOfUsers;
  final int amountOfTasksAfterFirstStage;

  _BonusesInfo({
    Key key,
    @required this.maxUsersAmountForBonus,
    @required this.amountOfUsers,
    @required this.amountOfTasksAfterFirstStage,
    @required this.smallTeamBonus,
    @required this.afterFirstStageTasksBonus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "${AppLocalizations.of(context).bonuses.toUpperCase()}:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text:
                  "${AppLocalizations.of(context).teamConsistedOf} $amountOfUsers ${AppLocalizations.of(context).teamMembers}, ${AppLocalizations.of(context).so}\n",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
            ),
            amountOfUsers <= this.maxUsersAmountForBonus
                ? TextSpan(
                    text:
                        "${this.smallTeamBonus} ${AppLocalizations.of(context).pointsAsPartOfSmallTeamBonusAreAwarded}.\n",
                    style: TextStyle(color: Colors.green),
                  )
                : TextSpan(
                    text:
                        "${AppLocalizations.of(context).smallTeamBonusIsNotAwarded}.\n",
                    style: TextStyle(color: Colors.red),
                  ),
          ]),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    "$amountOfTasksAfterFirstStage ${AppLocalizations.of(context).incompletedTasksFinishedProgressPhaseOfFirstStage}, ${AppLocalizations.of(context).so} \n",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
              amountOfTasksAfterFirstStage == 0
                  ? TextSpan(
                      text:
                          "${AppLocalizations.of(context).noBonusIsAwarded}.\n",
                      style: TextStyle(color: Colors.red),
                    )
                  : TextSpan(
                      text:
                          "${AppLocalizations.of(context).smallBonusOf} ${this.afterFirstStageTasksBonus * amountOfTasksAfterFirstStage} ${AppLocalizations.of(context).pointsAreAwarded}.\n",
                      style: TextStyle(color: Colors.green),
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

class _ScoreInfo extends StatelessWidget {
  final double score;

  _ScoreInfo({
    Key key,
    @required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "${AppLocalizations.of(context).total.toUpperCase()}:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "$score ${AppLocalizations.of(context).pts}",
          style: TextStyle(
            fontSize: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _restartTheApp(context),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
      ),
      child: Text(AppLocalizations.of(context).returnToTitleScreen),
    );
  }

  void _restartTheApp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(),
      ),
    );
  }
}
