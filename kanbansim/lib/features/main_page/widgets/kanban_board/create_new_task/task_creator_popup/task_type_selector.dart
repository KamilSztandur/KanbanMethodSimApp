import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/sub_title.dart';
import 'package:kanbansim/models/TaskType.dart';

class TaskTypeSelector extends StatefulWidget {
  final Function(TaskType) updateSelectedType;
  final TaskType initialTaskType;
  final double subWidth;

  TaskTypeSelector({
    Key key,
    @required this.subWidth,
    @required this.initialTaskType,
    @required this.updateSelectedType,
  }) : super(key: key);

  @override
  TaskTypeSelectorState createState() => TaskTypeSelectorState();
}

class TaskTypeSelectorState extends State<TaskTypeSelector> {
  String _selectedType;

  @override
  Widget build(BuildContext context) {
    List<String> types = _getAllTaskTypesNames();
    if (this._selectedType == null) {
      _selectedType = _getTaskTypeName(widget.initialTaskType);
    }

    return Container(
      width: this.widget.subWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTitle(
            title: AppLocalizations.of(context).setTaskTypeAs + ":",
          ),
          DropdownButton<String>(
            value: _selectedType,
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
                _selectedType = newValue;
                this.widget.updateSelectedType(
                      _getTypeFromString(_selectedType),
                    );
              });
            },
            items: types.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(_getTranslatedTaskTypeName(value)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  TaskType _getTypeFromString(String type) {
    return TaskType.values.firstWhere(
      (taskType) => taskType.toString().split('.').last == type,
    );
  }

  String _getTranslatedTaskTypeName(String type) {
    switch (type) {
      case "Standard":
        return AppLocalizations.of(context).standard;
        break;

      case "Expedite":
        return AppLocalizations.of(context).expedite;
        break;

      case "FixedDate":
        return AppLocalizations.of(context).fixedDate;
        break;

      default:
        return AppLocalizations.of(context).standard;
    }
  }

  List<String> _getAllTaskTypesNames() {
    List<String> types = <String>[];

    TaskType.values.forEach(
      (taskType) => types.add(
        _getTaskTypeName(taskType),
      ),
    );

    return types;
  }

  String _getTaskTypeName(TaskType type) {
    return type.toString().split('.').last;
  }
}
