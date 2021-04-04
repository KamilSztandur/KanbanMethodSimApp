import 'package:flutter/material.dart';

abstract class FilePicker {
  FilePicker({
    @required this.returnPickedFilePath,
  });

  final Function(String) returnPickedFilePath;
  void pickSaveFile();
}
