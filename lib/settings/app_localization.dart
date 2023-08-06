import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  late final Locale _locale;

  AppLocalization(this._locale);

  // Useful for directly accessing using `.of(context)`
  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  // This is a Map of  language with its key and translated value pair
  late Map<String, String> _localizedValues;

  // This function will load `.json` file of a requested language.
  // Then decode it. And after that add it to `_localizedValues` map.
  Future loadLanguage() async {
    String jsonStringValues =
        await rootBundle.loadString("assets/lang/${_locale.languageCode}.json");

    Map<String, dynamic> mappedValues = json.decode(jsonStringValues);

    _localizedValues =
        mappedValues.map((key, value) => MapEntry(key, value.toString()));
  }

  // This will return the translated value from the `_localizedValues` map
  String? getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  // Will check if the user's locale is supported by our App
  @override
  bool isSupported(Locale locale) {
    return ["en", "it"].contains(locale.languageCode);
  }

  // Will load the equivalent json file requested by the user
  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization appLocalization = AppLocalization(locale);
    await appLocalization.loadLanguage();
    return appLocalization;
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}