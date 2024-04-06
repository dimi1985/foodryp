import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class UserService with ChangeNotifier {
  static const baseUrl = kIsWeb ?  'http://localhost:3000' : 'http://192.168.106.229:3000';


late SharedPreferences _prefs; // SharedPreferences instance

  User? _user;

  User? get user => _user;


   Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }


  Future<bool> registerUser(String username, String email, String password, String gender) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'gender': gender,
        }),
      );
      if (response.statusCode == 201) {
        // Registration successful
        final responseData = jsonDecode(response.body);
        final userID = responseData['userId']; 
        log('registerUser $userID');
        await _saveUserIDLocally(userID);
        _user = User(id: userID, username: username, email: email, profileImage: '', gender: gender);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }




  Future<bool> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
          notifyListeners();

          final responseData = jsonDecode(response.body);
        final userID = responseData['userId']; 
        log('loginUser $userID');
        await _saveUserIDLocally(userID);
      return response.statusCode == 200;
      
    } catch (e) {
      print('Error logging in user: $e');
      return false;
    }
  }

   
  Future<User?> getUserProfile() async {
    await _initPrefs(); 
  final userId = _prefs.getString('userId'); // Use 'userId' instead of 'userID'
  log(userId??'');
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/userProfile/$userId'),
    );
    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      return User.fromJson(userData);
    }
    return null;
  } catch (e) {
    print('Error fetching user profile: $e');
    return null;
  }
}


Future<void> uploadImageProfile(File imageFile) async {
  try {
    String url = '$baseUrl/api/uploadProfilePic';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    if (imageFile != null) {
      var stream = imageFile.openRead();
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'profilePicture',
        stream,
        length,
        filename: imageFile.path,
      );
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        // Profile picture uploaded successfully
        // Handle the response data as needed
      } else {
        // Error uploading profile picture
   
      }
    } else {
      // No image selected
      print('No file selected');
    }
  } catch (e) {
    // Handle upload error
    print('Error uploading profile picture: $e');
  }
}

  Future<void> _saveUserIDLocally(String userId) async {
    await _initPrefs(); // Initialize SharedPreferences
    await _prefs.setString('userId', userId); // Save userID locally
  }

Future<void> clearUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }


}



     



