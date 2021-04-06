import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanbansim/features/input_output_popups/load_file_popup.dart';
import 'package:kanbansim/features/input_output_popups/save_file_popup.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/features/window_bar.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenuBar extends StatelessWidget {
  final VoidCallback addRandomTasks;
  final VoidCallback clearAllTasks;
  final Function(String) loadSimStateFromFilePath;
  final VoidCallback saveSimStateIntoFile;

  LoadFilePopup pickFilePopup;
  SaveFilePopup saveFilePopup;

  MainMenuBar({
    Key key,
    @required this.addRandomTasks,
    @required this.clearAllTasks,
    @required this.loadSimStateFromFilePath,
    @required this.saveSimStateIntoFile,
  }) : super(key: key);

  void _initializeFilePickerPopup() {
    pickFilePopup = LoadFilePopup(
      returnPickedFilepath: (String filePath) {
        this.loadSimStateFromFilePath(filePath);
      },
    );
  }

  void _initializeFileSaverPopup() {
    saveFilePopup = SaveFilePopup();
  }

  @override
  Widget build(BuildContext context) {
    _initializeFilePickerPopup();
    _initializeFileSaverPopup();

    return Container(
      height: 76,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent.withOpacity(0.8), Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          stops: [0.0, 0.8],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Column(
        children: [
          WindowBar(),
          PlutoMenuBar(
            backgroundColor: Colors.blueAccent.withOpacity(0.8),
            menuIconColor: Colors.white,
            textStyle: TextStyle(color: Colors.white),
            menus: [
              MenuItem(
                title: AppLocalizations.of(context).newSession,
                icon: Icons.create_outlined,
                children: [
                  MenuItem(
                    title: AppLocalizations.of(context).createEmptySession,
                    icon: Icons.create_new_folder_outlined,
                    onTap: () {
                      SubtleMessage.messageWithContext(
                        context,
                        AppLocalizations.of(context).createEmptySession,
                      );
                    },
                  ),
                  MenuItem(
                    title: AppLocalizations.of(context).selectTemplate,
                    icon: Icons.file_copy_outlined,
                    onTap: () {
                      SubtleMessage.messageWithContext(
                        context,
                        AppLocalizations.of(context).selectingTemplateNotif,
                      );
                    },
                  ),
                ],
              ),
              MenuItem(
                title: AppLocalizations.of(context).saveSession,
                icon: Icons.save_outlined,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        this.saveFilePopup.show(context),
                  );
                },
              ),
              MenuItem(
                title: AppLocalizations.of(context).loadSession,
                icon: Icons.read_more_outlined,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        this.pickFilePopup.show(context),
                  );
                },
              ),
              MenuItem(
                title: AppLocalizations.of(context).addRandomTasks,
                icon: Icons.library_add_outlined,
                onTap: () {
                  this.addRandomTasks();

                  SubtleMessage.messageWithContext(
                    context,
                    AppLocalizations.of(context).addRandomTasksSuccess,
                  );
                },
              ),
              MenuItem(
                title: AppLocalizations.of(context).resetSession,
                icon: Icons.delete_forever_outlined,
                onTap: () {
                  this.clearAllTasks();

                  SubtleMessage.messageWithContext(
                    context,
                    AppLocalizations.of(context).resetSessionSuccess,
                  );
                },
              ),
              MenuItem(
                title: AppLocalizations.of(context).themeSwitch,
                icon: Theme.of(context).brightness == Brightness.light
                    ? Icons.brightness_2_outlined
                    : Icons.wb_sunny_outlined,
                onTap: () {
                  KanbanSimApp.of(context).switchTheme();
                  SubtleMessage.messageWithContext(
                    context,
                    AppLocalizations.of(context).themeSwitchSuccess,
                  );
                },
              ),
              MenuItem(
                title: AppLocalizations.of(context).langSwitch,
                icon: Icons.language_outlined,
                children: [
                  MenuItem(
                    title: AppLocalizations.of(context).englishLang,
                    onTap: () {
                      KanbanSimApp.of(context).switchLanguageTo("english");
                      SubtleMessage.messageWithContext(
                        context,
                        AppLocalizations.of(context).langSwitchSuccess,
                      );
                    },
                    children: [],
                  ),
                  MenuItem(
                    title: AppLocalizations.of(context).polishLang,
                    onTap: () {
                      KanbanSimApp.of(context).switchLanguageTo("polish");

                      SubtleMessage.messageWithContext(
                        context,
                        AppLocalizations.of(context).langSwitchSuccess,
                      );
                    },
                    children: [],
                  ),
                ],
              ),
              MenuItem(
                title: AppLocalizations.of(context).info,
                icon: Icons.info_outline_rounded,
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationVersion: '0.7.6',
                    applicationIcon: Icon(Icons.info_outline_rounded),
                    applicationLegalese:
                        AppLocalizations.of(context).applicationLegalese,
                    applicationName:
                        AppLocalizations.of(context).applicationName,
                  );
                },
              ),
              MenuItem(
                title: AppLocalizations.of(context).shareApp,
                icon: Icons.share,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text:
                          "https://kamilsztandur.github.io/KanbanMethodSimApp",
                    ),
                  );
                  SubtleMessage.messageWithContext(
                    context,
                    AppLocalizations.of(context).appLinkCopiedSuccessfully,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
