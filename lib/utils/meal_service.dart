import 'dart:convert';
import 'dart:developer';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/utils/contants.dart';
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
  ) async {
    // Extract recipe IDs from selected recipes
    List<String?> recipeIds =
        selectedRecipes.map((recipe) => recipe.id).toList();

    try {
      await _initPrefs();
      final userId = _prefs.getString('userId');
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/saveWeeklyMenu'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'dayOfWeek': recipeIds,
          'userId': userId,
          'username': username,
          'userProfileImage': userProfileImage,
        }),
      );

      if (response.statusCode == 201) {
        // Meal saved successfully
        return true;
      }
      return false;
    } catch (e) {
      print('Error saving weekly menu: $e');
      return false;
    }
  }

  static Future<List<WeeklyMenu>> getWeeklyMenusByPage(
      int page, int pageSize) async {
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
          log(jsonList.toString());
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
      print('Error fetching weekly menus: $e');
      // Handle error
      return [];
    }
  }
}
