import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:kanbansim/common/input_output_file_picker/filepicker_interface.dart';
import 'package:kanbansim/common/input_output_file_picker/input_output_supplier.dart';

class SaveFilePicker implements FilePicker {
  final Function(String) returnPickedFilePath;
  FileTileSelectMode filePickerSelectMode = FileTileSelectMode.wholeTile;
  BuildContext context;

  SaveFilePicker({
    @required this.returnPickedFilePath,
    @required this.context,
  });

  void pickSaveFile() {
    _selectFile();
  }

  void _selectFile() async {
    Directory savesDirectory = InputOutputSupplier.getSaveFilesDirectory();

    String path = await FilesystemPicker.open(
      title: AppLocalizations.of(context).selectFileToLoad,
      context: context,
      rootName: "${AppLocalizations.of(context).availableSaves}:",
      rootDirectory: savesDirectory,
      fsType: FilesystemType.file,
      folderIconColor: Theme.of(context).primaryColor,
      allowedExtensions: ['.ksim'],
      fileTileSelectMode: filePickerSelectMode,
    );

    this.returnPickedFilePath(path);
  }
}
