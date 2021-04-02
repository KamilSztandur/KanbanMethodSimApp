import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'package:window_size/window_size.dart';
import 'package:overlay_support/overlay_support.dart';

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
    return OverlaySupport(
      child: MaterialApp(
        home: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.8],
              tileMode: TileMode.clamp,
              colors: [
                this._darkTheme ? Colors.grey.shade900 : Colors.grey[300],
                this._darkTheme ? Colors.grey.shade900 : Colors.blue.shade200,
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            body: MainPage(
              scaffoldKey: _scaffoldKey,
              switchTheme: () {
                _switchBrightness();
              },
            ),
          ),
        ),
        theme: ThemeData(
          brightness: _currentBrightness(),
          primaryColor:
              this._darkTheme ? Colors.blue.shade600 : Colors.blue.shade800,
          accentColor:
              this._darkTheme ? Colors.grey[900] : Colors.blue.shade100,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}

class KanbanSimApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => KanbanSimAppState();
}
