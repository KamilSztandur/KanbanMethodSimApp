import 'package:flutter/material.dart';
import 'package:kanbansim/features/main_page/main_page.dart';
import 'dart:math';
import 'package:kanbansim/features/main_page/widgets/kanban_board/kanban_column.dart';
import 'package:kanbansim/features/main_page/widgets/kanban_board/task_card.dart';
import 'package:kanbansim/features/notifications/subtle_message.dart';

class KanbanBoard extends StatefulWidget {
  //KanbanBoard({Key key, @required this.parent}) : super(key: key);
  KanbanBoard(MainPageState parent) {
    this.parent = parent;
  }

  MainPageState parent;
  KanbanBoardState child;

  @override
  KanbanBoardState createState() => KanbanBoardState(parent);
}

class KanbanBoardState extends State<KanbanBoard> {
  MainPageState parent;
  List<TaskCard> idleTasksColumn,
      stageOneInProgressTasksColumn,
      stageOneDoneTasksColumn,
      stageTwoTasksColumn,
      finishedTasksColumn;

  KanbanBoardState(MainPageState parent) {
    _setUpTaskLists();
    this.parent = parent;
    this.parent.kanbanBoard.child = this;
  }

  void removeTask(TaskCard task) {
    setState(() {
      if (this.idleTasksColumn.remove(task) == true) {
        return;
      }

      if (this.stageOneInProgressTasksColumn.remove(task) == true) {
        return;
      }

      if (this.stageOneDoneTasksColumn.remove(task) == true) {
        return;
      }

      if (this.stageTwoTasksColumn.remove(task) == true) {
        return;
      }

      if (this.finishedTasksColumn.remove(task) == true) {
        return;
      }
    });

    SubtleMessage.messageWithContext(
      context,
      "Task #${task.getID()} removed successfuly.",
    );
  }

  void addRandomTasksForAllColumns() {
    setState(() {
      _addRandomTasks(this.idleTasksColumn);
      _addRandomTasks(this.stageOneInProgressTasksColumn);
      _addRandomTasks(this.stageOneDoneTasksColumn);
      _addRandomTasks(this.stageTwoTasksColumn);
      _addRandomTasks(this.finishedTasksColumn);
    });
    SubtleMessage.messageWithContext(
      context,
      "Sucessfully added few random tasks.",
    );
  }

  void clearAllTasks() {
    setState(() {
      _setUpTaskLists();
    });

    SubtleMessage.messageWithContext(
      context,
      "Sucessfully cleared all tasks.",
    );
  }

  void _setUpTaskLists() {
    this.idleTasksColumn = <TaskCard>[];
    this.stageOneInProgressTasksColumn = <TaskCard>[];
    this.stageOneDoneTasksColumn = <TaskCard>[];
    this.stageTwoTasksColumn = <TaskCard>[];
    this.finishedTasksColumn = <TaskCard>[];
  }

  void _addRandomTasks(List<TaskCard> tasks) {
    var rand = new Random();
    int newTasks = rand.nextInt(3);
    for (int i = 0; i < newTasks; i++) {
      tasks.add(TaskCard(this));
    }
  }

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

  Widget _buildAddButton() {
    return new Container(
      alignment: Alignment.center,
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.post_add),
          color: Colors.grey,
          iconSize: 100,
          splashColor: Theme.of(context).primaryColor,
          onPressed: () {
            setState(() {
              idleTasksColumn.add(TaskCard(this));
            });

            SubtleMessage.messageWithContext(
              context,
              "New task added successfuly.",
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _addRandomTasks(idleTasksColumn);
    _addRandomTasks(stageOneInProgressTasksColumn);
    _addRandomTasks(stageOneDoneTasksColumn);
    _addRandomTasks(stageTwoTasksColumn);
    _addRandomTasks(finishedTasksColumn);

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
          child: KanbanColumn(
            parent: this,
            title: "IDLE TASKS",
            tasks: idleTasksColumn,
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
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100.0),
                            topRight: Radius.circular(100.0),
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
                              parent: this,
                              title: "IN PROGRESS",
                              tasks: stageOneInProgressTasksColumn,
                            ),
                          ),
                          Flexible(
                            flex: 20,
                            child: KanbanColumn(
                              parent: this,
                              title: "DONE",
                              tasks: stageOneDoneTasksColumn,
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
            parent: this,
            title: "STAGE TWO",
            tasks: stageTwoTasksColumn,
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 20,
          child: KanbanColumn(
            parent: this,
            title: "FINISHED",
            tasks: finishedTasksColumn,
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
