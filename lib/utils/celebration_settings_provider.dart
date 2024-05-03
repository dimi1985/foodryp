import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CelebrationSettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  int _daysBeforeNotification = 0;

  int get daysBeforeNotification => _daysBeforeNotification;

  CelebrationSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _daysBeforeNotification = _prefs.getInt('days_before_notification') ?? 0;
    notifyListeners();
  }

  Future<void> setDaysBeforeNotification(int days) async {
    _daysBeforeNotification = days;
    await _prefs.setInt('days_before_notification', days);
    notifyListeners();
  }
}
