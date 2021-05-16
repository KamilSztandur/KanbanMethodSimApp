import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanbansim/features/input_output_popups/load_file_popup.dart';
import 'package:kanbansim/features/input_output_popups/save_file_popup.dart';
import 'package:kanbansim/features/main_page/widgets/confirm_returning_to_welcome_page_popup.dart';
import 'package:kanbansim/features/main_page/widgets/modify_column_limits_popup.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/features/window_bar.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenuBar extends StatelessWidget {
  final VoidCallback resetSimulation;
  final Function(String) loadSimStateFromPickedData;
  final Function(int) stageOneInProgressLimitChanged;
  final Function(int) stageOneDoneLimitChanged;
  final Function(int) stageTwoLimitChanged;
  final Function getSimState;

  MainMenuBar({
    Key key,
    @required this.resetSimulation,
    @required this.loadSimStateFromPickedData,
    @required this.stageTwoLimitChanged,
    @required this.stageOneDoneLimitChanged,
    @required this.stageOneInProgressLimitChanged,
    @required this.getSimState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: KanbanSimApp.of(context).isWeb() ? 45 : 76,
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
          KanbanSimApp.of(context).isWeb() ? Container() : WindowBar(),
          _ToolBar(
            resetSimulation: this.resetSimulation,
            loadSimStateFromPickedData: this.loadSimStateFromPickedData,
            stageOneInProgressLimitChanged: this.stageOneInProgressLimitChanged,
            stageTwoLimitChanged: this.stageTwoLimitChanged,
            stageOneDoneLimitChanged: this.stageOneDoneLimitChanged,
            getSimState: this.getSimState,
          ),
        ],
      ),
    );
  }
}

class _ToolBar extends StatelessWidget {
  final VoidCallback resetSimulation;
  final Function(String) loadSimStateFromPickedData;
  final Function(int) stageOneInProgressLimitChanged;
  final Function(int) stageOneDoneLimitChanged;
  final Function(int) stageTwoLimitChanged;
  final Function getSimState;

  LoadFilePopup pickFilePopup;
  SaveFilePopup saveFilePopup;

  _ToolBar({
    Key key,
    @required this.resetSimulation,
    @required this.loadSimStateFromPickedData,
    @required this.stageTwoLimitChanged,
    @required this.stageOneDoneLimitChanged,
    @required this.stageOneInProgressLimitChanged,
    @required this.getSimState,
  }) : super(key: key);

  void _initializeFilePickerPopup() {
    pickFilePopup = LoadFilePopup(
      returnPickedFileContent: (String content) {
        this.loadSimStateFromPickedData(content);
      },
    );
  }

  void _initializeFileSaverPopup() {
    saveFilePopup = SaveFilePopup(getSimState: this.getSimState);
  }

  @override
  Widget build(BuildContext context) {
    _initializeFilePickerPopup();
    _initializeFileSaverPopup();

    return PlutoMenuBar(
      backgroundColor: Colors.blueAccent.withOpacity(0.8),
      menuIconColor: Colors.white,
      textStyle: TextStyle(color: Colors.white),
      menus: [
        MenuItem(
          title: AppLocalizations.of(context).simulation,
          icon: Icons.sticky_note_2_outlined,
          children: [
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
              title: AppLocalizations.of(context).resetSession,
              icon: Icons.delete_forever_outlined,
              onTap: () {
                this.resetSimulation();

                SubtleMessage.messageWithContext(
                  context,
                  AppLocalizations.of(context).resetSessionSuccess,
                );
              },
            ),
            MenuItem(
              title: AppLocalizations.of(context).returnToTitleScreen,
              icon: Icons.exit_to_app,
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    ConfirmReturningToWelcomePagePopup().show(),
              ),
            ),
          ],
        ),
        MenuItem(
          title: AppLocalizations.of(context).limits,
          icon: Icons.list,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => ModifyColumnLimitsPopup(
                stageOneInProgressLimitChanged:
                    this.stageOneInProgressLimitChanged,
                stageOneDoneLimitChanged: this.stageOneDoneLimitChanged,
                stageTwoLimitChanged: this.stageTwoLimitChanged,
                stageOneInProgressLimit:
                    this.getSimState().stageOneInProgressColumnLimit,
                stageOneDoneLimit: this.getSimState().stageOneDoneColumnLimit,
                stageTwoLimit: this.getSimState().stageTwoColumnLimit,
              ).show(context),
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
            ),
          ],
        ),
        MenuItem(
          title: AppLocalizations.of(context).info,
          icon: Icons.info_outline_rounded,
          onTap: () {
            String platform = _getPlatformName(context).toUpperCase();
            showAboutDialog(
              context: context,
              applicationVersion: '1.0.0-$platform',
              applicationIcon: Icon(Icons.info_outline_rounded),
              applicationLegalese:
                  AppLocalizations.of(context).applicationLegalese,
              applicationName: AppLocalizations.of(context).applicationName,
            );
          },
        ),
        MenuItem(
          title: AppLocalizations.of(context).shareApp,
          icon: Icons.share,
          onTap: () {
            Clipboard.setData(
              ClipboardData(
                text: "https://kamilsztandur.github.io/KanbanMethodSimApp",
              ),
            );
            SubtleMessage.messageWithContext(
              context,
              AppLocalizations.of(context).appLinkCopiedSuccessfully,
            );
          },
        ),
      ],
    );
  }

  String _getPlatformName(BuildContext context) {
    if (KanbanSimApp.of(context).isWeb()) {
      return "web";
    } else {
      return "desktop";
    }
  }
}
