import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilenameReaderWidget extends StatefulWidget {
  final Function(String) checkIfReadyToSave;
  final Function getWarningMessage;
  final Function(String) saveFile;

  FilenameReaderWidget({
    Key key,
    @required this.saveFile,
    @required this.checkIfReadyToSave,
    @required this.getWarningMessage,
  }) : super(key: key);

  @override
  _FilenameReaderWidgetState createState() => _FilenameReaderWidgetState();
}

class _FilenameReaderWidgetState extends State<FilenameReaderWidget> {
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller = TextEditingController();
    }

    return Column(
      children: [
        TextField(
          textAlign: TextAlign.left,
          maxLines: 1,
          onChanged: (String value) {
            this.widget.checkIfReadyToSave(value);
          },
          onSubmitted: (String value) {
            this.widget.saveFile(value);
          },
          controller: _controller,
          decoration: new InputDecoration(
            hintText: AppLocalizations.of(context).enterSaveNameHere,
            labelText: "${AppLocalizations.of(context).filenameLabel}:",
            labelStyle: new TextStyle(color: const Color(0xFF424242)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                    this.widget.checkIfReadyToSave(_controller.text);
                  });
                },
                child: Text(AppLocalizations.of(context).generateAutomatically),
              ),
            ),
            Flexible(flex: 1, child: Container()),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Text(
                this.widget.getWarningMessage(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _generateNameAutomatically() {
    setState(() {
      this._controller.text = "${AppLocalizations.of(context).simulation} " +
          _getCurrentDateAsString();
    });
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
}
