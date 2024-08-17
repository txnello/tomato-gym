// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_gym/settings/app_localization.dart';
import 'package:tomato_gym/widgets/customTextField.dart';

class Utils {
  String translate(BuildContext context, String tag) {
    return AppLocalization.of(context).getTranslatedValue(tag).toString();
  }

  Future<bool?> errorMessage(BuildContext context, String tag, {bool translate = true}) {
    return Fluttertoast.showToast(
      msg: translate ? Utils().translate(context, tag) : tag,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  Future<bool?> successMessage(BuildContext context, String tag, {bool translate = true}) {
    return Fluttertoast.showToast(
      msg: translate ? Utils().translate(context, tag) : tag,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  showBooleanAlertDialog(BuildContext context, String title, String text, VoidCallback onYes) {
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

  showInfoAlertDialog(BuildContext context, String title, String text) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        okButton,
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

  showInputAlertDialog(BuildContext context, String title, TextEditingController controller, String hintText, VoidCallback onConfirm, {int maxLength = 300, bool numbersOnly = false, bool textAlignCenter = false}) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: onConfirm,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: CustomTextField(
        controller: controller,
        hintText: hintText,
        maxLength: maxLength,
        numbersOnly: numbersOnly,
        textAlignCenter: textAlignCenter,
      ),
      actions: [
        okButton,
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