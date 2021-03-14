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
      title: 'Kanban Method Simulator',
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: MainPage(
            scaffoldKey: _scaffoldKey,
            switchTheme: () {
              _switchBrightness();
            },
          ),
        ),
      ),
      theme: ThemeData(
        brightness: _currentBrightness(),
        primaryColor: Colors.blue.shade800,
        accentColor: Colors.blue.shade100,
        fontFamily: 'Comic Sans',
      ),
    );
  }
}

class KanbanSimApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => KanbanSimAppState();
}

/*
PURPLE:
primaryColor: Colors.indigoAccent.shade400,
accentColor: Colors.indigoAccent.shade100,

ORANGE:
primaryColor: Colors.deepOrange.shade800,
accentColor: Colors.orange.shade300,

BLUE
Colors.blue.shade800,
accentColor: Colors.blue.shade100,

GREY:
Colors.grey
*/