import 'package:flutter/material.dart';
import 'package:goalie/ui/basicGoal/listDisplay.dart';

void main() {
  runApp(MyGoalie());
}

class MyGoalie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goalie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GoalieActionsPage(title: 'Goalie Actions Page'),
    );
  }
}

class GoalieActionsPage extends StatefulWidget {
  GoalieActionsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GoalieActionsPageState createState() => _GoalieActionsPageState();
}

class _GoalieActionsPageState extends State<GoalieActionsPage> {

/*

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Goalie"),
      ),
      body: Center(
        child: BasicGoalsList(title:widget.title)
      ),

    );
  }
}
