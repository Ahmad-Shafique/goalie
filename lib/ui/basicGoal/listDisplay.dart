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
  bool fetchDataState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: buildOutput());
  }

  Widget buildOutput() {
    fetchData();

    return Column(
      children: <Widget>[
        Center(child: getTextWidgets()),
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
        fetchDataState = false;
      });
    });
  }

  Widget getTextWidgets() {
    if (basicGoals == null) {
      return CircularProgressIndicator();
    }

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
                        width: 350,
                        height: 100,
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
