// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/comment.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/token_manager.dart';
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
    List<String> recomendedBy,
    List<WeeklyMenu> meal,
    List<Comment> commentId,
    bool isForDiet,
    bool isForVegetarians,
    double rating,
    int ratingCount,
    List<String> cookingAdvices,
    String calories,
    bool isPremium,
    double price,
    List<String>? buyers
  ) async {
     
    try {
      final token = await TokenManager.getTokenLocally();
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/saveRecipe'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          ...headers, // Include authorization headers
        },
        body: jsonEncode({
          'recipeTitle': recipeTitle,
          'ingredients': ingredients,
          'instructions': instructions,
          'prepDuration': prepDuration,
          'cookDuration': cookDuration,
          'servingNumber': servingNumber,
          'difficulty': difficulty,
          'username': username,
          'useImage': useImage,
          'userId': userId,
          'date': date.toIso8601String(),
          'description': description,
          'categoryId': categoryId,
          'categoryColor': categoryColor,
          'categoryFont': categoryFont,
          'categoryName': selectedCategoryName,
          'recomendedBy': recomendedBy,
          'meal': meal,
          'commentId': commentId,
          'isForDiet': isForDiet,
          'isForVegetarians': isForVegetarians,
          'rating': rating,
          'ratingCount': ratingCount,
          'cookingAdvices': cookingAdvices,
          'calories': calories,
          'isPremium': isPremium,
          'price': price,
          'buyers': buyers,
        }),
      );
      if (response.statusCode == 201) {
        // Recipe creation successful
        final responseData = jsonDecode(response.body);
        String recipeId = responseData['recipeId'];
        await _saveRecipeIDLocally(recipeId);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving recipe : $e');
      }
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
    List<String> recomendedBy,
    final List<String>? meal,
    final List<String>? commentId,
    bool isForDiet,
    bool isForVegetarians,
    double rating,
    int ratingCount,
    List<String> cookingAdvices,
    String calories,
      bool isPremium,
      double price,
    List<String>? buyers
  ) async {

    try {
      final token = await TokenManager.getTokenLocally();
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/updateRecipe/$recipeId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          ...headers, // Include authorization headers
        },
        body: jsonEncode({
          'recipeTitle': recipeTitle,
          'ingredients': ingredients,
          'instructions': instructions,
          'prepDuration': prepDuration,
          'cookDuration': cookDuration,
          'servingNumber': servingNumber,
          'difficulty': difficulty,
          'username': username,
          'useImage': userImage,
          'userId': userId,
          'dateCreated': date.toIso8601String(),
          'description': description,
          'categoryId': categoryId,
          'categoryColor': categoryColor,
          'categoryFont': categoryFont,
          'categoryName': selectedCategoryName,
          'recomendedBy': recomendedBy,
          'meal': meal,
          'commentId': commentId,
          'isForDiet': isForDiet,
          'isForVegetarians': isForVegetarians,
          'rating': rating,
          'ratingCount': ratingCount,
          'cookingAdvices': cookingAdvices,
          'calories': calories,
          'isPremium': isPremium,
          'price': price,
          'buyers': buyers,
        }),
      );
      if (response.statusCode == 200) {
        // Update successful
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating recipe: $e');
      }
      return false;
    }
  }

  Future<void> uploadRecipeImage(File image, List<int>? bytes) async {
    await _initPrefs();
    final recipeId = _prefs.getString('recipeId');
    final token = await TokenManager
        .getTokenLocally(); // Retrieve token from local storage
    final headers = {'Authorization': 'Bearer $token'};

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
            if (kDebugMode) {
              print('No file selected');
            }
            return;
          }
        }

        request.headers.addAll(headers); // Include authorization headers

        var response = await request.send();
        if (response.statusCode == 200) {
          // Recipe image uploaded successfully
          // Handle the response data as needed
        } else {
          // Error uploading recipe image
        }
      } else {
        // No image selected
        if (kDebugMode) {
          print('No file selected');
        }
      }
    } catch (e) {
      // Handle upload error
      if (kDebugMode) {
        print('Error uploading recipe image: $e');
      }
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
  final token = await TokenManager.getTokenLocally(); // Retrieve token from local storage
  final headers = {'Authorization': 'Bearer $token'};

  final response = await http.get(
    Uri.parse(
      '${Constants.baseUrl}/api/getUserRecipesByPage/$userId?page=$page&pageSize=$pageSize',
    ),
    headers: headers, // Include authorization headers
  );

  if (response.statusCode == 200) {
    final List<dynamic> decodedData = jsonDecode(response.body);

    final List<Recipe> recipes = decodedData.map((json) {
      return Recipe.fromJson(json);
    }).toList();

    return recipes;
  } else {
    print('Failed to load user recipes: ${response.body}');
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
    final token = await TokenManager
        .getTokenLocally(); // Retrieve token from local storage
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Include authorization token
    };

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/deleteRecipe/$recipeId'),
      headers: headers,
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
      if (kDebugMode) {
        print('Error fetching recipes: $error');
      }
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

    Future<void> invalidateCache() async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/invalidate-cache'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('Cache invalidated: ${data['message']}');
    } else {
      throw Exception('Failed to invalidate cache');
    }
  }

  Future<void> rateRecipe(String recipeId, double rating) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager
        .getTokenLocally(); // Retrieve token from local storage
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Include authorization token
    };

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/rateRecipe'),
      headers: headers,
      body: jsonEncode(
        {'recipeId': recipeId, 'userId': userId, 'rating': rating},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to rate recipe');
    }
  }

  static Future<List<Recipe>> getFollowingUsersRecipes() async {
    try {
      final String userId = await UserService().getCurrentUserId();
      final token = await TokenManager
          .getTokenLocally(); // Retrieve token from local storage
      final headers = {
        'Authorization': 'Bearer $token', // Include authorization token
      };

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/getFollowingUsersRecipes/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Recipe> recipes =
            body.map((dynamic item) => Recipe.fromJson(item)).toList();
        return recipes;
      } else {
        if (kDebugMode) {
          print('Failed to load following recipes: ${response.body}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching following recipes: $e');
      }
      return [];
    }
  }

  Future<bool> saveUserRecipe( String recipeId) async {
    await _initPrefs();
  final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager
          .getTokenLocally(); // Retrieve token from local storage
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include authorization token
      };

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/saveUserRecipes/$userId'),
        headers: headers,
        body: json.encode({'recipeId': recipeId}),
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user recipe: $e');
      }
      return false;
    }
  }

  Future<bool> removeUserRecipe(String recipeId) async {
        await _initPrefs();
  final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager
          .getTokenLocally(); // Retrieve token from local storage
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include authorization token
      };

      final uri =
          Uri.parse('${Constants.baseUrl}/api/removeUserRecipes/$userId');
      final response = await http.delete(
        uri,
        headers: headers,
        body: json.encode({'recipeId': recipeId}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to remove recipe');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing user recipe: $e');
      }
      return false;
    }
  }

  Future<List<String>> getUserSavedRecipes() async {
        await _initPrefs();
  final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager
          .getTokenLocally(); // Retrieve token from local storage
      final headers = {
        'Authorization': 'Bearer $token', // Include authorization token
      };

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/getUserSavedRecipes/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> savedRecipes = json.decode(response.body);
        log('Fetched saved recipes for user $userId: $savedRecipes',
            name: 'RecipeService');
        return savedRecipes.map((recipeId) => recipeId.toString()).toList();
      } else {
        log('Failed to fetch saved recipes for user $userId. Status code: ${response.statusCode}',
            name: 'RecipeService', error: true);
        throw Exception('Failed to load saved recipes');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching saved recipes: $e');
      }
      return [];
    }
  }

  Future<List<Recipe>> getUserSavedRecipesDetails() async {
        await _initPrefs();
  final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager
          .getTokenLocally(); // Retrieve token from local storage
      final headers = {
        'Authorization': 'Bearer $token', // Include authorization token
      };

      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/getUserSavedRecipesDetails/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> savedRecipes = json.decode(response.body);
        return savedRecipes
            .map((recipeJson) => Recipe.fromJson(recipeJson))
            .toList();
      } else {
        throw Exception('Failed to load saved recipes details');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching saved recipes details: $e');
      }
      return [];
    }
  }

Future<List<Recipe>> getPremiumRecipes() async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager.getTokenLocally(); // Retrieve token from local storage
      final headers = {
        'Authorization': 'Bearer $token', // Include authorization token
      };

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/premium_recipes/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
      
        return jsonData.map((item) => Recipe.fromJson(item)).toList();
      } else {
        log('Failed to fetch premium recipes for user $userId. Status code: ${response.statusCode}',
            name: 'RecipeService', error: true);
        throw Exception('Failed to load premium recipes');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching premium recipes: $e');
      }
      return [];
    }
  }

 Future<bool> isRecipePremium(String recipeId) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/recipes/isPremium/$recipeId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['isPremium'];
      } else {
        throw Exception('Failed to check if recipe is premium');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching premium status: $e');
      }
      return false;
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
