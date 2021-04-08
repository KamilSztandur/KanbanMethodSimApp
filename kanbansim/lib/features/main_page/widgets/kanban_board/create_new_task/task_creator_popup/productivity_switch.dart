import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_new_task/task_creator_popup/sub_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductivitySwitch extends StatefulWidget {
  final Function(int) updateProductivity;
  final int initialProductivity;

  ProductivitySwitch({
    Key key,
    @required this.initialProductivity,
    @required this.updateProductivity,
  }) : super(key: key);

  @override
  ProductivitySwitchState createState() => ProductivitySwitchState();
}

class ProductivitySwitchState extends State<ProductivitySwitch> {
  int _productivity;
  Color _rightArrowColor;
  Color _leftArrowColor;

  void setUp() {
    if (this._productivity == 0) {
      this._productivity = widget.initialProductivity;
    }
    _setArrowColors();
  }

  @override
  Widget build(BuildContext context) {
    setUp();

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SubTitle(
            title: AppLocalizations.of(context).setRequiredProductivity + ":",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left_outlined),
                color: this._leftArrowColor,
                iconSize: 50,
                onPressed: () {
                  setState(() {
                    _decreaseProductivityRequired();
                  });
                },
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '$_productivity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right_outlined),
                color: this._rightArrowColor,
                splashRadius: 15,
                splashColor: Theme.of(context).primaryColor,
                iconSize: 50,
                onPressed: () {
                  setState(() {
                    _increaseProductivityRequired();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _increaseProductivityRequired() {
    if (this._productivity + 1 <= 5) {
      this._productivity++;
    }

    this.widget.updateProductivity(this._productivity);
  }

  void _decreaseProductivityRequired() {
    if (this._productivity - 1 >= 1) {
      this._productivity--;
    }

    this.widget.updateProductivity(this._productivity);
  }

  void _setArrowColors() {
    if (this._productivity == null) {
      this._productivity = 1;
    }

    if (this._productivity == 1) {
      this._leftArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._leftArrowColor = Theme.of(context).primaryColor;
    }

    if (this._productivity == 5) {
      this._rightArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._rightArrowColor = Theme.of(context).primaryColor;
    }
  }
}
