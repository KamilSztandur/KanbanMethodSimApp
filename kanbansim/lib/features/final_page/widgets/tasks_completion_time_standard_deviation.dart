import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksCompletionTimeStandardDeviation extends StatelessWidget {
  final double standardDeviation;

  const TasksCompletionTimeStandardDeviation({
    Key key,
    @required this.standardDeviation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Theme.of(context).primaryColor)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "${AppLocalizations.of(context).standardDeviationFromAverageTaskCompletionoTime}:",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "${standardDeviation.toStringAsFixed(2)} ${AppLocalizations.of(context).days}",
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
