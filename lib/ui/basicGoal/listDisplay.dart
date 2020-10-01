import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goalie/models/basicGoal.dart';
import 'package:goalie/services/sqfliteBasicGoalsService.dart';

import 'details.dart';
import 'newGoal.dart';

class BasicGoalsList extends StatefulWidget {
  final String title;

  BasicGoalsList({Key key, this.title}) : super(key: key);

  @override
  _BasicGoalsListState createState() => _BasicGoalsListState();
}

class _BasicGoalsListState extends State<BasicGoalsList> {
  //String password = "Password";
  List<BasicGoal> basicGoals;
  List<BasicGoal> activeGoals;
  List<BasicGoal> incompleteGoals;
  List<BasicGoal> completedGoals;
  bool fetchDataState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: buildOutput());
  }

  Widget buildOutput() {
    fetchData();

    return buildActiveLists();
  }

  Widget buildActiveLists(){
    return Column(
      children: <Widget>[
        //TODO add the active goals text widget
        getTextWidgets("active"),
        getTextWidgets("complete"),
        getTextWidgets("incomplete"),
        FloatingActionButton(
            tooltip: 'Add new goals',
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  //throw UnimplementedError();
                  //TODO route this one to new basic goals form
                  return NewBasicGoalForm(title: "Goalie - New Goal");
                  //return MainStateNewInput();
                }),
              ).then((value) {
                setState(() {
                  //fetchData();
                  basicGoals = null;
                });
              });
            }),
      ],
    );
  }

  void fetchData() async {
    if (basicGoals != null) {
      return;
    }

    await SQLiteBasicGoalDatabaseService().initDatabase();
    SQLiteBasicGoalDatabaseService().getAllBasicGoals().then((value) {
      if (value == null || value.isEmpty) return;
      //passes = value;
      setState(() {
        //print("Set State called");
        basicGoals = value;
        activeGoals=[];
        completedGoals=[];
        incompleteGoals=[];
        for(BasicGoal goal in basicGoals){
          if(goal.active){
            activeGoals.add(goal);
          }else{
            if(goal.completed){
              completedGoals.add(goal);
            }else{
              incompleteGoals.add(goal);
            }
          }
        }
        fetchDataState = false;
      });
    });
  }

  Widget ordinaryView(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: basicGoals
            .map((e) => Row(children: <Widget>[
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onLongPress: () {
                //showAlertDialog(context, e.id);
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BasicGoalDetails(goal:e);
                  }),
                ).then((value) {
                  setState(() {
                    //fetchData();
                    basicGoals = null;
                  });
                });
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          e.goalName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ]))
            .toList());
  }

  Widget scrollableView(List<BasicGoal> goals){
    return

    ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final e = goals[index];

        return Dismissible(
          // Each Dismissible must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
            key: Key(e.id.toString()),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
              if(direction==DismissDirection.startToEnd){
                //print("Its a right swipe");
                e.active=false;
                e.completed=true;
                SQLiteBasicGoalDatabaseService().updateBasicGoal(e);
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(e.goalName+" Completed!!")));
              }else if(direction==DismissDirection.endToStart){
                //print("Its a left swipe");
                e.active=false;
                e.completed=false;
                SQLiteBasicGoalDatabaseService().updateBasicGoal(e);
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(e.goalName+" Failed --")));
              }
              setState(() {
                goals.removeAt(index);
              });

              // Then show a snackbar.

            },
            // Show a red background as the item is swiped away.
            background: Container(color: Colors.blue),
            child: Container(
                child: Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onLongPress: () {
                      //showAlertDialog(context, e.id);
                      SQLiteBasicGoalDatabaseService().deleteBasicGoal(e.id);
                      setState(() {
                        basicGoals=null;
                      });
                    },
                    onTap: () {
                      calculateEndTimeDaysReturnString(e.startTime);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return BasicGoalDetails(goal:e);
                        }),
                      ).then((value) {
                        setState(() {
                          //fetchData();
                          basicGoals = null;
                        });
                      });
                    },
                    child: Container(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  e.goalName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  calculateEndTimeDaysReturnString(e.endTime),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            )
        );
      },
    );
  }

  Widget getTextWidgets(String typeOfGoals) {
    if (basicGoals == null) {
      return CircularProgressIndicator();
    }

    if(typeOfGoals=="active"){
      if(activeGoals!=null && activeGoals.length>0)
        return Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Active Goals",
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: scrollableView(activeGoals)
                )

              ],
            )
        );
    }else if(typeOfGoals=="complete"){
      if(completedGoals!=null && completedGoals.length>0)
        return Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Completed Goals",
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: scrollableView(completedGoals)
                )
              ],
            )
        );
    }else if(typeOfGoals=="incomplete"){
      if(incompleteGoals!=null && incompleteGoals.length>0)
        return Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Incomplete Goals",
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: scrollableView(incompleteGoals)
                )
              ],
            )
        );
    }
    return Container();
  }

  String calculateEndTimeDaysReturnString(DateTime date){
    DateTime now = DateTime.now();
    if(date==null) return "No limit fixed";
    int difference = now.difference(date).inDays;
    if(difference<0){
      difference*=-1;
      return "$difference Days left";
    }else if(difference==0){
      return "Ends today";
    }else{
      return "$difference days overdue";
    }
  }

  /*
  void _refreshData() {
    setState(() {
      basicGoals = null;
    });
  }
  */



/*
  showAlertDialog(BuildContext context, int id) {
    // set up the buttons
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        debugPrint("Yes pressed");
        DatabaseService().deletePass(id);
        _refreshData();
        Navigator.pop(context);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        debugPrint("No pressed");
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Do you want to remove this password?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


 */
}


