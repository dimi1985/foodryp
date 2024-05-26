import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeService {
  late SharedPreferences _prefs; // SharedPreferences instance
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Recipe>> getFixedRecipes(int desiredLength) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.baseUrl}/api/recipes/getFixedRecipes?length=$desiredLength'),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List<dynamic>;

      final recipes =
          decodedData.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();

      return recipes;
    } else {
      // Handle API errors gracefully (e.g., throw an exception)
      return [];
    }
  }

  Future<List<Recipe>> getRecipesByPage(int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.baseUrl}/api/recipes/getRecipesByPage?page=$pageNumber&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List<dynamic>;

      final recipes =
          decodedData.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
      return recipes;
    } else {
      // Handle API errors gracefully (e.g., throw an exception)

      return [];
    }
  }

  Future<bool> createRecipe(
      String recipeTitle,
      List<String> ingredients,
      List<String> instructions,
      String prepDuration,
      String cookDuration,
      String servingNumber,
      String difficulty,
      String username,
      String useImage,
      String userId,
      DateTime date,
      String description,
      String categoryId,
      String categoryColor,
      String categoryFont,
      String selectedCategoryName,
      List<String> likedBy,
      List<WeeklyMenu> meal,
      bool isForDiet,
      bool isForVegetarians,
      List<String> cookingAdvices,
      String calories) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/saveRecipe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'recipeTitle': recipeTitle,
          'ingredients': ingredients,
          'instructions': instructions,
          'prepDuration': prepDuration,
          'cookDuration': cookDuration,
          'difficulty': difficulty,
          'servingNumber': servingNumber,
          'username': username,
          'useImage': useImage,
          'userId': userId,
          'date': date.toIso8601String(),
          'description': description,
          'categoryId': categoryId,
          'categoryColor': categoryColor,
          'categoryFont': categoryFont,
          'categoryName': selectedCategoryName,
          'likedBy': [],
          'isForDiet': isForDiet,
          'isForVegetarians': isForVegetarians,
          'cookingAdvices': cookingAdvices,
          'calories': calories,
        }),
      );
      if (response.statusCode == 201) {
        // Registration successful
        final responseData = jsonDecode(response.body);
        String recipeId = responseData['recipeId'];
        // categoryId = id;

        await _saveRecipeIDLocally(recipeId);
        return true;
      }
      return false;
    } catch (e) {
      print('Error saving recipe : $e');
      return false;
    }
  }

  Future<bool> updateRecipe(
      String recipeId,
      String recipeTitle,
      List<String> ingredients,
      List<String> instructions,
      String prepDuration,
      String cookDuration,
      String servingNumber,
      String difficulty,
      String username,
      String userImage,
      String userId,
      DateTime date,
      String description,
      String categoryId,
      String categoryColor,
      String categoryFont,
      String selectedCategoryName,
      List<String> likedBy,
      bool isForDiet,
      bool isForVegetarians,
      List<String> cookingAdvices,
      String calories) async {
    print(recipeId);
    try {
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/updateRecipe/$recipeId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'recipeTitle': recipeTitle,
          'ingredients': ingredients,
          'instructions': instructions,
          'prepDuration': prepDuration,
          'cookDuration': cookDuration,
          'difficulty': difficulty,
          'servingNumber': servingNumber,
          'username': username,
          'useImage': userImage,
          'userId': userId,
          'date': date.toIso8601String(),
          'description': description,
          'categoryId': categoryId,
          'categoryColor': categoryColor,
          'categoryFont': categoryFont,
          'categoryName': selectedCategoryName,
          'likedBy': likedBy,
          'isForDiet': isForDiet,
          'isForVegetarians': isForVegetarians,
          'cookingAdvices': cookingAdvices,
          'calories': calories,
        }),
      );
      if (response.statusCode == 200) {
        // Update successful
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating recipe: $e');
      return false;
    }
  }

  Future<void> uploadRecipeImage(File image, List<int>? bytes) async {
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

  Future<List<Recipe>> getAllRecipesByPage(int page, int pageSize) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.baseUrl}/api/getAllRecipesByPage?page=$page&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);

      final List<Recipe> recipes = decodedData.map((json) {
        return Recipe.fromJson(json);
      }).toList();

      return recipes;
    } else {
      return [];
    }
  }

  Future<List<Recipe>> getUserRecipesByPage(int page, int pageSize) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');

    final response = await http.get(
      Uri.parse(
          '${Constants.baseUrl}/api/getUserRecipesByPage/$userId?page=$page&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);

      final List<Recipe> recipes = decodedData.map((json) {
        return Recipe.fromJson(json);
      }).toList();

      return recipes;
    } else {
      return [];
    }
  }

  Future<List<Recipe>> getUserPublicRecipesByPage(
      String username, int page, int pageSize) async {
    final response = await http.get(
      Uri.parse(
          '${Constants.baseUrl}/api/getUserPublicRecipes/$username?page=$page&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);

      final List<Recipe> recipes = decodedData.map((json) {
        return Recipe.fromJson(json);
      }).toList();

      return recipes;
    } else {
      return [];
    }
  }

  Future<void> recommendRecipe(String recipeId) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/recipe/likeRecipe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'recipeId': recipeId, 'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like recipe');
    }
  }

  Future<void> unRecommendRecipe(String recipeId) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/recipe/dislikeRecipe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'recipeId': recipeId, 'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to dislike recipe');
    }
  }

  Future<bool> deleteRecipe(String recipeId) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/deleteRecipe/$recipeId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Recipe>> getRecipesByCategory(
      String categoryName, int page, int pageSize) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/getRecipesByCategory/$categoryName?page=$page&pageSize=$pageSize'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);

        final List<Recipe> recipes = decodedData.map((json) {
          return Recipe.fromJson(json);
        }).toList();

        return recipes;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Recipe>> getRecipesByCategoryByLikes(
      String categoryName, int page, int pageSize) async {
    print('Method Called');
    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/getRecipesByCategoryByLikes/$categoryName?page=$page&pageSize=$pageSize'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);

        final List<Recipe> recipes = decodedData.map((json) {
          return Recipe.fromJson(json);
        }).toList();

        return recipes;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Recipe>> getRecipesBySearch(
      String searchQuery, int page, int pageSize) async {
    // Encodes the search query to handle special characters in URL
    final encodedQuery = Uri.encodeComponent(searchQuery);
    final url = Uri.parse(
        '${Constants.baseUrl}/api/searchRecipesByName?query=$encodedQuery&page=$page&pageSize=$pageSize');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Decode the JSON response and extract 'recipes' data
        List<dynamic> data = jsonDecode(response.body)['recipes'];
        // Map each JSON object to a Recipe model
        return data.map((recipeData) => Recipe.fromJson(recipeData)).toList();
      } else {
        return [];
      }
    } catch (error) {
      print('Error fetching recipes: $error');
      return [];
    }
  }

  Future<List<Recipe>> fetchTopThreeRecipes() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/getTopThreeRecipes'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch top three recipes');
    }
  }

  Future<void> rateRecipe(String recipeId, double rating) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/rateRecipe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'recipeId': recipeId, 'userId': userId, 'rating': rating}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to rate recipe');
    }
  }

  static Future<List<Recipe>> getFollowingUsersRecipes() async {
    try {
      final String userId = await UserService().getCurrentUserId();
      final response = await http.get(Uri.parse(
          '${Constants.baseUrl}/api/getFollowingUsersRecipes/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Recipe> recipes =
            body.map((dynamic item) => Recipe.fromJson(item)).toList();
        return recipes;
      } else {
        print('Failed to load following recipes: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching following recipes: $e');
      return [];
    }
  }

  Future<bool> saveUserRecipe(String userId, String recipeId) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/saveUserRecipes/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'recipeId': recipeId}),
    );
    return response.statusCode == 200;
  }

  Future<bool> removeUserRecipe(String userId, String recipeId) async {
    final uri = Uri.parse('${Constants.baseUrl}/api/removeUserRecipes/$userId');
    log('recipeId :$recipeId');
    log('userId: $userId');
    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'recipeId': recipeId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to remove recipe');
    }
  }

 Future<List<String>> getUserSavedRecipes(String userId) async {
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/api/getUserSavedRecipes/$userId'));
      if (response.statusCode == 200) {
        List<dynamic> savedRecipes = json.decode(response.body);
        log('Fetched saved recipes for user $userId: $savedRecipes', name: 'RecipeService');
        return savedRecipes.map((recipeId) => recipeId.toString()).toList();
      } else {
        log('Failed to fetch saved recipes for user $userId. Status code: ${response.statusCode}', name: 'RecipeService', error: true);
        throw Exception('Failed to load saved recipes');
      }
    } catch (e) {
      log('Exception occurred while fetching saved recipes for user $userId: $e', name: 'RecipeService', error: e);
      throw e;
    }
  }

    Future<List<Recipe>> getUserSavedRecipesDetails(String userId) async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/api/getUserSavedRecipesDetails/$userId'));
    if (response.statusCode == 200) {
      List<dynamic> savedRecipes = json.decode(response.body);
      return savedRecipes.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
    } else {
      throw Exception('Failed to load saved recipes details');
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
