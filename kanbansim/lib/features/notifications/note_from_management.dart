import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/models/User.dart';

class NoteFromManagementPopup {
  final List<User> users;
  final String message;

  NoteFromManagementPopup({
    @required this.message,
    @required this.users,
  });

  Widget show() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _NoteFromManagement(
        message: this.message,
        names: _parseUserListToUsernamesStringList(),
      ),
    );
  }

  List<String> _parseUserListToUsernamesStringList() {
    List<String> names = <String>[];

    this.users.forEach((User user) => names.add(user.getName()));
    return names;
  }
}

class _NoteFromManagement extends StatelessWidget {
  final List<String> names;
  final String message;

  _NoteFromManagement({
    Key key,
    @required this.message,
    @required this.names,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 500,
      width: 700,
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: [
          _HeadlineRow(),
          SizedBox(height: 30),
          _subHeadlineRow(),
          SizedBox(height: 20),
          _emailWindow(
            message: this.message,
            names: this.names,
          ),
        ],
      ),
    );
  }
}

class _emailTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.reorder,
          color: Colors.grey,
          size: 25,
        ),
        SizedBox(width: 5),
        Icon(
          Icons.mail,
          color: Theme.of(context).primaryColor,
          size: 35,
        ),
        SizedBox(width: 5),
        Text(
          AppLocalizations.of(context).email,
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}

class _QuitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: InkWell(
        hoverColor: Colors.red,
        child: SizedBox(
          height: 35,
          width: 35,
          child: Tooltip(
            message: AppLocalizations.of(context).close,
            child: Icon(
              Icons.power_settings_new,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _HeadlineRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 140,
          fit: FlexFit.tight,
          child: _emailTitle(),
        ),
        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: Container(),
        ),
        Flexible(
          flex: 400,
          fit: FlexFit.loose,
          child: Container(
            height: 30,
            width: 460,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        Flexible(
          flex: 20,
          fit: FlexFit.tight,
          child: Container(),
        ),
        Flexible(
          flex: 33,
          fit: FlexFit.tight,
          child: _QuitButton(),
        ),
      ],
    );
  }
}

class _subHeadlineRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        Icon(
          Icons.undo,
          color: Colors.grey,
          size: 20,
        ),
        SizedBox(width: 10),
        Icon(
          Icons.circle,
          color: Colors.grey.withOpacity(0.5),
          size: 30,
        ),
        SizedBox(width: 5),
        Icon(
          Icons.circle,
          color: Colors.grey.withOpacity(0.5),
          size: 30,
        ),
        SizedBox(width: 5),
        Icon(
          Icons.circle,
          color: Colors.grey.withOpacity(0.5),
          size: 30,
        ),
        SizedBox(width: 5),
      ],
    );
  }
}

class _emailWindow extends StatelessWidget {
  final List<String> names;
  final String message;

  _emailWindow({
    Key key,
    @required this.message,
    @required this.names,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _emailHeadline(names: this.names),
          SizedBox(height: 10),
          _emailContent(message: this.message),
        ],
      ),
    );
  }
}

class _emailHeadline extends StatelessWidget {
  final List<String> names;

  _emailHeadline({
    Key key,
    @required this.names,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 60),
            SelectableText(
              "${AppLocalizations.of(context).messageFrom} ${AppLocalizations.of(context).management}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.orange,
              size: 50,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                SelectableText(
                  AppLocalizations.of(context).management,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SelectableText(
                  _getFormattedNames(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _getFormattedNames() {
    String formattedNames = "";

    int n = this.names.length;
    for (int i = 0; i < n - 1; i++) {
      formattedNames += "${this.names[i]}, ";
    }

    formattedNames += "${this.names[n - 1]}";

    return formattedNames;
  }
}

class _emailContent extends StatelessWidget {
  final String message;
  final double fontSize = 15.0;

  _emailContent({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 250,
      width: 660,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              "${AppLocalizations.of(context).fellowDevs},\n\n${this.message}\n\n",
              style: TextStyle(
                fontSize: this.fontSize,
              ),
            ),
            Container(height: 1, width: 150, color: Colors.grey),
            SizedBox(height: 10),
            SelectableText(
              AppLocalizations.of(context).management,
              style: TextStyle(
                fontSize: this.fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
