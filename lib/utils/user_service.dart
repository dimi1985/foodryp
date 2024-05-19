import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/contants.dart';
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
        }),
      );
      if (response.statusCode == 201) {
        // Registration successful
        final responseData = jsonDecode(response.body);
        final userID = responseData['userId'];

        await _saveUserIDLocally(userID);
        _user = Constants.defaultUser;

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



Future<void> followUser(String userToFollowId) async {
  await _initPrefs();
  final userId = _prefs.getString('userId');
  try {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/sendFollowRequest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'userId': userId,
        'userToFollowId': userToFollowId,
      }),
    );
    if (response.statusCode == 200) {
      // Successfully followed user
      // You can update the UI or perform any other necessary actions
          print('Following Use Sent!!');
    } else {
      // Handle non-200 status code
      // You can show an error message to the user
       print('Following Not Sent!!');
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
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/rejectFollowRequest'),
      body: {
        'userId': userId, // The ID of the current user
        'userToRejectId': userToRejectId, // The ID of the user whose follow request is being rejected
      },
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
    // You can show a
    //n error message to the user
    return true;
  }
}




   Future<bool> unFollow(String userToUnfollowId) async {
  await _initPrefs();
  final userId = _prefs.getString('userId');
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/unfollowUser'),
        body: {
        'userId': userId, // The ID of the current user
        'userToUnfollowId': userToUnfollowId, // The ID of the user whose follow request is being rejected
      },
        // Add any necessary headers, such as authorization token
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


Future<bool> followBack(String userToFollowBackId) async {
  await _initPrefs();
  final userId = _prefs.getString('userId');
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/followUserBack'),
        body: {
        'userId': userId, // The ID of the current user
        'userToFollowBackId': userToFollowBackId, 
      },
        // Add any necessary headers, such as authorization token
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

  Future<bool> addFridgeItem(String category, String name) async {
    await _initPrefs();
    final userId = _prefs.getString('userId');
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/addFridgeItem'),
        headers: {'Content-Type': 'application/json'},
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
    final url = Uri.parse('${Constants.baseUrl}/api/getFridgeItems/$userId');
    try {
      final response = await http.get(url);

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

    final url = Uri.parse('${Constants.baseUrl}/api/updateFridgeItem');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
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
    try {
      final response = await http.delete(
        Uri.parse(
            '${Constants.baseUrl}/api/deleteFridgeItem?itemName=$itemName&userId=$userId'),
        headers: {
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
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/acceptFollowRequest'),
        headers: <String, String>{
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

  
}
