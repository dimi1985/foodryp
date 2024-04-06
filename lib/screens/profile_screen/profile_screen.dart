// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_screen/components/top_profile.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/top_creators.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/recipe_section.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/screens/profile_screen/components/recipe_card_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 User user = User(id: '', username: '', email: '', profileImage: '', gender: '',);



  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

Future<void> fetchUserProfile() async {
  final userService = UserService(); 
  final userProfile = await userService.getUserProfile(); 
  setState(() {
    user = userProfile ?? User(id: '', username: '', email: '', profileImage: '', gender: '');
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TopProfile(
            profileImage: user.profileImage.isNotEmpty ? user.profileImage : 'assets/default_avatar_male.jpg',
             gender: user.gender ?? '',
             profileName: user.username
          ),
          const SizedBox(height: 10.0),
          const HeadingTitleRow(title: 'Weekly Menus'),
       const   SizedBox(height: 10.0),
       const   RecipeCardProfile(),
       const   SizedBox(height: 25.0),
       const   HeadingTitleRow(title: 'Recipes'),
       const   SizedBox(height: 10.0),
      const    RecipeSection(),
       const   SizedBox(height: 15.0),
       const   HeadingTitleRow(title: 'Following'),
       const   TopCreators(),
       const   SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
