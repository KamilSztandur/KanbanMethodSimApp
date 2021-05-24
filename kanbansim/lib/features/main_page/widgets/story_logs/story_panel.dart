import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoryPanelPopup {
  List<String> messages;

  StoryPanelPopup({
    @required this.messages,
  });

  Widget show(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _StoryPanel(messages: this.messages),
    );
  }
}

class _StoryPanel extends StatelessWidget {
  final List<String> messages;

  _StoryPanel({
    @required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 455,
      width: 800,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).accentColor
            : Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Column(
        children: [
          _Headline(messages: this.messages),
          _Logs(messages: this.messages),
        ],
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  final List<String> messages;

  _Headline({Key key, @required this.messages})
      : assert(messages != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).events,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.copy_outlined),
          iconSize: 17,
          color: Theme.of(context).primaryColor,
          tooltip: AppLocalizations.of(context).copyLogsToClipboardhint,
          splashColor: Colors.transparent,
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: _getLogsAsString(),
              ),
            );

            SubtleMessage.messageWithContext(
              context,
              AppLocalizations.of(context).logsCopiedSuccessfully,
            );
          },
        ),
      ],
    );
  }

  String _getLogsAsString() {
    String logs = "";
    this.messages.forEach(
          (message) => logs += ("$message\n"),
        );

    return logs;
  }
}

class _Logs extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  final List<String> messages;

  _Logs({Key key, @required this.messages})
      : assert(messages != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 8,
      ),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          ),
        ),
        child: Scrollbar(
          controller: _scrollController,
          child: ListView(
            shrinkWrap: true,
            controller: _scrollController,
            children: _getTiles(context),
          ),
        ),
      ),
    );
  }

  List<ListTile> _getTiles(BuildContext context) {
    List<ListTile> tiles = <ListTile>[];

    int length = this.messages.length;
    if (length == 0) {
      return tiles;
    } else {
      tiles.add(
        ListTile(
          title: Container(
            height: 1,
            width: MediaQuery.of(context).size.height,
            color: Theme.of(context).hintColor,
          ),
        ),
      );

      for (int i = length - 1; i >= 0; i--) {
        tiles.add(
          ListTile(
            title: SelectableText(
              this.messages[i],
            ),
          ),
        );
        tiles.add(
          ListTile(
            title: Container(
              height: 1,
              width: MediaQuery.of(context).size.height,
              color: Theme.of(context).hintColor,
            ),
          ),
        );
      }

      return tiles;
    }
  }
}
