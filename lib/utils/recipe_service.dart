import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeService with ChangeNotifier {
  late SharedPreferences _prefs; // SharedPreferences instance
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Recipe>> getAllRecipes() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/recipes'),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List<dynamic>;

      final recipes =
          decodedData.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
      log(recipes.toList().toString());
      return recipes;
    } else {
      // Handle API errors gracefully (e.g., throw an exception)
      throw Exception('Failed to load recipes');
    }
  }

  Future<bool> createCategory(
    String recipeTitle,
    String recipeImage,
    List<String> ingredients,
    int duration,
    String difficulty,
    String username,
    String useImage,
    String userId,
    DateTime date,
    String description,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/saveRecipe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'recipeTitle': recipeTitle,
          'recipeImage': recipeImage,
          'ingredients': ingredients,
          'duration': duration,
          'difficulty': difficulty,
          'username': username,
          'useImage': useImage,
          'userId': userId,
          'date': date,
          'description': description,
        }),
      );
      if (response.statusCode == 201) {
        // Registration successful
        final responseData = jsonDecode(response.body);
        String recipeId = responseData['recipeId'];
        // categoryId = id;
        log('categoryId $recipeId');
        await _saveRecipeIDLocally(recipeId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error saving Category user: $e');
      return false;
    }
  }

  Future<void> uploadCategoryImage(File image, List<int>? bytes) async {
    await _initPrefs();
    final recipeId = _prefs.getString('recipeId');
    try {
      String url = '${Constants.baseUrl}/api/uploadRecipeImage';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      if (image != null) {
        String filename = 'recipe-$recipeId-${DateTime.now()}.jpg';

        if (kIsWeb) {
          // For web platform
          request.fields['recipeId'] = recipeId!;
          request.files.add(
            http.MultipartFile.fromBytes(
              'recipeImage',
              bytes!,
              filename: filename,
            ),
          );
        } else {
          // For Android platform

          if (image != null) {
            request.fields['recipeId'] = recipeId!;
            request.files.add(
              await http.MultipartFile.fromPath(
                'recipeImage',
                image.path,
              ),
            );
          } else {
            // No image selected on Android
            print('No file selected');
            return;
          }
        }

        var response = await request.send();
        if (response.statusCode == 200) {
          // Profile picture uploaded successfully
          // Handle the response data as needed
        } else {
          // Error uploading profile picture
        }
      } else {
        // No image selected on web
        print('No file selected');
      }
    } catch (e) {
      // Handle upload error
      print('Error uploading profile picture: $e');
    }
  }

  Future<void> _saveRecipeIDLocally(String recipeId) async {
    await _initPrefs();
    await _prefs.setString('recipeId', recipeId);
  }

    Future<void> removeRecipeIDLocally() async {
  await _initPrefs();
  await _prefs.remove('recipeId');
}
}
