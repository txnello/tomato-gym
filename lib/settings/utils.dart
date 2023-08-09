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
}