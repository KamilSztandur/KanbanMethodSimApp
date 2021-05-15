import 'package:flutter/material.dart';

class DaysProgressIndicatorBar extends StatelessWidget {
  final int maxDays;
  final int currentDay;

  DaysProgressIndicatorBar({
    Key key,
    @required this.maxDays,
    @required this.currentDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.25),
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(25, 20),
          bottomRight: Radius.elliptical(25, 20),
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightBlueAccent.withOpacity(0.6),
                        Colors.blue.shade700.withOpacity(0.6),
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.blue.shade800.withOpacity(0.6)
                            : Colors.purple.withOpacity(0.6),
                      ],
                      stops: [0.0, 0.75, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(25, 20),
                      topRight: _isAtEnd() ? Radius.zero : Radius.circular(10),
                      bottomRight: _isAtEnd()
                          ? Radius.elliptical(25, 20)
                          : Radius.circular(10),
                    ),
                  ),
                ),
                flex: currentDay,
                fit: FlexFit.tight,
              ),
              Flexible(
                child: Container(),
                flex: (maxDays - currentDay),
                fit: FlexFit.tight,
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "${_calcPercent()}%",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calcPercent() {
    double percents = (currentDay / maxDays) * 100;
    return percents.toInt();
  }

  bool _isAtEnd() {
    return this.currentDay == this.maxDays;
  }
}
