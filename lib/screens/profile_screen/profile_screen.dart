import 'package:flutter/material.dart';
import 'package:foodryp/screens/profile_screen/components/top_profile.dart';
import 'package:foodryp/widgets/CustomWidgets/top_creators.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/recipe_section.dart';

import '../../widgets/CustomWidgets/heading_title_row.dart';
import 'components/recipe_card_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User data (replace with your data fetching logic)
  final String userName = 'John Doe';
  final String userEmail = 'johndoe@example.com';
  final String profileImage = 'https://picsum.photos/seed/picsum/200/300';

  @override
  Widget build(BuildContext context) {
    //  final screenSize = MediaQuery.of(context).size;
    //  bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
        body: ListView(
              children: [
        TopProfile(profileImage:profileImage),
        const SizedBox(height: 10.0),
        const HeadingTitleRow(title: 'Weekly Menus'),
        const SizedBox(height: 10.0),
        const RecipeCardProfile(),
               
        const SizedBox(height: 25.0),
         const HeadingTitleRow(title: 'Recipes'),
               
        const SizedBox(height: 10.0),
        const RecipeSection(),
        const SizedBox(height: 15.0),
        const HeadingTitleRow(title: 'Following'),
        const TopCreators(),
        const SizedBox(height: 15.0),
              ],
            ));
  }



 
}
