import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:kanbansim/common/input_output_file_picker/save_file_picker.dart';
import 'package:kanbansim/features/notifications/feedback_popup.dart';

class LoadFilePopup {
  Function(String filePath) returnPickedFilepath;

  LoadFilePopup({
    this.returnPickedFilepath,
  });

  Widget show(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.grey.shade900,
      content: _LoadFilePage(
        returnPickedFilePath: (String filePath) {
          this.returnPickedFilepath(filePath);
        },
      ),
    );
  }
}

class _LoadFilePage extends StatefulWidget {
  final Function(String) returnPickedFilePath;
  String filePath;
  FilePickerCross filePickerCross;

  _LoadFilePage({
    Key key,
    this.filePath,
    @required this.returnPickedFilePath,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadFilePageState();
}

class _LoadFilePageState extends State<_LoadFilePage> {
  bool _readyToSubmit;
  SaveFilePicker _picker;

  void _initializePicker() {
    _picker = SaveFilePicker(
      context: context,
      returnPickedFilePath: (String filePath) {
        setState(() {
          this.widget.filePath = filePath;
        });
      },
    );
  }

  void _returnIfExists() {
    File saveFile = File(widget.filePath);
    if (saveFile.existsSync()) {
      this.widget.returnPickedFilePath(this.widget.filePath);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => FeedbackPopUp.show(
          context,
          "Save loading failed.",
          "File corrupted or recently deleted.",
        ),
      );
      this.widget.returnPickedFilePath(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializePicker();
    _readyToSubmit = this.widget.filePath != null;

    return Container(
      height: 250,
      width: 375,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Container(),
          ),
          Flexible(
            flex: 2,
            child: Text(
              "Select save file to load",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(),
          ),
          Flexible(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.filePath == null ? '' : widget.filePath,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.file_upload),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.grey.shade900,
                    onPressed: () {
                      _picker.pickSaveFile();
                    },
                  ),
                ),
              ],
            ),
          ),
          Flexible(flex: 3, child: Container()),
          Flexible(
            flex: 2,
            child: Row(
              children: [
                Flexible(flex: 2, child: Container()),
                Flexible(
                  flex: 3,
                  child: IgnorePointer(
                    ignoring: !this._readyToSubmit,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _returnIfExists();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          this._readyToSubmit
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).backgroundColor,
                        ),
                      ),
                      child: Text('Submit'),
                    ),
                  ),
                ),
                Flexible(flex: 4, child: Container()),
                Flexible(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
