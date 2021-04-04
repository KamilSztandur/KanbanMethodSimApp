import 'package:kanbansim/common/input_output_file_picker/input_output_supplier.dart';
import 'dart:io';

class SaveFileWriter {
  Directory saveFilesDirectory;

  SaveFileWriter() {
    this.saveFilesDirectory = InputOutputSupplier.getSaveFilesDirectory();
  }

  void saveFileAs(String filename, List<int> content) async {
    File saveFile = File(
      _getSaveFilenameCompletePath(_formatFilename(filename)),
    );

    _writeToFile(saveFile, content);
  }

  bool isNameAlreadyTaken(String filename) {
    File tempSaveFile = File(_getSaveFilenameCompletePath(
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

  void _writeToFile(File saveFile, List<int> content) {
    saveFile.writeAsBytes(content);
  }

  String _getSaveFilenameCompletePath(String filename) {
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
}
