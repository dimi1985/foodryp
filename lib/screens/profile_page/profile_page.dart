// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_page/components/recipe_card_profile_section.dart';
import 'package:foodryp/screens/profile_page/components/top_profile.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/screens/settings_page/settings_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/CustomWidgets/weeklyMenu_section.dart';

class ProfilePage extends StatefulWidget {
  User user;
  String? publicUsername;
  ProfilePage({
    super.key,
    required this.user,
    this.publicUsername,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String currentPage;
  final userService = UserService();
  User? userProfile;
  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    currentPage = 'ProfilePage';
  }

  Future<void> fetchUserProfile() async {
    if (widget.user.username.isEmpty) {
      // Fetch user profile if it's the logged-in user's profile
      userProfile = await userService.getUserProfile();
    } else {
      // Fetch public user profile if it's a different user's profile
      userProfile =
          await userService.getPublicUserProfile(widget.user.username);
    }

    setState(() {
      widget.user = userProfile ?? Constants.defaultUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (currentPage == 'ProfilePage')
            IconButton(
              // Show the settings icon button if 'ProfilePage' is present
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to ProfilePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(
                            user: widget.user,
                          )),
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          TopProfile(user: widget.user),
          const SizedBox(height: 10.0),
          HeadingTitleRow(
            title: AppLocalizations.of(context).translate('Weekly Menus'),
            onPressed: () {},
            showSeeALl: false,
          ),
          const SizedBox(height: 10.0),
          WeeklyMenuSection(
              showAll: false,
              publicUsername: widget.user.username,
              publicUserId: widget.user.id,
              userRecipes: widget.user.recipes),
          const SizedBox(height: 25.0),
          HeadingTitleRow(
              title: AppLocalizations.of(context).translate('Recipes'),
              onPressed: () {
                // Navigate to the corresponding page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipePage(
                            user: widget.user, seeAll: false,
                          )),
                );
              },
              showSeeALl: false),
          const SizedBox(height: 10.0),
          SizedBox(
              height: MediaQuery.of(context).size.height,
              child: RecipeCardProfileSection(
                  publicUsername: widget.user.username)),
        ],
      ),
    );
  }


}
