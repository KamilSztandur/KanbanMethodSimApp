import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'package:window_size/window_size.dart';

void main() {
  runApp(KanbanSimApp());
}

class KanbanSimAppState extends State<KanbanSimApp> {
  final _scaffoldKey = GlobalKey();
  bool _darkTheme = false;

  void _switchBrightness() {
    setState(() {
      this._darkTheme = !this._darkTheme;
    });
  }

  Brightness _currentBrightness() {
    if (this._darkTheme) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    setWindowTitle("Kanban Method's Simulator");
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: MainPage(
          scaffoldKey: _scaffoldKey,
          switchTheme: () {
            _switchBrightness();
          },
        ),
      ),
      theme: ThemeData(
        brightness: _currentBrightness(),
        primaryColor: Colors.blue.shade800,
        accentColor: this._darkTheme ? Colors.grey[900] : Colors.blue.shade100,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class KanbanSimApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => KanbanSimAppState();
}
