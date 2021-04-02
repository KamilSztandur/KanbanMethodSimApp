import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum EventType {
  NEWTASK,
  LOCK,
  INFO,
  ERROR,
  DELETE,
}

class StoryNotification {
  final BuildContext context;
  final EventType type;
  final String message;
  double height;

  StoryNotification({
    @required this.type,
    @required this.message,
    @required this.context,
  });

  Icon _getIcon() {
    switch (this.type) {
      case EventType.NEWTASK:
        return Icon(Icons.post_add);

      case EventType.LOCK:
        return Icon(Icons.lock_rounded);

      case EventType.INFO:
        return Icon(Icons.info_outline_rounded);

      case EventType.ERROR:
        return Icon(Icons.error_outline_rounded);

      case EventType.DELETE:
        return Icon(Icons.delete_forever_outlined);

      default:
        return Icon(Icons.info_outline_rounded);
    }
  }

  String _getTitle() {
    switch (type) {
      case EventType.NEWTASK:
        return AppLocalizations.of(context).newTaskAppeared;

      case EventType.LOCK:
        return AppLocalizations.of(context).taskLocked;

      case EventType.INFO:
        return AppLocalizations.of(context).notice;

      case EventType.ERROR:
        return AppLocalizations.of(context).errorNotice;

      case EventType.DELETE:
        return AppLocalizations.of(context).elementDeleted;

      default:
        return AppLocalizations.of(context).info;
    }
  }

  void show() {
    this.height = this.message.length > 55 ? 100.0 : 75.0;

    showOverlayNotification(
      (context) {
        return SizedBox(
          height: this.height,
          width: 500,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: ListTile(
                leading: SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: ClipOval(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: IgnorePointer(
                        ignoring: true,
                        child: IconButton(
                          icon: _getIcon(),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(_getTitle()),
                subtitle: Text(this.message),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    OverlaySupportEntry.of(context).dismiss();
                  },
                ),
              ),
            ),
          ),
        );
      },
      duration: Duration(milliseconds: 4000),
    );
  }
}
