import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/create_task_button.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_column.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';
import 'package:kanbansim/models/AllTasksContainer.dart';

class KanbanBoard extends StatefulWidget {
  final AllTasksContainer allTasks;
  final VoidCallback createNewTask;

  KanbanBoard({
    Key key,
    @required this.allTasks,
    @required this.createNewTask,
  }) : super(key: key);

  @override
  KanbanBoardState createState() => KanbanBoardState();
}

class KanbanBoardState extends State<KanbanBoard> {
  Column _buildTitle(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateNewTaskButton() {
    return CreateTaskButton(createNewTask: () {
      this.widget.createNewTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 20,
          child: Column(
            children: [
              SizedBox(height: 15),
              KanbanColumn(
                title: "IDLE TASKS",
                isInternal: false,
                tasks: widget.allTasks.idleTasksColumn,
                additionalWidget: _buildCreateNewTaskButton(),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 40,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent.shade400,
                          border:
                              Border.all(color: Colors.indigoAccent.shade400),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100.0),
                            topRight: Radius.circular(100.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.0),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: _buildTitle("STAGE ONE TASKS"),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent.shade400,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
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
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 20,
                            child: KanbanColumn(
                              title: "IN PROGRESS",
                              isInternal: true,
                              tasks:
                                  widget.allTasks.stageOneInProgressTasksColumn,
                            ),
                          ),
                          Flexible(
                            flex: 20,
                            child: KanbanColumn(
                              title: "DONE",
                              isInternal: true,
                              tasks: widget.allTasks.stageOneDoneTasksColumn,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 20,
          child: KanbanColumn(
            title: "STAGE TWO",
            isInternal: false,
            tasks: widget.allTasks.stageTwoTasksColumn,
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 20,
          child: KanbanColumn(
            title: "FINISHED",
            isInternal: false,
            tasks: widget.allTasks.finishedTasksColumn,
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }
}

/*
Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle("Idle Tasks"),
              _buildAddButton(),
              SizedBox(height: 20),
              KanbanColumn(parent: this, tasks: idleTasksColumn),
            ],
          ),
          Container(height: 1000, child: VerticalDivider(color: Colors.grey)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitle("Stage One"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      _buildTitle("Tasks In Progress"),
                      KanbanColumn(
                          parent: this, tasks: stageOneInProgressTasksColumn),
                    ],
                  ),
                  Container(
                      height: 1000, child: VerticalDivider(color: Colors.grey)),
                  Column(
                    children: [
                      _buildTitle("Done Tasks"),
                      KanbanColumn(
                          parent: this, tasks: stageOneDoneTasksColumn),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(height: 1000, child: VerticalDivider(color: Colors.grey)),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                _buildTitle("Stage Two Tasks"),
                KanbanColumn(parent: this, tasks: stageTwoTasksColumn),
              ],
            ),
          ),
          Container(height: 1000, child: VerticalDivider(color: Colors.grey)),
          Column(
            children: [
              _buildTitle("Finished Tasks"),
              KanbanColumn(parent: this, tasks: finishedTasksColumn),
            ],
          ),
*/
