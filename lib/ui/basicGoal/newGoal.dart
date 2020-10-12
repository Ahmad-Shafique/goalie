import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:goalie/models/basicGoal.dart';
import 'package:goalie/services/sqfliteBasicGoalsService.dart';

class NewBasicGoalForm extends StatefulWidget {
  NewBasicGoalForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewBasicGoalForm createState() {
    return _NewBasicGoalForm();
  }
}

class _NewBasicGoalForm extends State<NewBasicGoalForm> {
  final _goalNameController = TextEditingController();
  DateTime _startTimeController;
  DateTime _endTimeController;
  final _newBasicGoalFormKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
                fit: FlexFit.loose,
                child: Center(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          print('Card tapped.');
                          //TODO TBD later
                        },
                        child: Container(
                            child: Column(
                              children: <Widget>[createForm()],
                            )),
                      ),
                    ))),
          ],
        ),));
  }

  void putInStartDate(DateTime time) {
    this._startTimeController = time;
  }

  void putInEndDate(DateTime time) {
    this._endTimeController = time;
  }

  Widget createForm() {
    return Form(
      key: _newBasicGoalFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(fit: FlexFit.loose, child: TextFormField(
            controller: _goalNameController,
            decoration: const InputDecoration(
              labelText: 'Goal Name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter a goal name please';
              }
              return null;
            },
          )),
          Flexible(fit: FlexFit.loose, child: DateTimeFormField(
            autovalidate: true,
            //firstDate: selectedDate,
            initialValue: selectedDate,
            label: "Start Time",
            onDateSelected: putInStartDate,
          )),
          Flexible(fit: FlexFit.loose, child: DateTimeFormField(
            autovalidate: false,
            enabled: true,
            firstDate: selectedDate,
            lastDate: selectedDate.add(new Duration(days: 30)),
            initialValue: selectedDate.add(new Duration(days: 1)),
            label: "End Time",
            onDateSelected: putInEndDate,
          )),
          Flexible(fit: FlexFit.loose, child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
            child: RaisedButton(
              onPressed: () {
                if (_newBasicGoalFormKey.currentState.validate()) {
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Activating new Goal')));
                  /*
                  print("Goal name is: " +
                      _goalNameController.text +
                      " Start time is: " +
                      _startTimeController.toString());
                   */
                  SQLiteBasicGoalDatabaseService().insertOrReplaceBasicGoal(
                      new BasicGoal(
                          goalName: _goalNameController.text,
                          startTime: _startTimeController != null
                              ? _startTimeController
                              : selectedDate,
                          endTime: _endTimeController != null
                              ? _endTimeController
                              : null,
                          lastUpdated: selectedDate,
                          active: true,
                          completed: false));
                  Navigator.pop(context);
                }
              },
              child: Text('Confirm'),
            ),
          )),
        ],
      ),
    );
  }
}
