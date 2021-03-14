import 'package:kanbansim/common/input_output_file_picker/save_file_picker.dart';

import 'dart:io';

class SaveFileWriter {
  Directory saveFilesDirectory;

  SaveFileWriter() {
    this.saveFilesDirectory = SaveFilePicker.getSaveFilesDirectory();
  }

  String getSaveFilenameCompletePath(String filename) {
    return this.saveFilesDirectory.path +
        Platform.pathSeparator +
        filename +
        ".ksim";
  }

  String _formatFilename(String filename) {
    String fixedFilename = filename
        .replaceAll(':', '_')
        .replaceAll('/', '_')
        .replaceAll('\\', '_')
        .replaceAll('\$', '_')
        .replaceAll(' ', '_');

    return fixedFilename;
  }

  void saveFileAs(String filename, List<int> content) async {
    File saveFile = File(
      getSaveFilenameCompletePath(_formatFilename(filename)),
    );

    writeToFile(saveFile, content);
  }

  void writeToFile(File saveFile, List<int> content) {
    saveFile.writeAsBytes(content);
  }

  bool isNameAlreadyTaken(String filename) {
    File tempSaveFile = File(getSaveFilenameCompletePath(
      _formatFilename(filename),
    ));

    return tempSaveFile.existsSync();
  }

  bool hasInvalidName(String filename) {
    if (filename == '') {
      return true;
    }

    return false;
  }
}
