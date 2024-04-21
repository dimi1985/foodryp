import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService with ChangeNotifier {
  late SharedPreferences _prefs; // SharedPreferences instance

  User? _user;

  User? get user => _user;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> registerUser(
      String username,
      String email,
      String password,
      String gender,
      List<String> recipes,
      List<String> following,
      List<String> followedBy,
      List<String> likedRecipes,List<String> mealId) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'gender': gender,
          'profileImage': '',
          'memberSince': DateTime.now().toIso8601String(),
          'role': 'user',
          'recipes': recipes,
          'following': following,
          'followedBy': followedBy,
          'likedRecipes': likedRecipes,
        }),
      );
      if (response.statusCode == 201) {
        // Registration successful
        final responseData = jsonDecode(response.body);
        final userID = responseData['userId'];

        await _saveUserIDLocally(userID);
        _user = User(
            id: userID,
            username: username,
            email: email,
            profileImage: '',
            gender: gender,
            memberSince: null,
            role: '',
            recipes: [],
            following: [],
            followedBy: [],
            likedRecipes: []);
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
        Uri.parse('${Constants.baseUrl}/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      notifyListeners();

      final responseData = jsonDecode(response.body);
      final userID = responseData['userId'];

      await _saveUserIDLocally(userID);
      return response.statusCode == 200;
    } catch (e) {
      print('Error logging in user: $e');
      return false;
    }
  }

  Future<User?> getUserProfile() async {
    await _initPrefs();
    final userId =
        _prefs.getString('userId'); // Use 'userId' instead of 'userID'

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/userProfile/$userId'),
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

  Future<User?> getPublicUserProfile(String username) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/getPublicUserProfile/$username'),
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

  Future<void> uploadImageProfile(File image, List<int>? bytes) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');

    try {
      String url = '${Constants.baseUrl}/api/uploadProfilePic';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      if (image != null) {
        String filename = 'user-$userId-${DateTime.now()}.jpg';

        if (kIsWeb) {
          // For web platform
          request.fields['userId'] = userId!;
          request.files.add(
            http.MultipartFile.fromBytes(
              'profilePicture',
              bytes!,
              filename: filename,
            ),
          );
        } else {
          // For Android platform

          if (image != null) {
            request.fields['userId'] = userId!;
            request.files.add(
              await http.MultipartFile.fromPath(
                'profilePicture',
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

//Admin Methods
  static Future<List<User>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/allUsers'), // Adjust the endpoint as per your API
      );
      if (response.statusCode == 200) {
        final List<dynamic> userDataList = jsonDecode(response.body);
        // Convert the list of dynamic data into a list of User objects
        final List<User> userList =
            userDataList.map((userData) => User.fromJson(userData)).toList();
        return userList;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  static getUsersByPage(int page, int pageSize) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${Constants.baseUrl}/api/getUsersByPage?page=$page&pageSize=$pageSize',
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> userDataList = jsonDecode(response.body);
        // Convert the list of dynamic data into a list of User objects
        final List<User> userList =
            userDataList.map((userData) => User.fromJson(userData)).toList();
        return userList;
      } else {
        // Handle non-200 status code
        return [];
      }
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  static Future<bool> updateUserRole(String userId, String newRole) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/userRole/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'role': newRole}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle error response
        print('Error updating user role: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle network error
      print('Network error: $e');
      return false;
    }
  }

  Future<void> deleteUser() async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    try {
      final url = Uri.parse('${Constants.baseUrl}/api/deleteUser/$userId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // User deleted successfully
        clearUserId();
        print('User deleted successfully');
      } else {
        // Handle error deleting user
        print('Error deleting user: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Network error: $e');
    }
  }

  Future<List<User>> getFollowingUsers() async {
    await _initPrefs(); // Initialize SharedPreferences
    final currentUserId = _prefs.getString('userId');
    final url = '${Constants.baseUrl}/api/getFollowingUsers/$currentUserId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> userDataList = jsonDecode(response.body);
      final List<User> followedUsers =
          userDataList.map((userData) => User.fromJson(userData)).toList();
      return followedUsers;
    } else {
      throw Exception('Failed to load followed users');
    }
  }

  Future<void> followUser(String userToFollow) async {
    await _initPrefs(); // Initialize SharedPreferences
    final userId = _prefs.getString('userId');
    try {
      const url = '${Constants.baseUrl}/api/followUser';
      final response = await http.post(
        Uri.parse(url),
        body: {'userToFollow': userToFollow, 'userId': userId},
      );

      if (response.statusCode == 200) {
        // Handle success
        print('User followed successfully');
      } else if (response.statusCode == 404) {
        // Handle user not found error
        print('User not found');
      } else {
        // Handle other errors
        print('Failed to follow user: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Error following user: $e');
    }
  }

  Future<void> unfollowUser(String userToUnfollow) async {
    await _initPrefs(); // Initialize SharedPreferences
    final userId = _prefs.getString('userId');
    try {
      const url = '${Constants.baseUrl}/api/unfollowUser';
      final response = await http.post(
        Uri.parse(url),
        body: {'userToUnfollow': userToUnfollow, 'userId': userId},
      );

      if (response.statusCode == 200) {
        // Handle success
        print('User unfollowed successfully');
      } else if (response.statusCode == 404) {
        // Handle user not found error
        print('User not found');
      } else {
        // Handle other errors
        print('Failed to unfollow user: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Error unfollowing user: $e');
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

  Future<String> getCurrentUserId() async {
    await _initPrefs(); // Initialize SharedPreferences
    String? userId =
        _prefs.getString('userId'); // Retrieve user ID from SharedPreferences
    return userId ?? ''; // Return user ID, or an empty string if not found
  }

  Future<bool> changeCredentials({
    required String oldPassword,
    required String newUsername,
    required String newEmail,
    required String newPassword,
  }) async {
    await _initPrefs(); // Initialize SharedPreferences
    final userId = _prefs.getString('userId');
    try {
      // Make API call to update user credentials
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/changeCredentials/$userId'),
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newUsername': newUsername,
          'newEmail': newEmail,
          'newPassword': newPassword,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Credentials updated successfully
        // Handle success
      } else {
        // Handle API errors
        throw Exception('Failed to update credentials: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error changing credentials: $e');
      throw Exception('Error changing credentials');
    }
    return true;
  }
}
