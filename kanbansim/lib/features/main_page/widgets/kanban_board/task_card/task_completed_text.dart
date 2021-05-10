import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskCompletedText extends StatelessWidget {
  final double size;

  TaskCompletedText({
    Key key,
    @required this.size,
  }) : super(key: key);

  @override
  Widget build(Object context) {
    return Text(
      "UKOŃCZONE",
      style: TextStyle(
        color: Colors.black,
        fontSize: this.size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
