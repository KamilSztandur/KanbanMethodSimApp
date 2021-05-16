import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:kanbansim/models/User.dart';

class UserCreatorPopup {
  final Function(String) isNameAlreadyTaken;
  final Function(User) userCreated;
  final List<ColorSwatch<dynamic>> availableColors;
  final List<String> availableNames;

  UserCreatorPopup({
    @required this.isNameAlreadyTaken,
    @required this.userCreated,
    @required this.availableColors,
    @required this.availableNames,
  });

  Widget show({Function() usersCreated}) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _UserCreator(
        isNameAlreadyTaken: this.isNameAlreadyTaken,
        userCreated: this.userCreated,
        availableColors: this.availableColors,
        availableNames: this.availableNames,
      ),
    );
  }
}

class _UserCreator extends StatefulWidget {
  final Function(String) isNameAlreadyTaken;
  final Function(User) userCreated;
  final List<ColorSwatch<dynamic>> availableColors;
  final List<String> availableNames;

  _UserCreator({
    Key key,
    @required this.isNameAlreadyTaken,
    @required this.userCreated,
    @required this.availableColors,
    @required this.availableNames,
  }) : super(key: key);

  @override
  _UserCreatorState createState() => _UserCreatorState();
}

class _UserCreatorState extends State<_UserCreator> {
  String _name;
  int _productivity;
  Color _color;

