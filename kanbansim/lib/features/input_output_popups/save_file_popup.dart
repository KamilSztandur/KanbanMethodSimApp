import 'package:flutter/material.dart';
import 'package:kanbansim/common/input_output_file_picker/output/save_file_writer.dart';
import 'package:intl/intl.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveFilePopup {
  Function(bool) returnSaveStatus;

  SaveFilePopup({
    this.returnSaveStatus,
  });

  Widget show(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.transparent,
      content: _SaveFilePage(
        returnSaveStatus: (bool status) {
          this.returnSaveStatus(status);
        },
      ),
    );
  }
}

class _SaveFilePage extends StatefulWidget {
  final Function(bool) returnSaveStatus;

  _SaveFilePage({
    Key key,
    @required this.returnSaveStatus,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SaveFilePageState();
}

class _SaveFilePageState extends State<_SaveFilePage> {
  TextEditingController _controller;
  SaveFileWriter creator;
  String warningMessage = '';
  String fileName = '';
  double _cornerRadius = 35;
  double _height = 300;
  double _width = 475;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getCurrentDateAsString() {
    DateTime currentTime = DateTime.now();
    String currentHour = '';

    if (currentTime.hour < 10) {
      currentHour += "0";
    }
    currentHour += currentTime.hour.toString() + ".";

    if (currentTime.minute < 10) {
      currentHour += "0";
    }
    currentHour += currentTime.minute.toString();

    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return currentHour + " " + formatter.format(currentTime);
  }

  void _generateNameAutomatically() {
    setState(() {
      this._controller.text = "${AppLocalizations.of(context).simulation} " +
          _getCurrentDateAsString();
    });
  }

  void _saveFile(String filename) {
    this.creator = SaveFileWriter();

    if (this.creator.isNameAlreadyTaken(filename)) {
      setState(() {
        this.warningMessage = AppLocalizations.of(context).filenameTaken;
      });
    } else if (this.creator.hasInvalidName(filename)) {
      setState(() {
        this.warningMessage = AppLocalizations.of(context).invalidFilename;
      });
    } else {
      this.creator.saveFileAs(filename, [1, 2, 3]);
      Navigator.of(context).pop();
      SubtleMessage.messageWithContext(
        context,
        '"$filename" ${AppLocalizations.of(context).savingSuccess}',
      );
    }
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_cornerRadius),
          topRight: Radius.circular(_cornerRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).saveCurrentSession,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputTextField() {
    return TextField(
      controller: _controller,
      textAlign: TextAlign.left,
      maxLines: 1,
      onSubmitted: (String value) {
        _saveFile(value);
      },
      decoration: new InputDecoration(
        hintText: AppLocalizations.of(context).enterSaveNameHere,
        labelText: "${AppLocalizations.of(context).filenameLabel}:",
        labelStyle: new TextStyle(color: const Color(0xFF424242)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          icon: Icon(Icons.send),
          color: Theme.of(context).primaryColor,
          focusColor: Theme.of(context).primaryColor,
          disabledColor: Theme.of(context).primaryColor,
          onPressed: (() {
            _saveFile(this._controller.text);
          }),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _buildSubTextFieldRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 4,
          child: TextButton(
            onPressed: () {
              _generateNameAutomatically();
            },
            child: Text(AppLocalizations.of(context).generateAutomatically),
          ),
        ),
        Flexible(flex: 1, child: Container()),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Text(
            this.warningMessage,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Row(
      children: [
        Flexible(flex: 5, child: Container()),
        Flexible(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
            ),
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ),
        Flexible(flex: 5, child: Container()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this._height,
      width: this._width,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade900,
        borderRadius: BorderRadius.all(Radius.circular(_cornerRadius)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: _buildTitle(),
          ),
          Flexible(
            flex: 2,
            child: Container(),
          ),
          Flexible(
            flex: 4,
            child: Container(
              width: this._width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputTextField(),
                  _buildSubTextFieldRow(),
                ],
              ),
            ),
          ),
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 2,
            child: _buildButton(),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
