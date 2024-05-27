import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'jwtToken';

  // Function to save JWT token locally
  static Future<void> saveTokenLocally(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Function to retrieve JWT token locally
  static Future<String?> getTokenLocally() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

    // Function to clear  JWT token locally
  static Future<String?> clearTokenLocally() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
