import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/sub_title.dart';

class TaskTitleCreator extends StatelessWidget {
  final Function(String) updateTitle;
  final Function getCurrentTitle;
  final double subWidth;

  TaskTitleCreator({
    Key key,
    @required this.subWidth,
    @required this.updateTitle,
    @required this.getCurrentTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.subWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTitle(title: AppLocalizations.of(context).setTitle + ":"),
          TextField(
            maxLength: 20,
            textAlign: TextAlign.left,
            maxLines: 1,
            onChanged: (String value) {
              this.updateTitle(value);
            },
            decoration: new InputDecoration(
              hintText: AppLocalizations.of(context).enterTaskTitleHere,
              labelStyle: new TextStyle(color: const Color(0xFF424242)),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
              border: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
