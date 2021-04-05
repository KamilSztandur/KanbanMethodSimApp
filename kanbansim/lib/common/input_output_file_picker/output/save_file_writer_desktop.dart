import 'package:kanbansim/common/input_output_file_picker/input_output_supplier.dart';
import 'package:kanbansim/common/input_output_file_picker/output/save_file_writer_interface.dart';
import 'dart:io';

class SaveFileWriterDesktop implements SaveFileWriterInterface {
  @override
  void saveFileAs(String filename, String content) async {
    File saveFile = File(
      _getSaveFilenameCompletePath(
        InputOutputSupplier.formatFilename(filename),
      ),
    );

    _writeToFile(saveFile, content);
  }

  bool isNameAlreadyTaken(String filename) {
    File tempSaveFile = File(
      _getSaveFilenameCompletePath(
        InputOutputSupplier.formatFilename(filename),
      ),
    );

    return tempSaveFile.existsSync();
  }

  void _writeToFile(File saveFile, String content) {
    saveFile.writeAsString(content);
  }

  String _getSaveFilenameCompletePath(String filename) {
    return InputOutputSupplier.getSaveFilesDirectory().path +
        Platform.pathSeparator +
        filename +
        ".ksim";
  }
}
