import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/team_status_bar/user_info_popup.dart';
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
  List<Widget> _buildUsersBoxList() {
    List<Widget> list = <Widget>[];

    this.widget.users.forEach((user) {
      list.add(_UserBox(user: user));
      list.add(SizedBox(width: 10));
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _Title(),
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
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).productivity,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _UserBox extends StatelessWidget {
  final User user;

  _UserBox({@required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => UserInfoPopup(user: user),
        );
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
            _UserTitle(user: user),
            _UserProductivityInfoLabel(user: user),
          ],
        ),
      ),
    );
  }
}

class _UserTitle extends StatelessWidget {
  final User user;

  _UserTitle({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          _UserIcon(user: user),
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
    );
  }
}

class _UserProductivityInfoLabel extends StatelessWidget {
  final User user;

  _UserProductivityInfoLabel({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${user.getProductivity()}/${user.getMaxProductivity()}',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.center,
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
      size: 15,
    );
  }
}
