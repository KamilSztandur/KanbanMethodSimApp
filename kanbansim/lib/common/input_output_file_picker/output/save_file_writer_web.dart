import 'dart:convert';

import 'package:kanbansim/common/input_output_file_picker/input_output_supplier.dart';
import 'package:kanbansim/common/input_output_file_picker/output/filewriter_interface.dart';
import 'dart:html';

class SaveFileWriterWeb implements FileWriter {
  String _formattedFilename;
  Blob _file;
  String _url;
  AnchorElement _anchor;

  @override
  void saveFileAs(String filename, String content) async {
    _prepareFilename(filename);
    _prepareFile(content);
    _prepareAnchor();
    _downloadFile();
    _cleanUp();
  }

  @override
  bool isNameAlreadyTaken(String filename) {
    return false;
  }

  void _cleanUp() {
    document.body.children.remove(this._anchor);
    Url.revokeObjectUrl(this._url);
  }

  void _downloadFile() {
    this._anchor.click();
  }

  void _prepareAnchor() {
    this._url = Url.createObjectUrlFromBlob(this._file);

    this._anchor = document.createElement('a') as AnchorElement
      ..href = this._url
      ..style.display = 'none'
      ..download = this._formattedFilename;

    document.body.children.add(_anchor);
  }

  void _prepareFile(String content) {
    final bytes = utf8.encode(content);
    this._file = Blob([bytes]);
  }

  void _prepareFilename(String filename) {
    this._formattedFilename =
        InputOutputSupplier.formatFilename(filename) + ".ksim";
  }
}
