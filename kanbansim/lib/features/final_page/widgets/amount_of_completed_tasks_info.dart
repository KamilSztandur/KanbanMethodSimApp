import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AmountOfCompletedTasksInfo extends StatelessWidget {
  final int amount;

  AmountOfCompletedTasksInfo({
    Key key,
    @required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      height: 135,
      width: 450,
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Theme.of(context).primaryColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${AppLocalizations.of(context).amountOfCompletedTasks}:",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "$amount",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
