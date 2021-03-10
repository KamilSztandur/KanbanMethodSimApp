import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';

class MainMenuBar extends StatelessWidget {
  //MainMenuBar({Key key, @required this.parent, @required this.scaffoldKey})
  //    : super(key: key);
  //final scaffoldKey;

  MainMenuBar(MainPageState parent) {
    this.parent = parent;
  }

  MainPageState parent;

  @override
  ConstrainedBox build(BuildContext context) {
    var kanbanBoard = this.parent.kanbanBoard.child;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100),
      child: PlutoMenuBar(
        backgroundColor: Theme.of(context).primaryColor,
        borderColor: Colors.white,
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
              SubtleMessage.messageWithContext(
                context,
                'Select session to load.',
              );
            },
          ),
          MenuItem(
            title: 'Save current session',
            icon: Icons.save_outlined,
            onTap: () {
              SubtleMessage.messageWithContext(
                context,
                'Saving...',
              );
            },
          ),
          MenuItem(
            title: 'Add random tasks',
            icon: Icons.library_add_outlined,
            onTap: () {
              kanbanBoard.addRandomTasksForAllColumns();
            },
          ),
          MenuItem(
            title: 'Clear all columns',
            icon: Icons.delete_forever_outlined,
            onTap: () {
              try {
                kanbanBoard.clearAllTasks();
              } catch (NoSuchMethodError) {
                SubtleMessage.messageWithContext(
                  context,
                  'Wystąpił nieoczekiwany błąd...',
                );
              }
            },
          ),
          MenuItem(
            title: 'Help',
            icon: Icons.help_outline_outlined,
            onTap: () {
              SubtleMessage.messageWithContext(
                context,
                'Opening help guide...',
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
