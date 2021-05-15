import 'package:flutter/material.dart';
import 'package:kanbansim/kanban_sim_app.dart';

class LangSwitchButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color buttonsColor = Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: buttonsColor,
            side: BorderSide(
              color: buttonsColor,
            ),
          ),
          child: Text(
            "PL",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => KanbanSimApp.of(context).switchLanguageTo("polish"),
        ),
        SizedBox(width: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            primary: buttonsColor,
            side: BorderSide(
              color: buttonsColor,
            ),
          ),
          child: Text(
            "EN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => KanbanSimApp.of(context).switchLanguageTo("english"),
        ),
      ],
    );
  }
}
