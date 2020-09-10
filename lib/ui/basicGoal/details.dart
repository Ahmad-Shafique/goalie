



import 'package:flutter/material.dart';
import 'package:goalie/models/basicGoal.dart';

class BasicGoalDetails extends StatefulWidget {
  BasicGoalDetails({Key key, this.goal}) : super(key: key);

  final String title="Goal Details";
  final BasicGoal goal;

  @override
  _BasicGoalDetailsState createState() {
    return _BasicGoalDetailsState();
  }
}

class _BasicGoalDetailsState extends State<BasicGoalDetails> {

  String calculateStartTimeDaysReturnString(DateTime date) {
    DateTime now = DateTime.now();
    int difference = now.difference(date).inDays;
    return "Goal started $difference days ago";
  }

  String calculateEndTimeDaysReturnString(DateTime date) {
    DateTime now = DateTime.now();
    if(date==null) return "Unlimited days left";
    int difference = now.difference(date).inDays;
    return "$difference Days left";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        print('Card tapped.');
                        //TODO TBD later
                      },
                      child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Text("Goal Name: "),
                                    Text(
                                        widget.goal.goalName
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Text("Start time: "),
                                    Text(
                                      calculateStartTimeDaysReturnString(widget.goal.startTime)
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Text("End time: "),
                                    Text(
                                      calculateEndTimeDaysReturnString(widget.goal.endTime)
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Text("Completed "),
                                    Checkbox(
                                      onChanged: null,
                                      value: widget.goal.completed,
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ),
                )
          ],
        ));
  }


}
