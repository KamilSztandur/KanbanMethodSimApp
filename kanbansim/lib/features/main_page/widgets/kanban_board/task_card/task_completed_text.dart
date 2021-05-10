import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskCompletedText extends StatelessWidget {
  final double size;

  TaskCompletedText({
    Key key,
    @required this.size,
  }) : super(key: key);

  @override
  Widget build(Object context) {
    return Text(
      AppLocalizations.of(context).completed_CAP,
      style: TextStyle(
        color: Colors.black,
        fontSize: this.size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
