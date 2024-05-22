// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/Following_recipes_page.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/auth_screen/auth_screen.dart';
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
  bool userIsNull = true;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      fetchUserProfile();
      userIsNull = false;
    } else {
      fetchUserProfile().then((value) {
        setState(() {
          userIsNull = false;
        });
      });
    }
  }

  Future<void> fetchUserProfile() async {
    bool oneTimeSave = await UserService().getsaveOneTimeSheetShow();
    if (!oneTimeSave) {
      _showSaveCredentialsBottomSheet();
    }
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
    } catch (e) {
      log("Error fetching user profile: $e");
    }
  }

  List<Widget> _widgetOptions(BuildContext context) {
    return <Widget>[
      MainScreen(user: user ?? Constants.defaultUser),
      const RecipePage(seeAll: false),
      if (user != null) const AddRecipePage(isForEdit: false),
      if (user != null) ProfilePage(user: user ?? Constants.defaultUser),
      if (user != null) CreatorsPage(user: user ?? Constants.defaultUser),
      if (user != null) MyFridgePage(user: user ?? Constants.defaultUser),
      if (user != null) const FollowingRecipesPage(),
      if (user == null) const AuthScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onContextMenuItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Set directly without offset
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryItemsCount = user != null ? 4 : 3; // Number of primary items
    final contextMenuItemsStartIndex =
        primaryItemsCount; // Start index for context menu items

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context).translate('Home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.food_bank),
            label: AppLocalizations.of(context).translate('Recipes'),
          ),
          if (user != null)
            BottomNavigationBarItem(
              icon: const Icon(Icons.add),
              label: AppLocalizations.of(context).translate('Add Recipes'),
            ),
          if (user != null)
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_box_rounded),
              label: user?.username ?? Constants.emptyField,
            ),
          if (user != null)
            BottomNavigationBarItem(
              icon: const Icon(Icons.more_horiz),
              label: AppLocalizations.of(context).translate('More'),
            ),
          if (user == null)
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle),
              label: AppLocalizations.of(context).translate('Auth Screen'),
            ),
        ],
        currentIndex: _selectedIndex < primaryItemsCount
            ? _selectedIndex
            : contextMenuItemsStartIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.amber[800], // Use any color that fits your design
        ),
        unselectedLabelStyle: Constants.globalTextStyle,
        onTap: (index) {
          if (index == contextMenuItemsStartIndex && user != null) {
            showModalBottomSheet(
              context: context,
              builder: (context) => ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.people_alt),
                    title: Text(
                        AppLocalizations.of(context).translate('Creators')),
                    onTap: () {
                      Navigator.pop(context);
                      _onContextMenuItemTapped(4); // Set to corresponding index
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.check_box_outline_blank_outlined),
                    title: Text(
                        AppLocalizations.of(context).translate('My Fridge')),
                    onTap: () {
                      Navigator.pop(context);
                      _onContextMenuItemTapped(5); // Set to corresponding index
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt),
                    title: Text(AppLocalizations.of(context)
                        .translate('Following Recipes Page')),
                    onTap: () {
                      Navigator.pop(context);
                      _onContextMenuItemTapped(6); // Set to corresponding index
                    },
                  ),
                ],
              ),
            );
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }

  void _showSaveCredentialsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).translate(
                    'Your session and NOT credentials is saved automaticly for a one-time login'),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await UserService().saveOneTimeSheetShow();
                      Navigator.pop(context);
                    },
                    child:
                        Text(AppLocalizations.of(context).translate('Thanks')),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
