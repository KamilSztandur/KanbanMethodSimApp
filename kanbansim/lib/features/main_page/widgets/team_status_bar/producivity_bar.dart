import 'package:flutter/material.dart';
import 'package:kanbansim/models/User.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductivityBar extends StatefulWidget {
  final List<User> users;

  ProductivityBar({
    Key key,
    @required this.users,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductivityBarState();
}

class ProductivityBarState extends State<ProductivityBar> {
  Icon _buildUserIcon(User user, double size) {
    return Icon(
      Icons.account_circle_outlined,
      color: user.getColor(),
      size: size,
    );
  }

  Widget _buildUserBox(User user) {
    return GestureDetector(
      onTap: () {
        _showUserInfo(user);
      },
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(
              Theme.of(context).brightness == Brightness.light ? (0.9) : (0.0)),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  _buildUserIcon(user, 15),
                  Text(
                    '${user.getName()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Text(
              '${user.getProductivity()}/${user.getMaxProductivity()}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUsersBoxList() {
    List<Widget> list = <Widget>[];

    this.widget.users.forEach((user) {
      list.add(_buildUserBox(user));
      list.add(SizedBox(width: 10));
    });

    return list;
  }

  void _showUserInfo(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).userInfo,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildUserIcon(user, 100),
            Text(
              '${user.getName()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${AppLocalizations.of(context).productivity}:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${user.getProductivity()} / ${user.getMaxProductivity()}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  child: Text(AppLocalizations.of(context).close),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 800,
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
          fit: BoxFit.contain,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              Text(
                AppLocalizations.of(context).productivity,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    children: _buildUsersBoxList(),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
