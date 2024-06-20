import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/token_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
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
    List<String> likedRecipes,
    List<String> mealId,
    List<String> followedByRequest,
    String themePreference,
    String languagePreference,
  ) async {
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
          'followedByRequest': followedByRequest,
          'themePreference': themePreference,
          'languagePreference': languagePreference,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final userID = responseData['userId'];
        final token = responseData['token'];
        await saveUserIDLocally(userID);
        await TokenManager.saveTokenLocally(token);
        return true;
      } else {
        print('Error: ${responseData['message']}');
        return false;
      }
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

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final userID = responseData['userId'];
        final token = responseData['token'];
        await saveUserIDLocally(userID);
        TokenManager.clearTokenLocally();
        TokenManager.saveTokenLocally(token);

        return true;
      } else {
        print('Error: ${responseData['message']}');
        return false;
      }
    } catch (e) {
      print('Error logging in user: $e');
      return false;
    }
  }

  Future<User?> getUserProfile() async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager.getTokenLocally();
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/userProfile/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return User.fromJson(
            userData); // Return User object if profile is found
      } else {
        // Handle other status codes, e.g., profile not found
        print('Error fetching user profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle network errors or other exceptions
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
      final token = await TokenManager.getTokenLocally();
      final headers = {'Authorization': 'Bearer $token'};

      String url = '${Constants.baseUrl}/api/uploadProfilePic';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers to the request
      request.headers.addAll(headers);

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
        request.fields['userId'] = userId!;
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePicture',
            image.path,
          ),
        );
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        // Profile picture uploaded successfully
        // Handle the response data as needed
      } else {
        // Error uploading profile picture
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
      final token = await TokenManager.getTokenLocally();
      final headers = {'Authorization': 'Bearer $token'};

      final url = Uri.parse('${Constants.baseUrl}/api/deleteUser/$userId');
      final response = await http.delete(
        url,
        headers: headers, // Include authorization headers
      );

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

  Future<void> followUser(String userToFollowId) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager.getTokenLocally();
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/sendFollowRequest'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          ...headers, // Include authorization headers
        },
        body: jsonEncode({
          'userId': userId,
          'userToFollowId': userToFollowId,
        }),
      );
      if (response.statusCode == 200) {
        // Successfully followed user
        // You can update the UI or perform any other necessary actions
        print('Following User Sent!');
      } else {
        // Handle non-200 status code
        // You can show an error message to the user
        print('Following Not Sent!');
      }
    } catch (e) {
      print('Error following user: $e');
      // Handle error
      // You can show an error message to the user
    }
  }

  Future<bool> rejectFollowRequest(String userToRejectId) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager.getTokenLocally();
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/rejectFollowRequest'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          ...headers, // Include authorization headers
        },
        body: jsonEncode({
          'userId': userId, // The ID of the current user
          'userToRejectId':
              userToRejectId, // The ID of the user whose follow request is being rejected
        }),
      );
      if (response.statusCode == 200) {
        // Request rejected successfully
        // You can update the UI or perform any other necessary actions
        return true;
      } else {
        // Handle non-200 status code
        // You can show an error message to the user
        return false;
      }
    } catch (e) {
      print('Error rejecting follow request: $e');
      // Handle error
      // You can show an error message to the user
      return true;
    }
  }

  Future<bool> unFollow(String userToUnfollowId) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager.getTokenLocally();
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/unfollowUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          ...headers, // Include authorization headers
        },
        body: jsonEncode({
          'userId': userId, // The ID of the current user
          'userToUnfollowId':
              userToUnfollowId, // The ID of the user to unfollow
        }),
      );
      if (response.statusCode == 200) {
        // Successfully unfollowed user
        // You can update the UI or perform any other necessary actions
        return true;
      } else {
        // Handle non-200 status code
        // You can show an error message to the user
        return false;
      }
    } catch (e) {
      print('Error unfollowing user: $e');
      // Handle error
      // You can show an error message to the user
      return false;
    }
  }

  Future<bool> followBack(String userToFollowBackId) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager.getTokenLocally();
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/followUserBack'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          ...headers, // Include authorization headers
        },
        body: jsonEncode({
          'userId': userId, // The ID of the current user
          'userToFollowBackId':
              userToFollowBackId, // The ID of the user to follow back
        }),
      );
      if (response.statusCode == 200) {
        // Successfully followed user back
        // You can update the UI or perform any other necessary actions
        return true;
      } else {
        // Handle non-200 status code
        // You can show an error message to the user
        return false;
      }
    } catch (e) {
      print('Error following user back: $e');
      // Handle error
      // You can show an error message to the user
      return false;
    }
  }

  Future<void> saveUserIDLocally(String userId) async {
    await _initPrefs(); // Initialize SharedPreferences
    await _prefs.setString('userId', userId); // Save userID locally
  }

  Future<void> clearUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<String> getCurrentUserId() async {
    await _initPrefs();
    String? userId = _prefs.getString('userId');
    return userId ?? '';
  }

  Future<void> saveOneTimeSheetShow() async {
    await _initPrefs();
    await _prefs.setBool('OneTimeSheetShow', true);
  }

  Future<bool> getsaveOneTimeSheetShow() async {
    await _initPrefs();
    bool? oneTimeShow = _prefs.getBool('OneTimeSheetShow');
    return oneTimeShow ?? false;
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

      final token = await TokenManager
          .getTokenLocally(); // Implement your token retrieval logic

      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/changeCredentials/$userId'),
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newUsername': newUsername,
          'newEmail': newEmail,
          'newPassword': newPassword,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Credentials updated successfully
        // Handle success
        return true;
      } else {
        // Handle API errors
        throw Exception('Failed to update credentials: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error changing credentials: $e');
      throw Exception('Error changing credentials');
    }
  }

  Future<bool> addFridgeItem(String category, String name) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager.getTokenLocally();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/addFridgeItem'),
        headers: headers,
        body: jsonEncode({
          'userId': userId,
          'category': category,
          'name': name,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error adding fridge item: $e');
      return false;
    }
  }

  Future<List<dynamic>?> getFridgeItems() async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager.getTokenLocally();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final url = Uri.parse('${Constants.baseUrl}/api/getFridgeItems/$userId');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> fridgeItems = jsonDecode(response.body)['fridgeItems'];
        return fridgeItems;
      } else {
        print('Failed to load fridge items');
        return null;
      }
    } catch (e) {
      print('Error fetching fridge items: $e');
      return null;
    }
  }

  Future<bool> updateFridgeItem(
      String oldItemName, String newItemName, String newItemCategory) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager.getTokenLocally();

    final url = Uri.parse('${Constants.baseUrl}/api/updateFridgeItem');
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'userId': userId,
          'oldItemName': oldItemName,
          'newItem': {'name': newItemName, 'category': newItemCategory}
        }),
      );

      if (response.statusCode == 200) {
        print('Fridge item updated successfully.');
        return true;
      } else {
        print('Failed to update fridge item: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating fridge item: $e');
      return false;
    }
  }

  Future<bool> deleteFridgeItem(String itemName) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    final token = await TokenManager.getTokenLocally();

    try {
      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/api/deleteFridgeItem?itemName=$itemName&userId=$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete fridge item: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting fridge item: $e');
      return false;
    }
  }

  Future<bool> acceptFollowRequest(String targetUserId) async {
    try {
      final String userId = await getCurrentUserId();
      final token = await TokenManager.getTokenLocally();
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/acceptFollowRequest'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': userId,
          'targetUserId': targetUserId,
        }),
      );

      if (response.statusCode == 200) {
        print('Follow request accepted successfully.');
        return true;
      } else {
        print('Failed to accept follow request: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error accepting follow request: $e');
      return false;
    }
  }

  Future<bool> sendPin(String pin) async {
    try {
      final String? token =
          await TokenManager.getTokenLocally(); // Get JWT token
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/savePin'),
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Include Authorization header
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'pin': pin}),
      );

      if (response.statusCode == 200) {
        print('PIN saved successfully.');
        return true;
      } else {
        print('Failed to save PIN: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error saving PIN: $e');
      return false;
    }
  }

  Future<String?> fetchPin() async {
    await _initPrefs();

    final userId = _prefs.getString('userId');
    try {
      final token = await TokenManager
          .getTokenLocally(); // Implement your token retrieval logic

      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/getPin/$userId'), // Pass userId as part of the URL
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['pinHash']; // Return pinHash from the response
      } else {
        print('Failed to fetch PIN: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching PIN: $e');
      return null;
    }
  }

  Future<bool> validatePIN(String username, String pin) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/validatePIN'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username, 'pin': pin}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        return responseBody['error'] ?? 'Unknown error';
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String username, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/resetPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        // Password reset successfully
        print('Password reset successfully');
        return true;
      } else {
        print('Failed to reset password: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error resetting password: $e');
      return false;
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/checkUsernameExists'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['exists'];
      } else {
        print('Failed to check username: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }

  Future<bool> updateThemePreference(String themePreference) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String? token = await TokenManager
        .getTokenLocally(); // Adjust according to your token management
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    if (token == null || userId == null) {
      // Handle missing auth token or user ID
      return false;
    }

    try {
      print('themePreference $themePreference');
      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/theme'),
        headers: headers,
        body: jsonEncode({
          'userId': userId,
          'themePreference': themePreference,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating theme preference: $e');
      return false;
    }
  }

Future<bool> updateLanguagePreference(String languagePreference) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString('userId');
  final String? token = await TokenManager.getTokenLocally(); // Adjust according to your token management
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  if (token == null || userId == null) {
    // Handle missing auth token or user ID
    return false;
  }

  try {
    print('languagePreference $languagePreference');
    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/api/language'),
      headers: headers,
      body: jsonEncode({
        'userId': userId,
        'languagePreference': languagePreference,
      }),
    );

    return response.statusCode == 200;
  } catch (e) {
    print('Error updating language preference: $e');
    return false;
  }
}

 Future<String?> getThemePreference() async {
  await _initPrefs();
  final userId = _prefs.getString('userId');

  try {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/themePreference/$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['themePreference'];
    } else {
      print('Error fetching theme preference: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching theme preference: $e');
    return null;
  }
}
Future<String?> getLanguagePreference() async {
  await _initPrefs();
  final userId = _prefs.getString('userId');

  try {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/languagePreference/$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['languagePreference'];
    } else {
      print('Error fetching language preference: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching language preference: $e');
    return null;
  }
}


}
