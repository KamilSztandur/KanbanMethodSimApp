import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/sub_title.dart';
import 'package:kanbansim/models/Task.dart';
import 'package:kanbansim/models/TaskType.dart';

class TaskTitleCreator extends StatefulWidget {
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
  _TaskTitleCreatorState createState() => _TaskTitleCreatorState();
}

class _TaskTitleCreatorState extends State<TaskTitleCreator> {
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    if(_controller == null) {
      _controller = TextEditingController();
    }
    
    return Container(
      width: this.widget.subWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTitle(title: AppLocalizations.of(context).setTitle + ":"),
          TextField(
            maxLength: 20,
            textAlign: TextAlign.left,
            maxLines: 1,
            onChanged: (String value) {
              this.widget.updateTitle(value);
            },
            controller: _controller,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 4,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _generateNameAutomatically();
                    });
                  },
                  child:
                      Text(AppLocalizations.of(context).generateAutomatically),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _generateNameAutomatically() {
    this._controller.text = "Task #" +
        Task.dummy().getLatestTaskID().toString();
  }
}
