import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/features/final_page/score_board.dart';
import 'package:kanbansim/features/window_bar.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';
import 'package:kanbansim/models/User.dart';

class FinalPage extends StatefulWidget {
  final AllTasksContainer allTasks;
  final List<User> users;

  FinalPage({
    Key key,
    @required this.allTasks,
    @required this.users,
  }) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: KanbanSimApp.of(context).getBackgroundImage(),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: AnimatedBackground(
          behaviour: BubblesBehaviour(),
          vsync: this,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child:
                    KanbanSimApp.of(context).isWeb() ? Center() : WindowBar(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ScoreBoard(
                  allTasks: this.widget.allTasks,
                  users: this.widget.users,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
