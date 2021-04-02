import 'dart:typed_data';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class SaveFilePicker {
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

  static Directory getSaveFilesDirectory() {
    String appDirectoryPath = Directory.current.path;
    String subSavesDirectoryPath = Platform.pathSeparator + 'saves';
    String absoluteSavesDirPath = appDirectoryPath + subSavesDirectoryPath;

    List<int> pathAsList = absoluteSavesDirPath.codeUnits;
    Uint8List savesDirectoryRawPath = Uint8List.fromList(pathAsList);

    return Directory.fromRawPath(savesDirectoryRawPath);
  }

  void _selectFile() async {
    Directory savesDirectory = getSaveFilesDirectory();

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
