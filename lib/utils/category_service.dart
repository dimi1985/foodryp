import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  late SharedPreferences _prefs; // SharedPreferences instance
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/categories'),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List<dynamic>;

      final categories = decodedData
          .map((categoryJson) => CategoryModel.fromJson(categoryJson))
          .toList();

      return categories;
    } else {
      // Handle API errors gracefully (e.g., throw an exception)
      throw Exception('Failed to load categories');
    }
  }

  Future<List<CategoryModel>> getFixedCategories(int desiredLength) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.baseUrl}/api/categories/getFixedCategories?length=$desiredLength'),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List<dynamic>;

      final categories = decodedData
          .map((categoryJson) => CategoryModel.fromJson(categoryJson))
          .toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<CategoryModel>> getCategoriesByPage(
      int page, int pageSize) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/getCategoriesByPage?page=$page&pageSize=$pageSize'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<CategoryModel> categories = jsonData
            .map((categoryJson) => CategoryModel.fromJson(categoryJson))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<bool> createCategory(String name, String font, String color,
      String categoryImage, List<String> recipes) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/saveCategory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'font': font,
          'color': color,
          'recipes': recipes,
        }),
      );
      if (response.statusCode == 201) {
        // Registration successful
        final responseData = jsonDecode(response.body);
        String categoryId = responseData['categoryId'];
        // categoryId = id;

        await _saveCategoryIDLocally(categoryId);

        return true;
      }
      return false;
    } catch (e) {
      print('Error saving Category user: $e');
      return false;
    }
  }

  Future<bool> updateCategory(String categoryId, String name, String font,
      String color, String categoryImage, List<String> recipes) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/updateCategory/$categoryId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'font': font,
          'color': color,
          'recipes': recipes,
        }),
      );

      if (response.statusCode == 200) {
        // Update successful
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating category: $e');
      return false;
    }
  }

  Future<bool> deleteCategory(String categoryId) async {
    log(categoryId);
  try {
    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/deleteCategory/$categoryId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
     
      return true;
    }
    return false;
  } catch (e) {
    print('Error deleting category: $e');
    return false;
  }
}


  Future<void> _saveCategoryIDLocally(String categoryId) async {
    await _initPrefs();
    await _prefs.setString('categoryId', categoryId);
  }

  Future<void> removeCategoryIDLocally() async {
    await _initPrefs();
    await _prefs.remove('categoryId');
  }
}
