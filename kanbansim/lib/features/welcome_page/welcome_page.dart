import 'dart:io';
import 'package:kanbansim/common/input_output_file_picker/input/save_file_picker.dart';
import 'package:kanbansim/common/input_output_file_picker/input/save_file_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanbansim/common/input_output_file_picker/input/filepicker_interface.dart';
import 'package:kanbansim/features/input_output_popups/load_file_popup.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WelcomePage extends StatefulWidget {
  final VoidCallback startedNew;
  final Function(String) loadedExisting;
  final scaffoldKey;

  WelcomePage({
    this.scaffoldKey,
    @required this.startedNew,
    @required this.loadedExisting,
  });

  @override
  State<StatefulWidget> createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Flexible(flex: 3, fit: FlexFit.tight, child: SizedBox()),
          Flexible(
            flex: 13,
            fit: FlexFit.tight,
            child: _buildLogo(),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: _buildButton(
              AppLocalizations.of(context).createEmptySession,
              () => _newSessionButtonPressed(),
            ),
          ),
          Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: _buildButton(
              AppLocalizations.of(context).loadSession,
              () => _loadButtonPressed(),
            ),
          ),
          Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: _buildButton(
              AppLocalizations.of(context).quit,
              () => _quitButtonPressed(),
            ),
          ),
          Flexible(flex: 2, fit: FlexFit.tight, child: SizedBox()),
          _buildLangSwitchButton(),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: _buildAuthorNotice(),
          ),
          Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image(
      height: MediaQuery.of(context).size.height * 0.5,
      image: AssetImage('assets/logo.png'),
    );
  }

  Widget _buildButton(String text, Function action) {
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

  Widget _buildAuthorNotice() {
    return Text(
      AppLocalizations.of(context).applicationLegalese,
      overflow: TextOverflow.fade,
      maxLines: 2,
      style: TextStyle(color: Colors.white),
      softWrap: false,
      textAlign: TextAlign.center,
    );
  }

  void _newSessionButtonPressed() {
    this.widget.startedNew();
  }

  void _loadButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) => LoadFilePopup(
        returnPickedFilepath: (String filePath) {
          this.widget.loadedExisting(filePath);
        },
      ).show(context),
    );
  }

  void _quitButtonPressed() {
    exit(0);
  }

  Widget _buildLangSwitchButton() {
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
