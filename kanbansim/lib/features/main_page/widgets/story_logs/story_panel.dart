import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:expandable/expandable.dart';

class StoryPanel extends StatefulWidget {
  final List<String> messages;

  StoryPanel({Key key, @required this.messages})
      : assert(messages != null),
        super(key: key);

  @override
  StoryPanelState createState() => StoryPanelState();
}

class StoryPanelState extends State<StoryPanel> {
  ScrollController _scrollController = ScrollController();

  List<ListTile> _getTiles(BuildContext context) {
    List<ListTile> tiles = <ListTile>[];

    int length = this.widget.messages.length;
    for (int i = 0; i < length; i++) {
      tiles.add(
        ListTile(
          title: SelectableText(
            this.widget.messages[i],
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

  String _getLogsAsString() {
    String logs = "";
    this.widget.messages.forEach(
          (message) => logs += ("$message\n"),
        );

    return logs;
  }

  Widget _buildHeadline(BuildContext context) {
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

  Widget _buildLogs(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      height: (MediaQuery.of(context).size.height) * 0.75,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            height: (MediaQuery.of(context).size.height) * 0.7,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor.withOpacity(0.5),
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            child: Scrollbar(
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                children: _getTiles(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              Container(
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
                child: ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                    ),
                    header: _buildHeadline(context),
                    expanded: _buildLogs(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
