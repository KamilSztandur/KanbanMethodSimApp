import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kanbansim/features/input_output_popups/load_file_popup.dart';
import 'package:kanbansim/features/input_output_popups/save_file_popup.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';

class MainMenuBar extends StatelessWidget {
  final VoidCallback addRandomTasks;
  final VoidCallback clearAllTasks;
  final VoidCallback switchTheme;
  final Function(String) loadSimStateFromFilePath;
  final VoidCallback saveSimStateIntoFile;

  LoadFilePopup pickFilePopup;
  SaveFilePopup saveFilePopup;

  MainMenuBar({
    Key key,
    @required this.addRandomTasks,
    @required this.clearAllTasks,
    @required this.switchTheme,
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
  ConstrainedBox build(BuildContext context) {
    _initializeFilePickerPopup();
    _initializeFileSaverPopup();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100),
      child: PlutoMenuBar(
        backgroundColor: Theme.of(context).primaryColor,
        menuIconColor: Colors.white,
        textStyle: TextStyle(color: Colors.white),
        menus: [
          MenuItem(
            title: 'New session',
            icon: Icons.create_outlined,
            children: [
              MenuItem(
                title: 'Create empty',
                icon: Icons.create_new_folder_outlined,
                onTap: () {
                  SubtleMessage.messageWithContext(
                    context,
                    'Creating empty kanban...',
                  );
                },
              ),
              MenuItem(
                title: 'Select template',
                icon: Icons.file_copy_outlined,
                onTap: () {
                  SubtleMessage.messageWithContext(
                    context,
                    'Selecting session\'s template...',
                  );
                },
              ),
            ],
          ),
          MenuItem(
            title: 'Load session',
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
            title: 'Save current session',
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
            title: 'Add random tasks',
            icon: Icons.library_add_outlined,
            onTap: () {
              this.addRandomTasks();

              SubtleMessage.messageWithContext(
                context,
                "Sucessfully added few random tasks.",
              );
            },
          ),
          MenuItem(
            title: 'Clear all columns',
            icon: Icons.delete_forever_outlined,
            onTap: () {
              this.clearAllTasks();

              SubtleMessage.messageWithContext(
                context,
                "Sucessfully cleared all tasks.",
              );
            },
          ),
          MenuItem(
            title: 'Switch theme',
            icon: Theme.of(context).brightness == Brightness.light
                ? Icons.brightness_2_outlined
                : Icons.wb_sunny_outlined,
            onTap: () {
              this.switchTheme();

              SubtleMessage.messageWithContext(
                context,
                "Theme switched successfully.",
              );
            },
          ),
          MenuItem(
            title: 'Info',
            icon: Icons.help_outline_outlined,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationVersion: '0.1.6',
                applicationIcon: Icon(Icons.info_outline_rounded),
                applicationLegalese:
                    'For education purposes only.\nDeveloped by Kamil Sztandur.\nContact: kamil.sztandur@vp.pl.',
                applicationName: "Kanban Method's simulator",
              );
            },
          ),
          MenuItem(
            title: 'Quit',
            icon: Icons.close_outlined,
            onTap: () => exit(0),
          ),
        ],
      ),
    );
  }
}
