// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/creators_page/creators_page.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/screens/my_fridge_page.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  User? user;
  bool _isLoading = true;
  bool userIsNull = false;

  @override
  void initState() {
    super.initState();
    fetchUserProfile().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> fetchUserProfile() async {
    try {
      final userService = UserService();
      User? userProfile;

      if ((user?.username.isEmpty ?? true)) {
        userProfile =
            await userService.getUserProfile() ?? Constants.defaultUser;
      } else {
        userProfile = await userService.getPublicUserProfile(user!.username) ??
            Constants.defaultUser;
      }

      setState(() {
       
          user = userProfile;
     
      });
      log('Got user Info: ${user?.id}');
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  List<Widget> _widgetOptions(BuildContext context) {
    return <Widget>[
      MainScreen(user: user ?? Constants.defaultUser),
      CreatorsPage(user: user ?? Constants.defaultUser),
      MyFridgePage(user: user ?? Constants.defaultUser),
      const RecipePage(),
      const AddRecipePage(isForEdit: false),
      ProfilePage(user: user ?? Constants.defaultUser),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions(context),
            ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context).translate('Home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_alt),
              label: AppLocalizations.of(context).translate('Creators'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.check_box_outline_blank_outlined),
              label: AppLocalizations.of(context).translate('My Fridge'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.food_bank),
              label: AppLocalizations.of(context).translate('Recipes'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add),
              label: AppLocalizations.of(context).translate('Add Recipes'),
            ),
            if (user != null)
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          bottom: 2), // Adds padding below the icon
                      child: Icon(Icons.account_box_rounded),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 2), // Adds padding above the text
                      child: Text(
                        user?.username ?? Constants.emptyField,
                      ),
                    ),
                  ],
                ),
                label: AppLocalizations.of(context).translate('Profile'),
              ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.amber[800], // Use any color that fits your design
          ),
          unselectedLabelStyle: Constants.globalTextStyle,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
