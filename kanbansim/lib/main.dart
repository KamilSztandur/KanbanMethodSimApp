import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(KanbanSimApp());
}

class KanbanSimApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => KanbanSimAppState();
}

class KanbanSimAppState extends State<KanbanSimApp> {
  final _scaffoldKey = GlobalKey();
  bool _darkTheme = false;
  Locale _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

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
        /* body */
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

        /* Languages */
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,

        /* Theme */
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