  @override
  Widget build(BuildContext context) {
    _initializeDefaultValuesIfNeeded();

    return Container(
      height: 600,
      width: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).accentColor
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        border: Border.all(color: Theme.of(context).primaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _Headline(cornerRadius: 10),
          SizedBox(height: 15),
          UserNameCreator(
            possibleNames: this.widget.availableNames,
            isNameAlreadyTaken: this.widget.isNameAlreadyTaken,
            nameChanged: (String name) {
              setState(() {
                this._name = name;
              });
            },
          ),
          SizedBox(height: 15),
          _WindowDivider(),
          SizedBox(height: 15),
          _ProductivitySwitch(
            selectedProductivity: this._productivity,
            productivityChanged: (int productivity) {
              setState(() {
                this._productivity = productivity;
              });
            },
          ),
          SizedBox(height: 15),
          _WindowDivider(),
          SizedBox(height: 15),
          _ColorPicker(
            colors: this.widget.availableColors,
            selectedColor: this._color,
            colorChanged: (Color color) {
              setState(() {
                this._color = color;
              });
            },
          ),
          SizedBox(height: 15),
          _WindowDivider(),
          SizedBox(height: 18),
          _Buttons(
            createButtonClicked: () {
              this.widget.userCreated(
                    User(this._name, this._productivity, this._color),
                  );
            },
            readyToCreate: _isReadyToCreate(),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  bool _isReadyToCreate() {
    if (this._name == null || this._name == "") {
      return false;
    } else if (this.widget.isNameAlreadyTaken(this._name)) {
      return false;
    } else if (this._color == null) {
      return false;
    } else {
      return true;
    }
  }

  void _initializeDefaultValuesIfNeeded() {
    if (this._color == null) {
      int randIndex = Random().nextInt(this.widget.availableColors.length);
      this._color = this.widget.availableColors[randIndex];
    }

    if (this._productivity == null) {
      this._productivity = 5;
    }
  }
}

class _Headline extends StatelessWidget {
  final double cornerRadius;

  _Headline({Key key, @required this.cornerRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(this.cornerRadius),
          topRight: Radius.circular(this.cornerRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).userCreator,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorPicker extends StatefulWidget {
  final Function(Color) colorChanged;
  final List<ColorSwatch<dynamic>> colors;
  Color selectedColor;

  _ColorPicker({
    Key key,
    @required this.colorChanged,
    @required this.colors,
    @required this.selectedColor,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${AppLocalizations.of(context).chooseUserColor}:",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Container(
            height: 125,
            width: 275,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              border: Border.all(color: Theme.of(context).primaryColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: MaterialColorPicker(
              allowShades: false,
              circleSize: 250,
              colors: this.widget.colors,
              selectedColor: this.widget.selectedColor,
              onMainColorChange: (ColorSwatch color) {
                this.widget.colorChanged(color);
                setState(() {
                  this.widget.selectedColor = color;
                });
              },
            ),
          ),
        )
      ],
    );
  }
}

class _ProductivitySwitch extends StatefulWidget {
  final Function(int) productivityChanged;
  int selectedProductivity;

  _ProductivitySwitch({
    Key key,
    @required this.productivityChanged,
    @required this.selectedProductivity,
  }) : super(key: key);

  @override
  _ProductivitySwitchState createState() => _ProductivitySwitchState();
}

class _ProductivitySwitchState extends State<_ProductivitySwitch> {
  Color _rightArrowColor;
  Color _leftArrowColor;

  @override
  Widget build(BuildContext context) {
    _setArrowColors();

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${AppLocalizations.of(context).chooseProductivity}:",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left_outlined),
                color: this._leftArrowColor,
                iconSize: 50,
                onPressed: () {
                  _decreaseProductivity();
                },
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '${this.widget.selectedProductivity}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
                  _increaseProductivity();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _increaseProductivity() {
    if (this.widget.selectedProductivity + 1 <= 5) {
      this.widget.selectedProductivity++;
      this.widget.productivityChanged(this.widget.selectedProductivity);
    }
  }

  void _decreaseProductivity() {
    if (this.widget.selectedProductivity - 1 >= 1) {
      this.widget.selectedProductivity--;
      this.widget.productivityChanged(this.widget.selectedProductivity);
    }
  }

  void _setArrowColors() {
    if (this.widget.selectedProductivity == null) {
      this.widget.selectedProductivity = 1;
    }

    if (this.widget.selectedProductivity == 1) {
      this._leftArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._leftArrowColor = Theme.of(context).primaryColor;
    }

    if (this.widget.selectedProductivity == 5) {
      this._rightArrowColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else {
      this._rightArrowColor = Theme.of(context).primaryColor;
    }
  }
}

class UserNameCreator extends StatefulWidget {
  final Function(String) isNameAlreadyTaken;
  final Function(String) nameChanged;
  final List<String> possibleNames;

  UserNameCreator({
    Key key,
    @required this.isNameAlreadyTaken,
    @required this.nameChanged,
    @required this.possibleNames,
  }) : super(key: key);

  @override
  _UserNameCreatorState createState() => _UserNameCreatorState();
}

class _UserNameCreatorState extends State<UserNameCreator> {
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller = TextEditingController();
    }

    return Container(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${AppLocalizations.of(context).chooseUserNickname}:",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          IgnorePointer(
            ignoring: !KanbanSimApp.of(context).isWeb(),
            child: TextField(
              maxLength: 10,
              textAlign: TextAlign.left,
              maxLines: 1,
              onChanged: (String value) {
                this.widget.nameChanged(value);
              },
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
              ),
              controller: _controller,
              inputFormatters: [
                FilteringTextInputFormatter(
                  RegExp("[a-zA-Z0-9-#-' ']"),
                  allow: true,
                ),
              ],
              decoration: InputDecoration(
                counterStyle: TextStyle(color: Theme.of(context).primaryColor),
                counter: KanbanSimApp.of(context).isWeb()
                    ? TextField().decoration.counter
                    : Offstage(),
                hintText: KanbanSimApp.of(context).isWeb()
                    ? AppLocalizations.of(context).enterUserNicknameHere
                    : "",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
                labelStyle: new TextStyle(color: const Color(0xFF424242)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  _generateNameAutomatically();
                },
                child: Text(
                  AppLocalizations.of(context).generateAutomatically,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              this.widget.isNameAlreadyTaken(_controller.text)
                  ? _NameAlreadyTakenWarning()
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  void _generateNameAutomatically() {
    int randIndex = Random().nextInt(this.widget.possibleNames.length);
    this._controller.text = this.widget.possibleNames[randIndex];
    this.widget.nameChanged(this._controller.text);
  }
}

class _NameAlreadyTakenWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "${AppLocalizations.of(context).usernameIsAlreadyTakenWarning}.",
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Function createButtonClicked;
  final bool readyToCreate;

  _Buttons({
    Key key,
    @required this.readyToCreate,
    @required this.createButtonClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 6,
          child: Container(),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: IgnorePointer(
            ignoring: !readyToCreate,
            child: ElevatedButton(
              onPressed: () {
                this.createButtonClicked();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).create),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  this.readyToCreate
                      ? Colors.green
                      : Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(),
        ),
      ],
    );
  }
}

class _WindowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2.5,
      child: Container(color: Colors.black.withOpacity(0.2)),
    );
  }
}
