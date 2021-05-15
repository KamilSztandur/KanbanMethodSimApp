import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuButton extends StatelessWidget {
  final Function action;
  final String text;

  MenuButton({
    Key key,
    @required this.text,
    @required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: action,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 0.8],
            tileMode: TileMode.clamp,
            colors: [
              Colors.blue,
              Colors.cyan,
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          height: 100,
          width: 300,
          child: Center(
            child: Text(
              text,
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: GoogleFonts.staatliches(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
