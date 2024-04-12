import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguageCode = 'en'; // Default language code is English

  String get currentLanguageCode => _currentLanguageCode;

  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    _currentLanguageCode = languageCode;
    // Notify listeners to update the UI language
    notifyListeners();
    log('provider got here');
    // Save the selected language code to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  Future<void> loadLanguage() async {
    // Load the selected language code from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('languageCode');
    log('load launguage got here with launguage code :  $savedLanguageCode');
    if (savedLanguageCode != null) {
      _currentLanguageCode = savedLanguageCode;
      notifyListeners();
    }
  }
}
