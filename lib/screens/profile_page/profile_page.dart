// profilePage.dart
// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/saved_recipes_page.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/screens/profile_page/components/recipe_card_profile_section.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/screens/settings_page/settings_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/CustomWidgets/weeklyMenu_section.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: themeProvider.currentTheme == ThemeType.dark
            ? const Color.fromARGB(255, 37, 36, 37)
            : Colors.white,
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Ensure alignment to the left
          children: [
            // Integrated TopProfile content
            SizedBox(
              height: Responsive.isDesktop(context) ? 350 : 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.user.gender == 'female' ||
                                widget.user.gender == 'male'
                            ? ImagePickerPreviewContainer(
                                containerSize: 75.0,
                                initialImagePath: widget.user.profileImage,
                                onImageSelected:
                                    (File imageFile, List<int> bytes) {},
                                allowSelection: false,
                                gender: widget.user.gender!,
                                isFor: '',
                                isForEdit: false,
                              )
                            : Container(),
                        Text(
                          widget.user.username,
                          style: TextStyle(
                            color: themeProvider.currentTheme == ThemeType.dark
                                ? Colors.white
                                : const Color.fromARGB(255, 37, 36, 37),
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.bookmark, size: 30),
                          onPressed: () {
                            // Navigation logic to saved recipes page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SavedRecipesPage(
                                  userId: widget.user.id,
                                ),
                              ),
                            );
                          },
                        ),
                        
                        Text(
                          AppLocalizations.of(context).translate('View Saved Recipes'),
                          style: TextStyle(
                            color: themeProvider.currentTheme == ThemeType.dark
                                ? Colors.white
                                : const Color.fromARGB(255, 37, 36, 37),
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10.0),
            HeadingTitleRow(
              title: AppLocalizations.of(context).translate('Weekly Menus'),
              onPressed: () {},
              showSeeALl: false,
              isForDiet: false,
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: WeeklyMenuSection(
                  showAll: false,
                  publicUsername: widget.user.username,
                  publicUserId: widget.user.id,
                  userRecipes: widget.user.recipes,
                  isForDiet: false,
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            HeadingTitleRow(
              title:
                  AppLocalizations.of(context).translate('Weekly Diet Menus'),
              onPressed: () {},
              showSeeALl: false,
              isForDiet: true,
            ),
            const SizedBox(height: 10.0),
            WeeklyMenuSection(
              showAll: false,
              publicUsername: widget.user.username,
              publicUserId: widget.user.id,
              userRecipes: widget.user.recipes,
              isForDiet: true,
            ),
            const SizedBox(height: 25.0),
            HeadingTitleRow(
              title: AppLocalizations.of(context).translate('Recipes'),
              onPressed: () {
                // Navigate to the corresponding page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipePage(
                            user: widget.user,
                            seeAll: false,
                          )),
                );
              },
              showSeeALl: false,
              isForDiet: false,
            ),
            const SizedBox(height: 10.0),
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child: RecipeCardProfileSection(
                    publicUsername: widget.user.username)),
          ],
        ),
      ),
    );
  }
}
