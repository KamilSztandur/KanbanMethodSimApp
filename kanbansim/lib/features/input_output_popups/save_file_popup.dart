import 'package:flutter/material.dart';
import 'package:kanbansim/common/input_output_file_picker/input_output_supplier.dart';
import 'package:kanbansim/common/input_output_file_picker/output/save_file_writer_desktop.dart';
import 'package:kanbansim/common/input_output_file_picker/output/save_file_writer_interface.dart';
import 'package:kanbansim/common/input_output_file_picker/output/save_file_writer_web.dart';
import 'package:kanbansim/features/input_output_popups/filename_reader_widget.dart';

import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/kanban_sim_app.dart';

class SaveFilePopup {
  Function(bool) returnSaveStatus;

  SaveFilePopup({
    this.returnSaveStatus,
  });

  Widget show(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.transparent,
      content: _SaveFilePage(
        returnSaveStatus: (bool status) {
          this.returnSaveStatus(status);
        },
      ),
    );
  }
}

class _SaveFilePage extends StatefulWidget {
  final Function(bool) returnSaveStatus;

  _SaveFilePage({
    Key key,
    @required this.returnSaveStatus,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SaveFilePageState();
}

class _SaveFilePageState extends State<_SaveFilePage> {
  SaveFileWriter creator;
  String warningMessage = '';
  String fileName = '';
  double _cornerRadius = 35;
  double _height = 300;
  double _width = 475;
  bool _readyToSave;

  @override
  void initState() {
    if (_readyToSave == null) {
      this._readyToSave = false;
    }

    super.initState();
    _initializeWriter();
  }

  void _initializeWriter() {
    if (KanbanSimApp.of(context).isWeb()) {
      this.creator = SaveFileWriterWeb();
    } else {
      this.creator = SaveFileWriterDesktop();
    }
  }

  bool _checkIfFilenameIsValid(String filename) {
    if (this.creator.isNameAlreadyTaken(filename)) {
      setState(() {
        this.warningMessage = AppLocalizations.of(context).filenameTaken;
      });
      return false;
    } else if (InputOutputSupplier.hasInvalidName(filename)) {
      setState(() {
        this.warningMessage = AppLocalizations.of(context).invalidFilename;
      });
      return false;
    } else {
      setState(() {
        this.warningMessage = '';
      });
      return true;
    }
  }

  void _checkIfReadyToSave() {
    setState(() {
      this._readyToSave = _checkIfFilenameIsValid(this.fileName);
    });
  }

  void _saveFile(String filename) {
    if (_checkIfFilenameIsValid(filename)) {
      this.creator.saveFileAs(filename, "Zawartość pliku zapisu");

      SubtleMessage.messageWithContext(
        context,
        '"$filename" ${AppLocalizations.of(context).savingSuccess}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this._height,
      width: this._width,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade900,
        borderRadius: BorderRadius.all(Radius.circular(_cornerRadius)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: _Headline(cornerRadius: this._cornerRadius),
          ),
          Flexible(
            flex: 2,
            child: Container(),
          ),
          Flexible(
            flex: 4,
            child: Container(
              width: this._width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilenameReaderWidget(
                    checkIfReadyToSave: (String value) {
                      setState(() {
                        fileName = value;
                      });
                      _checkIfReadyToSave();
                    },
                    saveFile: (String value) {
                      setState(() {
                        fileName = value;
                      });
                      _checkIfReadyToSave();

                      if (_readyToSave) {
                        _saveFile(fileName);
                        Navigator.of(context).pop();
                      }
                    },
                    getWarningMessage: () => this.warningMessage,
                  ),
                ],
              ),
            ),
          ),
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 2,
            child: _Buttons(
              readyToSave: _readyToSave,
              saveFile: () {
                _checkIfReadyToSave();

                if (_readyToSave) {
                  _saveFile(fileName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  final double cornerRadius;

  _Headline({Key key, @required this.cornerRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(cornerRadius),
          topRight: Radius.circular(cornerRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).saveCurrentSession,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Function saveFile;
  final bool readyToSave;

  _Buttons({
    Key key,
    @required this.readyToSave,
    @required this.saveFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 3, fit: FlexFit.tight, child: Container()),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: IgnorePointer(
            ignoring: !this.readyToSave,
            child: ElevatedButton(
              onPressed: () => this.saveFile(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  this.readyToSave
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).backgroundColor,
                ),
              ),
              child: Text(AppLocalizations.of(context).save),
            ),
          ),
        ),
        Flexible(flex: 2, fit: FlexFit.tight, child: Container()),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
            ),
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ),
        Flexible(flex: 3, fit: FlexFit.tight, child: Container()),
      ],
    );
  }
}
