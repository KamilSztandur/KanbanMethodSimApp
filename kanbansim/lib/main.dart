import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(KanbanSimApp());

  doWhenWindowReady(() {
    final initialSize = Size(1300, 650);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}
