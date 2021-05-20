import 'package:flutter/material.dart';
import 'package:kanbansim/kanban_sim_app.dart';

class VersionInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      KanbanSimApp.of(context).getReleaseVersionInfo(),
      textAlign: TextAlign.right,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    );
  }
}
