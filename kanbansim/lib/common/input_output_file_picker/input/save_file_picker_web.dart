import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/common/input_output_file_picker/input/filepicker_interface.dart';

class SaveFilePickerWeb implements FilePicker {
  final Function(String) returnPickedFilePath;
  FilePickerCross _filePickerCross;

  SaveFilePickerWeb({
    @required this.returnPickedFilePath,
  });

  Future<void> pickSaveFile() async {
    this._filePickerCross = await FilePickerCross.importFromStorage(
      type: FileTypeCross.custom,
      fileExtension: 'ksim',
    );

    this.returnPickedFilePath(this._filePickerCross.path);
  }
}
