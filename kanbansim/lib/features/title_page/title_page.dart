import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/features/input_output_popups/load_file_popup.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'package:kanbansim/features/users_creator/users_creator.dart';
import 'package:kanbansim/features/title_page/Logo.dart';
import 'package:kanbansim/features/title_page/authors_notice.dart';
import 'package:kanbansim/features/title_page/lang_switch_buttons.dart';
import 'package:kanbansim/features/title_page/menu_button.dart';
import 'package:kanbansim/features/window_bar.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:kanbansim/models/User.dart';
import 'package:kanbansim/models/sim_state.dart';

class TitlePage extends StatefulWidget {
  TitlePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TitlePageState();
}

class TitlePageState extends State<TitlePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: KanbanSimApp.of(context).getBackgroundImage(),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: WindowBorder(
          color: Theme.of(context).primaryColor,
          width: 1,
          child: Center(
            child: Column(
              children: [
                KanbanSimApp.of(context).isWeb() ? Center() : WindowBar(),
                Flexible(flex: 1, child: SizedBox()),
                Flexible(
                  flex: 23,
                  fit: FlexFit.tight,
                  child: Logo(),
                ),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: MenuButton(
                    text: AppLocalizations.of(context).createEmptySession,
                    action: () => _newSessionButtonPressed(),
                  ),
                ),
                Flexible(flex: 2, fit: FlexFit.tight, child: SizedBox()),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: MenuButton(
                    text: AppLocalizations.of(context).loadSession,
                    action: () => _loadButtonPressed(),
                  ),
                ),
                Flexible(flex: 2, fit: FlexFit.tight, child: SizedBox()),
                KanbanSimApp.of(context).isWeb()
                    ? Center()
                    : Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: MenuButton(
                          text: AppLocalizations.of(context).quit,
                          action: () => _quitButtonPressed(),
                        ),
                      ),
                Flexible(flex: 4, fit: FlexFit.tight, child: SizedBox()),
                LangSwitchButtons(),
                Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: AuthorsNotice(),
                ),
                Flexible(flex: 2, fit: FlexFit.tight, child: SizedBox()),
              ],
            ),
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
          SimState newSimState = SimState();
          newSimState.users = users;

          MainPage mainPage = MainPage(loadedSimState: newSimState);
          _switchToMainPage(mainPage);
        },
      ).show(),
    );
  }

  void _loadButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) => LoadFilePopup(
        returnPickedFileContent: (String data) {
          SimState loadedSimState = SimState();
          loadedSimState.createFromData(data);

          MainPage mainPage = MainPage(loadedSimState: loadedSimState);
          _switchToMainPage(mainPage);
        },
      ).show(context),
    );
  }

  void _switchToMainPage(MainPage mainPage) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => mainPage,
      ),
    );
  }

  void _quitButtonPressed() {
    exit(0);
  }
}
