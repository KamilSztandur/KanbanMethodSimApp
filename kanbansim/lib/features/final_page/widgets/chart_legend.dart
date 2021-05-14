import 'package:flutter/material.dart';

class ChartLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 100,
      width: 600,
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Theme.of(context).primaryColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Legenda",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          Container(width: 2, color: Colors.blue.withOpacity(0.4)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LegendPosition(
                color: Colors.lightBlueAccent,
                name: "Zadania typu Z Ustaloną Datą",
              ),
              _LegendPosition(
                color: Colors.redAccent,
                name: "Zadania typu Pilnego",
              ),
              _LegendPosition(
                color: Colors.yellowAccent,
                name: "Zadania typu Standardowego",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendPosition extends StatelessWidget {
  final String name;
  final Color color;

  _LegendPosition({
    Key key,
    @required this.name,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            color: this.color,
            border: Border.all(
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          this.name,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ],
    );
  }
}
