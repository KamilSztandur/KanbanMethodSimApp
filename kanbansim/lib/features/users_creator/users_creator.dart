import 'package:flutter/material.dart';
import 'package:kanbansim/features/users_creator/user_creator.dart';
import 'package:kanbansim/models/User.dart';

class UsersCreatorPopup {
  final Function(List<User>) usersCreated;

  UsersCreatorPopup({
    @required this.usersCreated,
  });

  Widget show({Function() usersCreated}) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      child: _UsersCreator(usersCreated: this.usersCreated),
    );
  }
}

class _UsersCreator extends StatefulWidget {
  final Function(List<User>) usersCreated;

  const _UsersCreator({
    Key key,
    @required this.usersCreated,
  }) : super(key: key);

  @override
  _UsersCreatorState createState() => _UsersCreatorState();
}

class _UsersCreatorState extends State<_UsersCreator> {
  final int limit = 5;
  List<User> data;

  List<ColorSwatch<dynamic>> availableColors = [
    Colors.green,
    Colors.blue,
    Colors.cyan,
    Colors.purpleAccent,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.indigoAccent,
    Colors.pink,
    Colors.teal,
  ];

  List<String> availableNames = [
    "Macau",
    "Myanmar",
    "Bhutan",
    "Singapur",
    "Lebanon",
    "Rwanda",
    "Lesotho",
    "Burkina",
    "Rose",
    "Cassia",
    "Iris",
    "Daisy",
    "Dahlia",
    "Ren",
    "Sorrel",
    "Vienna",
    "Petra",
    "Rio",
    "Dallas",
    "Bilbao",
  ];

  @override
  Widget build(BuildContext context) {
    if (this.data == null) {
      this.data = <User>[];
    }

    return Container(
      height: 275,
      width: 680,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).accentColor
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
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
      child: ListView(
        children: [
          _Headline(cornerRadius: 10),
          SizedBox(height: 20),
          _UsersShowcase(
            data: this.data,
            limit: this.limit,
            addNewUserBtnClicked: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => UserCreatorPopup(
                  userCreated: (User createdUser) {
                    setState(() {
                      this.availableColors.remove(createdUser.getColor());
                      this.availableNames.remove(createdUser.getName());
                      this.data.add(createdUser);
                    });
                  },
                  availableColors: this.availableColors,
                  availableNames: this.availableNames,
                ).show(),
              );
            },
            deleteUserFromList: (User user) {
              setState(() {
                this.availableColors.add(user.getColor());
                this.availableNames.add(user.getName());
                this.data.remove(user);
              });
            },
          ),
          SizedBox(height: 15),
          _Buttons(
            readyToCreate: this.data.length > 0,
            createButtonPressed: () => this.widget.usersCreated(this.data),
          ),
        ],
      ),
    );
  }
}

class _UsersShowcase extends StatelessWidget {
  final Function addNewUserBtnClicked;
  final Function deleteUserFromList;
  final List<User> data;
  final int limit;

  _UsersShowcase({
    Key key,
    @required this.addNewUserBtnClicked,
    @required this.deleteUserFromList,
    @required this.data,
    @required this.limit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 155,
        width: 650,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: _UsersList(
                addNewUserBtnClicked: this.addNewUserBtnClicked,
                deleteUserFromList: this.deleteUserFromList,
                data: this.data,
                limit: this.limit,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 30,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "${this.data.length}/${this.limit} prosze",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsersList extends StatefulWidget {
  final Function addNewUserBtnClicked;
  final Function deleteUserFromList;
  final List<User> data;
  final int limit;

  _UsersList({
    Key key,
    @required this.addNewUserBtnClicked,
    @required this.deleteUserFromList,
    @required this.data,
    @required this.limit,
  }) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<_UsersList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.only(
          left: 50,
          right: 50,
        ),
        children: _parseDataToUserBoxList(context),
      ),
    );
  }

  List<Widget> _parseDataToUserBoxList(BuildContext context) {
    List<Widget> list = <Widget>[];

    int filled = this.widget.data.length;
    if (filled != 0) {
      for (int i = 0; i < filled; i++) {
        list.add(
          _UserBox(
            user: this.widget.data[i],
            deleteMeFromList: this.widget.deleteUserFromList,
          ),
        );
        list.add(SizedBox(width: 10));
      }
    }

    int unfilled = this.widget.limit - filled;
    if (unfilled > 0) {
      list.add(_UserBox(
          specialAction: _AddNewUserButton(
        addNewUserBtnClicked: this.widget.addNewUserBtnClicked,
      )));

      for (int i = 1; i < unfilled; i++) {
        list.add(SizedBox(width: 10));
        list.add(_UserBox(user: null, deleteMeFromList: null));
      }
    }

    return list;
  }
}

class _UserBox extends StatelessWidget {
  final Function(User) deleteMeFromList;
  final User user;
  final Widget specialAction;

