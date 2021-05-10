import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskCompletedIcon extends StatelessWidget {
  final double size;

  TaskCompletedIcon({
    Key key,
    @required this.size,
  }) : super(key: key);

  @override
  Widget build(Object context) {
    return Icon(
      Icons.done,
      color: Colors.black,
      size: this.size,
    );
  }
}
