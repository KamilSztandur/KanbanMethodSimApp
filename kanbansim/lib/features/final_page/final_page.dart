import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:kanbansim/common/stats_calculator.dart';
import 'package:kanbansim/features/final_page/widgets/score_board.dart';
import 'package:kanbansim/features/final_page/widgets/amount_of_completed_tasks_info.dart';
import 'package:kanbansim/features/final_page/widgets/chart_legend.dart';
import 'package:kanbansim/features/final_page/widgets/chart_window.dart';
import 'package:kanbansim/features/final_page/widgets/tasks_completion_time_average.dart';
import 'package:kanbansim/features/final_page/widgets/tasks_completion_time_standard_deviation.dart';
import 'package:kanbansim/features/title_page/title_page.dart';
import 'package:kanbansim/features/window_bar.dart';
import 'package:kanbansim/kanban_sim_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kanbansim/models/sim_state.dart';

class FinalPage extends StatefulWidget {
  final SimState simState;

  FinalPage({
    Key key,
    @required this.simState,
  }) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    StatsCalculator calculator = StatsCalculator(
      allTasks: this.widget.simState.allTasks,
    );

    return Container(
      decoration: BoxDecoration(
        image: KanbanSimApp.of(context).getBackgroundImage(),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(
            Icons.keyboard_return,
            color: Colors.white,
          ),
          label: Text(
            AppLocalizations.of(context).returnToTitleScreen,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TitlePage(),
            ),
          ),
        ),
        body: WindowBorder(
          color: Theme.of(context).primaryColor,
          width: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              KanbanSimApp.of(context).isWeb()
                  ? Center()
                  : Align(
                      alignment: Alignment.topCenter,
                      child: WindowBar(),
                    ),
              Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
              Flexible(
                flex: 38,
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ChartWindow(allTasks: this.widget.simState.allTasks),
                        SizedBox(height: 20),
                        ChartLegend(),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AmountOfCompletedTasksInfo(
                          amount: calculator.getAmountOfFinishedTasks(),
                        ),
                        SizedBox(height: 20),
                        TasksCompletionTimeAverage(
                          average: calculator.countAverageOfCompletionTime(),
                        ),
                        SizedBox(height: 20),
                        TasksCompletionTimeStandardDeviation(
                          standardDeviation: calculator
                              .countStandardDeviationOfCompletionTime(),
                        ),
                        SizedBox(height: 20),
                        ScoreBoard(simState: this.widget.simState),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}