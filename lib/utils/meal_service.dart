import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MealService {
  late SharedPreferences _prefs; // SharedPreferences instance
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }


 Future<bool> saveWeeklyMenu(
  String title,
  List<Recipe> selectedRecipes,
  String username,
  String userProfileImage,
  bool isForDiet,
  bool isMultipleDays) async {
  // Extract recipe IDs from selected recipes
  List<String?> recipeIds = selectedRecipes.map((recipe) => recipe.id).toList();

  try {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager.getTokenLocally();
    print('Token being sent: $token'); // Add this line to log the token
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/saveWeeklyMenu'),
      headers: headers,
      body: jsonEncode({
        'title': title,
        'dayOfWeek': recipeIds,
        'userId': userId,
        'username': username,
        'userProfileImage': userProfileImage.isEmpty ? '' : userProfileImage,
        'dateCreated': DateTime.now().toIso8601String(),
        'isForDiet': isForDiet,
        'isMultipleDays': isMultipleDays,
      }),
    );

    if (response.statusCode == 201) {
      // Meal saved successfully
      return true;
    }
    return false;
  } catch (e) {
    if (kDebugMode) {
      print('Error saving weekly menu: $e');
    }
    return false;
  }
}



  Future<List<WeeklyMenu>> getWeeklyMenusByPage(int page, int pageSize) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/getWeeklyMenusByPage?page=$page&pageSize=$pageSize'),
      );
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);

        if (jsonData == null) {
          // Handle null response
          return [];
        }

        if (jsonData is List) {
          final List<dynamic> jsonList = jsonData;

          return jsonList.map((json) => WeeklyMenu.fromJson(json)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          // If jsonData is a single object, wrap it in a list
          return [WeeklyMenu.fromJson(jsonData)];
        } else {
          // Handle unexpected response format
          return [];
        }
      } else {
        // Handle error response
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching weekly menus: $e');
      }
      // Handle error
      return [];
    }
  }

  Future<List<WeeklyMenu>> getWeeklyMenusFixedLength(int desiredLength) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/getWeeklyMenusFixedLength?length=$desiredLength'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData == null) {
          // Handle null response
          return [];
        }

        if (jsonData is List) {
          final List<dynamic> jsonList = jsonData;
          return jsonList.map((json) => WeeklyMenu.fromJson(json)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          // If jsonData is a single object, wrap it in a list
          return [WeeklyMenu.fromJson(jsonData)];
        } else {
          // Handle unexpected response format
          return [];
        }
      } else {
        // Handle error response
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching fixed-length weekly menus: $e');
      }
      // Handle error
      return [];
    }
  }

  Future<List<WeeklyMenu>> getWeeklyMenusByPageAndUser(int page, int pageSize) async {
  try {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager.getTokenLocally();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/getWeeklyMenusByPageAndUser/$userId?page=$page&pageSize=$pageSize'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);

      if (jsonData == null) {
        // Handle null response
        return [];
      }

      if (jsonData is List) {
        final List<dynamic> jsonList = jsonData;
        return jsonList.map((json) => WeeklyMenu.fromJson(json)).toList();
      } else if (jsonData is Map<String, dynamic>) {
        // If jsonData is a single object, wrap it in a list
        return [WeeklyMenu.fromJson(jsonData)];
      } else {
        // Handle unexpected response format
        return [];
      }
    } else {
      // Handle error response
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching weekly menus: $e');
    }
    // Handle error
    return [];
  }
}



  Future<List<WeeklyMenu>> getWeeklyMenusByPageAndPublicUser(
      int page, int pageSize, String publicUserId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/getWeeklyMenusByPageAndUser?page=$page&pageSize=$pageSize&userId=$publicUserId'),
      );
      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);

        if (jsonData == null) {
          // Handle null response
          return [];
        }

        if (jsonData is List) {
          final List<dynamic> jsonList = jsonData;

          return jsonList.map((json) => WeeklyMenu.fromJson(json)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          // If jsonData is a single object, wrap it in a list
          return [WeeklyMenu.fromJson(jsonData)];
        } else {
          // Handle unexpected response format
          return [];
        }
      } else {
        // Handle error response
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching weekly menus: $e');
      }
      // Handle error
      return [];
    }
  }

  Future<bool> updateWeeklyMenu(
    String mealId,
    String title,
    List<Recipe> oldRecipes,
    List<Recipe> newRecipes,
    String username,
    String userProfileImage,
    bool isForDiet,
    bool isMultipleDays) async {
  // Extract recipe IDs from old and new recipes
  List<String?> oldRecipeIds = oldRecipes.map((recipe) => recipe.id).toList();
  List<String?> newRecipeIds = newRecipes.map((recipe) => recipe.id).toList();

  try {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager.getTokenLocally();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/api/updateWeeklyMenu'),
      headers: headers,
      body: jsonEncode({
        'mealId': mealId,
        'title': title,
        'oldRecipes': oldRecipeIds,
        'newRecipes': newRecipeIds,
        'userId': userId,
        'username': username,
        'userProfileImage': userProfileImage,
        'dateCreated': DateTime.now().toIso8601String(),
        'isForDiet': isForDiet,
        'isMultipleDays': isMultipleDays,
      }),
    );

    if (response.statusCode == 200) {
      // Menu updated successfully
      return true;
    }
    return false;
  } catch (e) {
    if (kDebugMode) {
      print('Error updating weekly menu: $e');
    }
    return false;
  }
}


Future<bool> removeFromWeeklyMenu(
  String weeklyMenuId,
  List<Recipe> recipeIds,
) async {
  try {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager.getTokenLocally();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/removeFromWeeklyMenu/$weeklyMenuId'),
      headers: headers,
      body: jsonEncode({
        'userId': userId,
        'recipeIds': recipeIds.map((recipe) => recipe.id).toList(),
      }),
    );

    if (response.statusCode == 200) {
      return true; // Return true if removal is successful
    } else {
      return false; // Return false if removal fails
    }
  } catch (e) {
    print('Error removing recipe from weekly menu: $e');
    return false; // Return false if an error occurs
  }
}

}
