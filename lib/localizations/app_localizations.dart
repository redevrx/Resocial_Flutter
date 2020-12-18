import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class AppLocalizations {
  Locale _locale;

  AppLocalizations(Locale locale) {
    this._locale = locale;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  void keepLocaleKey(String localeKey) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.remove("localeKey");
    await _prefs.setString("localeKey", localeKey);
  }

  Future<String> readLocaleKey() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString("localeKey");
  }

  void setLocale(BuildContext context, Locale locale) async {
    //keep value in shared pref
    keepLocaleKey(locale.languageCode);
    print("key language :${locale.languageCode}");
    MyApp.setLocale(context, locale);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _appLocalizaionDelegate();

  Map<String, dynamic> _localizedStrings;

  Future<bool> load() async {
    // Load JSON file from the "language" folder
    String jsonString = await rootBundle.loadString(
        "assets/language/json/localization_${_locale.languageCode}.json");
    _localizedStrings = json.decode(jsonString);
  }

  // called from every widget which needs a localized text
  String translate(String jsonkey) {
    return _localizedStrings[jsonkey].toString() ?? "not found";
  }
}

class _appLocalizaionDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _appLocalizaionDelegate();

  @override
  bool isSupported(Locale locale) => ["th", "en"].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocalizations = new AppLocalizations(locale);
    await appLocalizations.load();
    return appLocalizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
