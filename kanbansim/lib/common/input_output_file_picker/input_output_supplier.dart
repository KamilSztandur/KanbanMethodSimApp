import 'dart:io';
import 'dart:typed_data';

class InputOutputSupplier {
  static Directory getSaveFilesDirectory() {
    String appDirectoryPath = Directory.current.path;
    String subSavesDirectoryPath = Platform.pathSeparator + 'saves';
    String absoluteSavesDirPath = appDirectoryPath + subSavesDirectoryPath;

    List<int> pathAsList = absoluteSavesDirPath.codeUnits;
    Uint8List savesDirectoryRawPath = Uint8List.fromList(pathAsList);

    return Directory.fromRawPath(savesDirectoryRawPath);
  }
}
