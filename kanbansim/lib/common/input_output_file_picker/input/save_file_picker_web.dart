import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/common/input_output_file_picker/input/filepicker_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SaveFilePickerWeb implements FilePicker {
  final Function(String) returnPickedFilePath;
  final Function(String) returnPickedFileContent;
  FilePickerCross _filePickerCross;

  SaveFilePickerWeb({
    @required this.returnPickedFilePath,
    @required this.returnPickedFileContent,
  });

  Future<void> pickSaveFile() async {
    this._filePickerCross = await FilePickerCross.importFromStorage(
      type: FileTypeCross.custom,
      fileExtension: 'ksim',
    );

    this.returnPickedFilePath(this._filePickerCross.fileName);

    if(kIsWeb) {
      this.returnPickedFileContent(this._filePickerCross.toString());
    } else {
      this.returnPickedFileContent(null);
    }
  }
}
