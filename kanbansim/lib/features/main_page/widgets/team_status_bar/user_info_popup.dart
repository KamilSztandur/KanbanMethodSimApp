import 'package:flutter/material.dart';
import 'package:kanbansim/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserInfoPopup extends StatelessWidget {
  final User user;

  UserInfoPopup({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).userInfo,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _UserIcon(user: user),
          _UserTitle(user: user),
          _UserProductivityLabel(user: user),
        ],
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              _CloseButton(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserIcon extends StatelessWidget {
  final User user;

  _UserIcon({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.account_circle_outlined,
      color: user.getColor(),
      size: 100,
    );
  }
}

class _UserTitle extends StatelessWidget {
  final User user;

  _UserTitle({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${user.getName()}',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _UserProductivityLabel extends StatelessWidget {
  final User user;

  _UserProductivityLabel({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${user.getProductivity()} / ${user.getMaxProductivity()}',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
      ),
      child: Text(AppLocalizations.of(context).close),
    );
  }
}
