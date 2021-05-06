import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/features/input_output_popups/load_file_popup.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'package:kanbansim/features/users_creator/users_creator.dart';
import 'package:kanbansim/features/window_bar.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:kanbansim/models/User.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: WindowBorder(
        color: Theme.of(context).primaryColor,
        width: 1,
        child: Center(
          child: Column(
            children: [
              KanbanSimApp.of(context).isWeb() ? Center() : WindowBar(),
              Flexible(flex: 2, child: SizedBox()),
              Flexible(
                flex: 13,
                fit: FlexFit.tight,
                child: _Logo(),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _MenuButton(
                  text: AppLocalizations.of(context).createEmptySession,
                  action: () => _newSessionButtonPressed(),
                ),
              ),
              Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _MenuButton(
                  text: AppLocalizations.of(context).loadSession,
                  action: () => _loadButtonPressed(),
                ),
              ),
              Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
              KanbanSimApp.of(context).isWeb()
                  ? Center()
                  : Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: _MenuButton(
                        text: AppLocalizations.of(context).quit,
                        action: () => _quitButtonPressed(),
                      ),
                    ),
              Flexible(flex: 2, fit: FlexFit.tight, child: SizedBox()),
              _LangSwitchButtons(),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _AuthorsNotice(),
              ),
              Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  void _newSessionButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) => UsersCreatorPopup(
        usersCreated: (List<User> users) {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(createdUsers: users),
            ),
          );
        },
      ).show(),
    );
  }

  void _loadButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) => LoadFilePopup(
        returnPickedFilepath: (String filePath) {
          //TODO
        },
        returnPickedFileContent: (String data) {
          //TODO
        },
      ).show(context),
    );
  }

  void _quitButtonPressed() {
    exit(0);
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      height: MediaQuery.of(context).size.height * 0.5,
      image: AssetImage('assets/logo.png'),
    );
  }
}

class _AuthorsNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).applicationLegalese,
      overflow: TextOverflow.fade,
      maxLines: 2,
      style: TextStyle(color: Colors.white),
      softWrap: false,
      textAlign: TextAlign.center,
    );
  }
}

class _LangSwitchButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color buttonsColor = Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: buttonsColor,
            side: BorderSide(
              color: buttonsColor,
            ),
          ),
          child: Text(
            "PL",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => KanbanSimApp.of(context).switchLanguageTo("polish"),
        ),
        SizedBox(width: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: buttonsColor,
            side: BorderSide(
              color: buttonsColor,
            ),
          ),
          child: Text(
            "EN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => KanbanSimApp.of(context).switchLanguageTo("english"),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final Function action;
  final String text;

  _MenuButton({
    Key key,
    @required this.text,
    @required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: action,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 0.8],
            tileMode: TileMode.clamp,
            colors: [
              Colors.blue,
              Colors.cyan,
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          height: 100,
          width: 300,
          child: Center(
            child: Text(
              text,
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: GoogleFonts.staatliches(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
