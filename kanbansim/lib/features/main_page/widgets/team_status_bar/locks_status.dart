import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocksStatus extends StatefulWidget {
  final Function checkForLocks;

  LocksStatus({
    Key key,
    @required this.checkForLocks,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocksStatusState();
}

class LocksStatusState extends State<LocksStatus> {
  bool _areThereAnyLocks;

  void _updateStatus() {
    this._areThereAnyLocks = this.widget.checkForLocks();
  }

  bool getStatus() {
    return this._areThereAnyLocks;
  }

  @override
  Widget build(BuildContext context) {
    _updateStatus();

    return Center(
      child: Container(
        height: 100,
        width: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          border: Border.all(color: Theme.of(context).primaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              _Title(),
              SizedBox(height: 10),
              _LocksMonitor(areThereAnyLocks: this._areThereAnyLocks),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).locks,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _LocksMonitor extends StatelessWidget {
  final bool areThereAnyLocks;

  _LocksMonitor({@required this.areThereAnyLocks});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 75,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(),
        color: this.areThereAnyLocks ? Colors.redAccent : Colors.green,
      ),
      child: Text(
        this.areThereAnyLocks
            ? AppLocalizations.of(context).locksArePresent
            : AppLocalizations.of(context).noLocksArePresent,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
