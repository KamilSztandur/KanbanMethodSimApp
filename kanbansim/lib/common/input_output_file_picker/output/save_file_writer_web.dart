import 'dart:convert';
import 'package:kanbansim/common/input_output_file_picker/input_output_supplier.dart';
import 'package:kanbansim/common/input_output_file_picker/output/save_file_writer_interface.dart';
import 'package:universal_html/html.dart' as html;

class SaveFileWriterWeb implements SaveFileWriter {
  String _formattedFilename;
  html.Blob _file;
  String _url;
  html.AnchorElement _anchor;

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
    html.document.body.children.remove(this._anchor);
    html.Url.revokeObjectUrl(this._url);
  }

  void _downloadFile() {
    this._anchor.click();
  }

  void _prepareAnchor() {
    this._url = html.Url.createObjectUrlFromBlob(this._file);

    this._anchor = html.document.createElement('a') as html.AnchorElement
      ..href = this._url
      ..style.display = 'none'
      ..download = this._formattedFilename;

    html.document.body.children.add(_anchor);
  }

  void _prepareFile(String content) {
    final bytes = utf8.encode(content);
    this._file = html.Blob([bytes]);
  }

  void _prepareFilename(String filename) {
    this._formattedFilename =
        InputOutputSupplier.formatFilename(filename) + ".ksim";
  }
}
