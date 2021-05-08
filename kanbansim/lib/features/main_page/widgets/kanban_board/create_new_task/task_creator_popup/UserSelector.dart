import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/sub_title.dart';

class UserSelector extends StatefulWidget {
  final Function(String) updateSelectedUserName;
  final List<String> names;
  final String ownerName;
  final String initialUserName;
  final double subWidth;

  UserSelector({
    Key key,
    @required this.subWidth,
    @required this.updateSelectedUserName,
    @required this.names,
    @required this.ownerName,
    @required this.initialUserName,
  }) : super(key: key);
  @override
  UserSelectorState createState() => UserSelectorState();
}

class UserSelectorState extends State<UserSelector> {
  String _selectedUser;

  @override
  Widget build(BuildContext context) {
    if (this._selectedUser == null) {
      _selectedUser = widget.initialUserName;
    }

    return Container(
      width: this.widget.subWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTitle(
            title: "${AppLocalizations.of(context).assignUser}:",
          ),
          DropdownButton<String>(
            value: _selectedUser,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 35,
            iconEnabledColor: Theme.of(context).primaryColor,
            isExpanded: true,
            underline: Container(
              height: 2,
              color: Theme.of(context).primaryColor,
            ),
            onChanged: (String newValue) {
              setState(() {
                _selectedUser = newValue;
                widget.updateSelectedUserName(_selectedUser);
              });
            },
            items: widget.names.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: value,
                        style: TextStyle(
                          color: _isOwner(value)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                    ),
                    _isOwner(value)
                        ? RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context).owner_CAP,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bool _isOwner(String name) {
    return this.widget.ownerName == name;
  }
}
