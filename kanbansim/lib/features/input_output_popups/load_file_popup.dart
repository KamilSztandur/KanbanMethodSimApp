import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kanbansim/common/input_output_file_picker/input/filepicker_interface.dart';
import 'package:kanbansim/features/input_output_popups/file_picker_widget.dart';
import 'package:kanbansim/features/notifications/feedback_popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadFilePopup {
  Function(String filePath) returnPickedFilepath;

  LoadFilePopup({
    this.returnPickedFilepath,
  });

  Widget show(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.transparent,
      content: _LoadFilePage(
        returnPickedFilePath: (String filePath) {
          this.returnPickedFilepath(filePath);
        },
      ),
    );
  }
}

class _LoadFilePage extends StatefulWidget {
  final Function(String) returnPickedFilePath;
  String filePath;

  _LoadFilePage({
    Key key,
    this.filePath,
    @required this.returnPickedFilePath,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadFilePageState();
}

class _LoadFilePageState extends State<_LoadFilePage> {
  bool _readyToSubmit;
  FilePicker _picker;
  double _cornerRadius = 35;
  double _height = 250;
  double _width = 400;

  @override
  Widget build(BuildContext context) {
    _readyToSubmit = this.widget.filePath != null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade900,
        borderRadius: BorderRadius.all(Radius.circular(_cornerRadius)),
      ),
      height: this._height,
      width: this._width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: _Headline(
              cornerRadius: this._cornerRadius,
            ),
          ),
          Flexible(flex: 3, child: Container()),
          Flexible(
            flex: 2,
            child: FilePickerWidget(
              filePath: this.widget.filePath,
              pathIsPicked: (String path) {
                setState(() {
                  this.widget.filePath = path;
                });
              },
              width: _width,
            ),
          ),
          Flexible(flex: 3, child: Container()),
          Flexible(
            flex: 2,
            child: _Buttons(
              filePath: this.widget.filePath,
              isReadyToSubmit: _readyToSubmit,
              returnPickedFilePath: (String path) =>
                  this.widget.returnPickedFilePath(path),
            ),
          ),
          Flexible(flex: 1, child: Container()),
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
            AppLocalizations.of(context).loadSavefile,
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
  final bool isReadyToSubmit;
  final Function returnPickedFilePath;
  final String filePath;

  _Buttons({
    Key key,
    @required this.filePath,
    @required this.isReadyToSubmit,
    @required this.returnPickedFilePath,
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
            ignoring: !this.isReadyToSubmit,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _returnIfExists(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  this.isReadyToSubmit
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).backgroundColor,
                ),
              ),
              child: Text(AppLocalizations.of(context).loadFile),
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

  void _returnIfExists(BuildContext context) {
    File saveFile = File(this.filePath);
    if (saveFile.existsSync()) {
      this.returnPickedFilePath(this.filePath);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => FeedbackPopUp.show(
          context,
          AppLocalizations.of(context).loadingFailed,
          AppLocalizations.of(context).fileCorruptedNotice,
        ),
      );
      this.returnPickedFilePath(null);
    }
  }
}