  _UserBox({
    Key key,
    this.user,
    this.specialAction,
    @required this.deleteMeFromList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 195,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                height: 120,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  border: Border.all(
                    color: this.user == null
                        ? Colors.grey.shade600
                        : this.user.getColor(),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: this.user == null
                    ? Container()
                    : Column(
                        children: [
                          _UserTitle(user: this.user),
                          SizedBox(height: 3),
                          _UserIcon(user: this.user),
                          SizedBox(height: 3),
                          _UserProductivityInfoLabel(user: this.user),
                          SizedBox(height: 3),
                        ],
                      ),
              ),
            ),
            this.specialAction == null
                ? Container()
                : Center(
                    child: this.specialAction,
                  ),
            this.user == null
                ? Container()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 39),
                          _DeleteUserButton(
                            deleteBtnClicked: () =>
                                this.deleteMeFromList(this.user),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _AddNewUserButton extends StatelessWidget {
  final Function addNewUserBtnClicked;

  _AddNewUserButton({
    Key key,
    @required this.addNewUserBtnClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.add_circle,
        color: Colors.grey.shade800,
      ),
      iconSize: 85,
      tooltip: "Dodaj nowego użytkownika.",
      onPressed: this.addNewUserBtnClicked,
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            user.getName(),
            style: TextStyle(
              fontSize: 12,
              color: this.user.getColor(),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
      color: this.user.getColor(),
      size: 55,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          this.user.getMaxProductivity().toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: this.user.getColor(),
          ),
        ),
        Icon(
          Icons.settings_outlined,
          color: this.user.getColor(),
          size: 15,
        ),
      ],
    );
  }
}

class _DeleteUserButton extends StatelessWidget {
  final Function deleteBtnClicked;

  _DeleteUserButton({
    Key key,
    @required this.deleteBtnClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Tooltip(
        message: "Kliknij, aby usunąć użytkownika.",
        child: ClipOval(
          child: Material(
            color: Colors.grey.shade700,
            child: InkWell(
              hoverColor: Colors.red,
              child: SizedBox(
                height: 20,
                width: 20,
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              onTap: () => this.deleteBtnClicked(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModifyUserButton extends StatelessWidget {
  final Function modifyBtnClicked;

  _ModifyUserButton({
    Key key,
    @required this.modifyBtnClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Tooltip(
        message: "Kliknij, aby zmodyfikować użytkownika.",
        child: ClipOval(
          child: Material(
            color: Colors.grey.shade700,
            child: InkWell(
              hoverColor: Colors.teal,
              child: SizedBox(
                height: 20,
                width: 20,
                child: Icon(
                  Icons.build,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              onTap: () => this.modifyBtnClicked(),
            ),
          ),
        ),
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
          topLeft: Radius.circular(this.cornerRadius),
          topRight: Radius.circular(this.cornerRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "KREATOR CZŁONKÓW ZESPOŁU",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final VoidCallback createButtonPressed;
  final bool readyToCreate;

  _Buttons({
    Key key,
    @required this.readyToCreate,
    @required this.createButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 6,
          child: Container(),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: IgnorePointer(
            ignoring: !readyToCreate,
            child: ElevatedButton(
              onPressed: () => this.createButtonPressed(),
              child: Text("Zatwierdź"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  this.readyToCreate
                      ? Colors.green
                      : Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Anuluj"),
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(),
        ),
      ],
    );
  }
}
