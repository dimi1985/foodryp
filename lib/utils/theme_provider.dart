import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_service.dart'; // Make sure to import the UserService

enum ThemeType { light, dark }

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = _buildThemeData(ThemeType.light);
  ThemeType _currentTheme = ThemeType.light;
  final UserService _userService = UserService(); // Initialize UserService

  ThemeProvider() {
    _loadThemePreference();
  }

  ThemeData get themeData => _themeData;

  ThemeType get currentTheme => _currentTheme;

 void toggleTheme() {
  _currentTheme = _currentTheme == ThemeType.light ? ThemeType.dark : ThemeType.light;
  _themeData = _buildThemeData(_currentTheme);
  _saveThemePreference(_currentTheme);
  _updateThemePreferenceOnServer(_currentTheme);
  notifyListeners();
}


  static ThemeData _buildThemeData(ThemeType themeType) {
    return themeType == ThemeType.light
        ? ThemeData.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Comfortaa',
            ))
        : ThemeData.dark().copyWith(
            textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Comfortaa',
            ));
  }

  Future<void> _loadThemePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? themeString = prefs.getString('theme');
    if (themeString != null) {
      _currentTheme = ThemeType.values.firstWhere((e) => e.toString() == themeString);
      _themeData = _buildThemeData(_currentTheme);
      notifyListeners();
    }
  }

  Future<void> _saveThemePreference(ThemeType themeType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeType.toString());
  }

  Future<void> _updateThemePreferenceOnServer(ThemeType themeType) async {
    final String themePreference = themeType.toString().split('.').last;
    final success = await _userService.updateThemePreference(themePreference);
    if (!success) {
      print('Failed to update theme preference on server');
    }
  }

}
