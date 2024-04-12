import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService with ChangeNotifier {
  late SharedPreferences _prefs; // SharedPreferences instance
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<CategoryModel>> getAllCategories() async {
  final response = await http.get(
    Uri.parse('${Constants.baseUrl}/api/categories'),
  );

  log('${Constants.baseUrl}/api/categories');

  if (response.statusCode == 200) {
    final decodedData = jsonDecode(response.body) as List<dynamic>;

    final categories = decodedData.map((categoryJson) => CategoryModel.fromJson(categoryJson)).toList();
    log(categories.toList().toString());
    return categories;
  } else {
    // Handle API errors gracefully (e.g., throw an exception)
    throw Exception('Failed to load categories');
  }
}

 
  Future<bool> createCategory(
      String name, String font, String color, String categoryImage,List<String> recipes) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/saveCategory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'font': font,
          'color': color,
          'categoryImage': categoryImage,
             'recipes': recipes,
        }),
      );
      if (response.statusCode == 201) {
        // Registration successful
        final responseData = jsonDecode(response.body);
        String categoryId = responseData['categoryId'];
        // categoryId = id;
        log('categoryId $categoryId');
        await _saveCategoryIDLocally(categoryId);
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
    final categoryId = _prefs.getString('categoryId');

    try {
      String url = '${Constants.baseUrl}/api/uploadCategoryImage';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      if (image != null) {
        String filename = 'category-$categoryId-${DateTime.now()}.jpg';

        if (kIsWeb) {
          // For web platform
          request.fields['categoryId'] = categoryId!;
          request.files.add(
            http.MultipartFile.fromBytes(
              'categoryImage',
              bytes!,
              filename: filename,
            ),
          );
        } else {
          // For Android platform

          if (image != null) {
            request.fields['categoryId'] = categoryId!;
            request.files.add(
              await http.MultipartFile.fromPath(
                'categoryImage',
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

  Future<void> _saveCategoryIDLocally(String categoryId) async {
    await _initPrefs();
    await _prefs.setString('categoryId', categoryId);
  }

  Future<void> removeCategoryIDLocally() async {
  await _initPrefs();
  await _prefs.remove('categoryId');
}
}
