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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
              KanbanSimApp.of(context).isWeb() ? Center() : WindowBar(),
              Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
              Flexible(
                flex: 19,
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(flex: 1, child: Container()),
                    Flexible(
                      flex: 30,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 600,
                        ),
                        child: ChartWindow(
                          allTasks: this.widget.simState.allTasks,
                        ),
                      ),
                    ),
                    Flexible(flex: 1, child: Container()),
                    Flexible(
                      flex: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(flex: 1, child: Container()),
                          Flexible(
                            flex: 15,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 100,
                              ),
                              child: ChartLegend(),
                            ),
                          ),
                          Flexible(flex: 3, child: Container()),
                          Flexible(
                            flex: 45,
                            child: ScoreBoard(simState: this.widget.simState),
                          ),
                          Flexible(flex: 1, child: Container()),
                        ],
                      ),
                    ),
                    Flexible(flex: 1, child: Container()),
                    Flexible(
                      flex: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(flex: 1, child: Container()),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 155,
                              maxHeight: 168,
                            ),
                            child: AmountOfCompletedTasksInfo(
                              amount: calculator.getAmountOfFinishedTasks(),
                            ),
                          ),
                          Flexible(flex: 1, child: Container()),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 175,
                              maxHeight: 175,
                            ),
                            child: TasksCompletionTimeAverage(
                              average:
                                  calculator.countAverageOfCompletionTime(),
                            ),
                          ),
                          Flexible(flex: 1, child: Container()),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 205,
                              maxHeight: 230,
                            ),
                            child: TasksCompletionTimeStandardDeviation(
                              standardDeviation: calculator
                                  .countStandardDeviationOfCompletionTime(),
                            ),
                          ),
                          Flexible(flex: 1, child: Container()),
                        ],
                      ),
                    ),
                    Flexible(flex: 1, child: Container()),
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
