import 'package:kanbansim/common/input_output_file_picker/input_output_supplier.dart';
import 'package:kanbansim/common/input_output_file_picker/output/filewriter_interface.dart';
import 'dart:io';

class SaveFileWriter implements FileWriter {
  Directory saveFilesDirectory;

  SaveFileWriter() {
    this.saveFilesDirectory = InputOutputSupplier.getSaveFilesDirectory();
  }

  @override
  void saveFileAs(String filename, String content) async {
    File saveFile = File(
      _getSaveFilenameCompletePath(
        InputOutputSupplier.formatFilename(filename),
      ),
    );

    _writeToFile(saveFile, content);
  }

  @override
  bool isNameAlreadyTaken(String filename) {
    File tempSaveFile = File(_getSaveFilenameCompletePath(
      InputOutputSupplier.formatFilename(filename),
    ));

    return tempSaveFile.existsSync();
  }

  void _writeToFile(File saveFile, String content) {
    saveFile.writeAsString(content);
  }

  String _getSaveFilenameCompletePath(String filename) {
    return this.saveFilesDirectory.path +
        Platform.pathSeparator +
        filename +
        ".ksim";
  }
}
