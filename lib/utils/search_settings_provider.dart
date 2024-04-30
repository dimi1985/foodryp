import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchSettingsProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  bool _searchOnEveryKeystroke = false;

  SearchSettingsProvider() {
    _loadSettings();
  }
  
  bool get searchOnEveryKeystroke => _searchOnEveryKeystroke;

  set searchOnEveryKeystroke(bool value) {
    _searchOnEveryKeystroke = value;
    _saveSettings();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _searchOnEveryKeystroke = _prefs.getBool('searchOnEveryKeystroke') ?? false;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool('searchOnEveryKeystroke', _searchOnEveryKeystroke);
  }
}
