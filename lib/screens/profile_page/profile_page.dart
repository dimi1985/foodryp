// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_page/components/recipe_card_profile.dart';
import 'package:foodryp/screens/profile_page/components/top_profile.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_app_bar.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/CustomWidgets/menuWebItems.dart';
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
  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    currentPage = 'ProfilePage';
  }

  Future<void> fetchUserProfile() async {
    final userService = UserService();
    User? userProfile;

    if (widget.user.username.isEmpty) {
      // Fetch user profile if it's the logged-in user's profile
      userProfile = await userService.getUserProfile();
    } else {
      // Fetch public user profile if it's a different user's profile
      userProfile =
          await userService.getPublicUserProfile(widget.user.username);
    }

    setState(() {
      widget.user = userProfile!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      appBar: kIsWeb
          ? CustomAppBar(
              isDesktop: true,
              isAuthenticated: true,
              profileImage: '',
              username: '',
              user: widget.user,
              menuItems: isDesktop
                  ? MenuWebItems(
                      user: widget.user,
                      currentPage: currentPage,
                    )
                  : Container(),
            )
          : AppBar(),
      body: ListView(
        children: [
          TopProfile(user: widget.user),
          const SizedBox(height: 10.0),
          HeadingTitleRow(
            title: 'Weekly Menus',
            onPressed: () {},
            showSeeALl: false,
          ),
          const SizedBox(height: 10.0),
          WeeklyMenuSection(
              showAll: false,
              publicUsername: widget.user.username,
              publicUserId: widget.user.id),
          const SizedBox(height: 25.0),
          HeadingTitleRow(
              title: 'Recipes',
              onPressed: () {
                // Navigate to the corresponding page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipePage(
                            user: widget.user,
                          )),
                );
              },
              showSeeALl: false),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 600,
            child: RecipeCardProfile(publicUsername: widget.user.username),
          ),
        ],
      ),
    );
  }
}
