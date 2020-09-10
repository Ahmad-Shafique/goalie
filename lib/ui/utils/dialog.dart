

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicYesNoDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  //TODO implement the generic dialog later
/*
  int showAlertDialog(BuildContext context, int id, {yesString, }) {
    String yesString;
    String noString;
    String yesSuccessString;
    String noSuccessString;
    String titleText;

    // set up the buttons
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        debugPrint("Yes pressed");

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