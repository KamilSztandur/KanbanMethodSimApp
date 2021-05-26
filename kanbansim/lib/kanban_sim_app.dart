import 'package:flutter/material.dart';
import 'package:kanbansim/features/title_page/title_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class KanbanSimApp extends StatefulWidget {
  final String version = "1.2.0";

  static _KanbanSimAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_KanbanSimAppState>();

  @override
  _KanbanSimAppState createState() => _KanbanSimAppState();
}

class _KanbanSimAppState extends State<KanbanSimApp> {
  bool _darkTheme = true;
  Locale _locale;

  @override
  Widget build(BuildContext context) {
    _createSavesFolder();
    setWindowTitle("Kanban Method's Simulator");

    return OverlaySupport(
      child: MaterialApp(
        /* body */
        home: Container(
          decoration: BoxDecoration(image: getBackgroundImage()),
          child: TitlePage(),
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

  void _createSavesFolder() async {
    final Directory _appDocDir = Directory.current;
    final Directory savesFolder = Directory('${_appDocDir.path}/saves/');

    if (savesFolder.existsSync()) {
      return;
    } else {
      savesFolder.create(recursive: true);
    }
  }

  DecorationImage getBackgroundImage() {
    return DecorationImage(
      image: AssetImage(
        this._darkTheme
            ? "assets/background.jpg"
            : "assets/background_light.jpg",
      ),
      fit: BoxFit.cover,
    );
  }

  bool isWeb() {
    return kIsWeb;
  }

  void switchLanguageTo(String language) {
    setState(() {
      switch (language) {
        case "polish":
          _locale = Locale("pl");
          break;

        case "english":
          _locale = Locale("en");
          break;

        default:
          _locale = Locale("en");
      }
    });
  }

  String getReleaseVersionInfo() {
    String platform = "";

    if (isWeb()) {
      platform = "web";
    } else {
      platform = "desktop";
    }

    return '${this.widget.version}-${platform.toUpperCase()}';
  }

  void switchTheme() {
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
}
