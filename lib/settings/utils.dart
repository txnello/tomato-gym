// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_gym/settings/app_localization.dart';

class Utils {
  String translate(BuildContext context, String tag) {
    return AppLocalization.of(context).getTranslatedValue(tag).toString();
  }

  Future<bool?> errorMessage(BuildContext context, String tag) {
    return Fluttertoast.showToast(
      msg: Utils().translate(context, tag),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  Future<bool?> successMessage(BuildContext context, String tag) {
    return Fluttertoast.showToast(
      msg: Utils().translate(context, tag),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  showAlertDialog(BuildContext context, String title, String text, VoidCallback onYes) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(Utils().translate(context, "generic_no")),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(Utils().translate(context, "generic_yes")),
      onPressed:  onYes,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}