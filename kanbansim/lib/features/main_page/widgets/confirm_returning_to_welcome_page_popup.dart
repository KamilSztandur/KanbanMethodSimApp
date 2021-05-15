import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/features/title_page/title_page.dart';

class ConfirmReturningToWelcomePagePopup {
  Widget show() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _ConfirmReturningToWelcomePage(),
    );
  }
}

class _ConfirmReturningToWelcomePage extends StatelessWidget {
  final double _cornerRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade900,
        borderRadius: BorderRadius.all(Radius.circular(_cornerRadius)),
      ),
      child: ListView(
        children: [
          _Headline(cornerRadius: _cornerRadius),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                SizedBox(height: 15),
                _WarningLabel(),
                SizedBox(height: 10),
                _Buttons(confirmed: () => _returnToWelcomePage(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _returnToWelcomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TitlePage(),
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
      height: 40,
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
            "${AppLocalizations.of(context).warning.toUpperCase()}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text:
                "${AppLocalizations.of(context).youreAboutToReturnToTitleScreen}. ${AppLocalizations.of(context).savingSimulationStateIsAdvised}.\n",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Function confirmed;

  _Buttons({
    Key key,
    @required this.confirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
        Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: ElevatedButton(
              onPressed: () => this.confirmed(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text(
                "${AppLocalizations.of(context).proceed}",
                textAlign: TextAlign.center,
              ),
            )),
        Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
        Flexible(
          flex: 5,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
            ),
            child: Text(
              AppLocalizations.of(context).cancel,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
      ],
    );
  }
}
