import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/story_logs/story_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogsButton extends StatelessWidget {
  final List<String> messages;

  LogsButton({
    Key key,
    @required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(
        AppLocalizations.of(context).events,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).primaryColor
              : Colors.white,
        ),
      ),
      elevation: 0.0,
      focusElevation: 0.0,
      hoverElevation: 0.0,
      disabledElevation: 0.0,
      highlightElevation: 0.0,
      shape: StadiumBorder(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
      ),
      icon: Icon(
        Icons.reorder,
        size: 30,
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColor
            : Colors.white,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColor.withOpacity(0.3)
          : Theme.of(context).primaryColor,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              StoryPanelPopup(messages: this.messages).show(context),
        );
      },
    );
  }
}
