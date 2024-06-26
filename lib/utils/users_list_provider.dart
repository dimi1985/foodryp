import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/user_service.dart';

class UsersListProvider extends ChangeNotifier {
  late List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchAllUsers(bool valueSet) async {

    if(valueSet){
 try {
     
      final userList = await UserService.getAllUsers();
      _users = userList;
      notifyListeners();
    } catch (e) {
      print('Error fetching all users: $e');
    }

    }
   
  }
}
