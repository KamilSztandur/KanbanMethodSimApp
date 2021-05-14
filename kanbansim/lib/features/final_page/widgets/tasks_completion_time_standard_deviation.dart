import 'package:flutter/material.dart';

class TasksCompletionTimeStandardDeviation extends StatelessWidget {
  final double standardDeviation;

  const TasksCompletionTimeStandardDeviation({
    Key key,
    @required this.standardDeviation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      height: 165,
      width: 450,
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
            "Odchylenie standardowe od średniej wykonania jednego zadania",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "${standardDeviation.toStringAsFixed(2)} dni",
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
