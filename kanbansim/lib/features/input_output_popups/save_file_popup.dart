import 'package:flutter/material.dart';
import 'package:kanbansim/common/input_output_file_picker/save_file_writer.dart';
import 'package:intl/intl.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';

class SaveFilePopup {
  Function(bool) returnSaveStatus;

  SaveFilePopup({
    this.returnSaveStatus,
  });

  Widget show(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.grey.shade900,
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
    String currentHour = currentTime.hour.toString() + ".";
    if (currentTime.minute < 10) {
      currentHour += "0";
    }
    currentHour += currentTime.minute.toString();

    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return currentHour + " " + formatter.format(currentTime);
  }

  void _generateNameAutomatically() {
    setState(() {
      this._controller.text = "Symulation " + _getCurrentDateAsString();
    });
  }

  void _saveFile(String filename) {
    this.creator = SaveFileWriter();

    if (this.creator.isNameAlreadyTaken(filename)) {
      setState(() {
        this.warningMessage = "Filename already taken!";
      });
    } else if (this.creator.hasInvalidName(filename)) {
      setState(() {
        this.warningMessage = "Invalid filename.";
      });
    } else {
      this.creator.saveFileAs(filename, [1, 2, 3]);
      Navigator.of(context).pop();
      SubtleMessage.messageWithContext(
        context,
        '"$filename" session saved successfully.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 475,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              "Save current simulation's state",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(),
          ),
          Flexible(
            flex: 4,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.left,
              maxLines: 1,
              onSubmitted: (String value) {
                _saveFile(value);
              },
              decoration: new InputDecoration(
                hintText: "Enter you savefile name here",
                labelText: "Filename:",
                labelStyle: new TextStyle(color: const Color(0xFF424242)),
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
          ),
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: TextButton(
                    onPressed: () {
                      _generateNameAutomatically();
                    },
                    child: Text('Generate automatically'),
                  ),
                ),
                Flexible(flex: 1, child: Container()),
                Flexible(
                  flex: 2,
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
            ),
          ),
          Flexible(flex: 2, child: Container()),
          Flexible(
            flex: 2,
            child: Row(
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
                    child: Text('cancel'),
                  ),
                ),
                Flexible(flex: 5, child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
