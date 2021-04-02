import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoryPanel extends StatelessWidget {
  final List<String> messages;
  ScrollController _scrollController = new ScrollController();

  StoryPanel({Key key, @required this.messages})
      : assert(messages != null),
        super(key: key);

  List<ListTile> _getTiles(BuildContext context) {
    List<ListTile> tiles = <ListTile>[];

    int length = this.messages.length;
    for (int i = 0; i < length; i++) {
      tiles.add(
        ListTile(
          title: Text(messages[i]),
          tileColor: Theme.of(context).primaryColor.withOpacity(
                i % 2 == 0 ? 0.2 : 0.0,
              ),
        ),
      );
    }

    return tiles;
  }

  String _getLogsAsString() {
    String logs = "";
    messages.forEach(
      (message) => logs += ("$message\n"),
    );

    return logs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      height: (MediaQuery.of(context).size.height) * 0.17,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        border: Border.all(
          width: 2.0,
          color: Colors.black.withOpacity(
            Theme.of(context).brightness == Brightness.light ? 0.3 : 0.5,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 2,
            child: Row(
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
            ),
          ),
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 10,
            child: Container(
              height: (MediaQuery.of(context).size.height) * 0.13,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withOpacity(0.2),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0),
                ),
              ),
              child: Scrollbar(
                child: ListView(
                  controller: _scrollController,
                  children: _getTiles(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
