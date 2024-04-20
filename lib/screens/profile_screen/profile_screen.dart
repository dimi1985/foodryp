// ignore_for_file: library_private_types_in_public_api
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/creators_page/creators_page.dart';
import 'package:foodryp/screens/profile_screen/components/recipe_card_profile.dart';
import 'package:foodryp/screens/profile_screen/components/top_profile.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/screens/weekly_menu_page/weekly_menu_page.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/creators_section.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/CustomWidgets/weeklyMenu_section.dart';


class ProfilePage extends StatefulWidget {
  User user;
 ProfilePage({super.key, required this.user,});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    print('recieved: ${widget.user.username}');
  }

  Future<void> fetchUserProfile() async {
    final userService = UserService();
    User? userProfile;
   
    if (widget.user.username.isEmpty) {
      // Fetch user profile if it's the logged-in user's profile
      userProfile = await userService.getUserProfile();
    } else {
      // Fetch public user profile if it's a different user's profile
      userProfile = await userService.getPublicUserProfile(widget.user.username);
    }

    setState(() {
      widget.user = userProfile!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TopProfile(
           user:widget.user
          ),
          const SizedBox(height: 10.0),
          HeadingTitleRow(
            title: 'Weekly Menus',
            onPressed: () {
              // Navigate to the corresponding page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  WeeklyMenuPage()),
              );
            }, showSeeALl: true,
          ),
          const SizedBox(height: 10.0),
          const WeeklyMenuSection(),
          const SizedBox(height: 25.0),
          HeadingTitleRow(
            title: 'Recipes',
            onPressed: () {
              // Navigate to the corresponding page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecipePage()),
              );
            },
             showSeeALl: false
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 600,
            child: RecipeCardProfile(
                publicUsername: widget.user.username),
          ),
          const SizedBox(height: 15.0),
          HeadingTitleRow(
            title: 'Following',
            onPressed: () {
              // Navigate to the corresponding page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatorsPage()),
              );
            },showSeeALl: true,
          ),
          const Creators(
            showAllUsers: false,
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
