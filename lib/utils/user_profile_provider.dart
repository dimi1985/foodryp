import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';

class UserProfileProvider with ChangeNotifier {
  User? _user;

  User get user => _user ?? Constants.defaultUser;

  // This method now returns void because it updates the user state internally.
  Future fetchUserProfile(String username) async {
    UserService userService = UserService();
    User? userProfile;

    if (username.isEmpty) {
      userProfile = await userService.getUserProfile();
    } else {
      userProfile = await userService.getPublicUserProfile(username);
    }

    _user = userProfile;  // Assuming userProfile is successfully updated.
    notifyListeners();   // Notify listeners to rebuild the consumer widgets.
  }
}
