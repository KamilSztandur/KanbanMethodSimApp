import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanban Method Simulator',
      theme: ThemeData.light(),
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: MainPage(scaffoldKey: _scaffoldKey),
        ),
      ),
    );
  }
}
