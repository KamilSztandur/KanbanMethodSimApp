import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/main_page.dart';

class ProductivityBar extends StatefulWidget {
  MainPageState _parent;

  ProductivityBar(MainPageState parent) {
    this._parent = parent;
  }

  @override
  State<StatefulWidget> createState() => ProductivityBarState(_parent);
}

class ProductivityBarState extends State<ProductivityBar> {
  MainPageState _parent;
  List<_User> users;

  ProductivityBarState(MainPageState parent) {
    this._parent = parent;
    this.users = <_User>[];
  }

  void _test_createDummyUsers() {
    this.users = <_User>[];

    users.add(_User(
      "Kamil",
      5,
      Colors.blue,
    ));

    users.add(_User(
      "Janek",
      5,
      Colors.limeAccent,
    ));

    users.add(_User(
      "Łukasz",
      5,
      Colors.purpleAccent,
    ));

    users.add(_User(
      "Agata",
      3,
      Colors.orangeAccent,
    ));

    this.users[0].decreaseProductivity(2);
    this.users[1].decreaseProductivity(3);
    this.users[2].decreaseProductivity(0);
    this.users[3].decreaseProductivity(1);
  }

  Icon _buildUserIcon(_User user, double size) {
    return Icon(
      Icons.account_circle_outlined,
      color: user.getColor(),
      size: size,
    );
  }

  Widget _buildUserBox(_User user) {
    return GestureDetector(
      onTap: () {
        _showUserInfo(user);
      },
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
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
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Text(
              '${user._productivity}/${user._maxProductivity}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
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

    users.forEach((user) {
      list.add(_buildUserBox(user));
      list.add(SizedBox(width: 10));
    });

    return list;
  }

  void _showUserInfo(_User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "User info.",
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
              'Productivity:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${user._productivity} / ${user._maxProductivity}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _test_createDummyUsers();

    return Center(
      child: Container(
        height: 100,
        width: 800,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
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
                "Productivity",
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

class _User {
  static int _registeredUsersAmount = 0;
  String _name;
  int _maxProductivity;
  Color _color;

  int _id;
  int _productivity;

  _User(String name, int maxProductivity, Color color) {
    this._name = name;
    this._maxProductivity = maxProductivity;
    this._color = color;

    this._id = _registeredUsersAmount++;
    this._productivity = maxProductivity;
  }

  bool decreaseProductivity(int amount) {
    if (amount > this._productivity) {
      return false;
    } else {
      this._productivity -= amount;
      return true;
    }
  }

  bool increaseProductivity(int amount) {
    int newProductivity = this._productivity + amount;

    if (newProductivity > this._maxProductivity) {
      return false;
    } else {
      this._productivity = newProductivity;
      return true;
    }
  }

  String getName() {
    return this._name;
  }

  Color getColor() {
    return this._color;
  }

  int getProductivity() {
    return this._productivity;
  }

  int getMaxProductivity() {
    return this._maxProductivity;
  }

  int getID() {
    return this._id;
  }
}
