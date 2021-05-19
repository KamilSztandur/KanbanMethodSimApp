import 'package:flutter/material.dart';
import 'package:kanbansim/common/input_output_file_picker/input/filepicker_interface.dart';
import 'package:kanbansim/common/input_output_file_picker/input/save_file_picker_desktop.dart';
import 'package:kanbansim/common/input_output_file_picker/input/save_file_picker_web.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'dart:io';

class FilePickerWidget extends StatefulWidget {
  final Function(String) pathIsPicked;
  final Function(String) contentIsPicked;
  String filePath;
  FilePicker filePicker;
  double width;

  FilePickerWidget({
    Key key,
    @required this.width,
    @required this.filePath,
    @required this.pathIsPicked,
    @required this.contentIsPicked,
  }) : super(key: key);

  @override
  FilePickerWidgetState createState() => FilePickerWidgetState();
}

class FilePickerWidgetState extends State<FilePickerWidget> {
  @override
  void initState() {
    super.initState();
    _initializePicker(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 35,
          width: this.widget.width * 0.7,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.widget.filePath == null ? '' : this.widget.filePath,
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
              widget.filePicker.pickSaveFile();
            },
          ),
        ),
      ],
    );
  }

  void _initializePicker(BuildContext context) {
    if (KanbanSimApp.of(context).isWeb()) {
      this.widget.filePicker = SaveFilePickerWeb(
        returnPickedFilePath: (String filePath) {
          setState(() {
            this.widget.filePath = filePath;
          });

          this.widget.pathIsPicked(this.widget.filePath);
        },
        returnPickedFileContent: (String fileContent) =>
            this.widget.contentIsPicked(fileContent),
      );
    } else {
      this.widget.filePicker = SaveFilePickerDesktop(
        context: context,
        returnPickedFilePath: (String filePath) {
          setState(() {
            this.widget.filePath = filePath;
          });

          _readAndSaveFileContent(filePath);
          this.widget.pathIsPicked(this.widget.filePath);
        },
      );
    }
  }

  void _readAndSaveFileContent(String path) {
    File loadedSavefile = File(path);

    var reader = loadedSavefile.openRead();
    loadedSavefile.readAsString().then(
      (String data) {
        this.widget.contentIsPicked(data);
      },
    );
  }
}
