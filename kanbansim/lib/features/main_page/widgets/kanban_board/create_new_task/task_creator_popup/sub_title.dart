import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  final String title;

  SubTitle({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      textAlign: TextAlign.left,
    );
  }
}
