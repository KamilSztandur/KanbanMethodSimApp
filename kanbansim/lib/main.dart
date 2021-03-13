import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'package:window_size/window_size.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    setWindowTitle("Kanban Method's Simulator");

    return MaterialApp(
      title: 'Kanban Method Simulator',
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: MainPage(scaffoldKey: _scaffoldKey),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
