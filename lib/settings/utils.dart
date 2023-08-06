// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tomato_gym/settings/app_localization.dart';

class Utils {
  String translate(BuildContext context, String tag) {
    return AppLocalization.of(context).getTranslatedValue(tag).toString();
  }
}