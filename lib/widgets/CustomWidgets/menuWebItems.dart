import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/screens/add_recipe_page.dart';
import 'package:foodryp/screens/auth_screen/auth_screen.dart';
import 'package:foodryp/screens/profile_screen/profile_screen.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class MenuWebItems extends StatefulWidget {
  const MenuWebItems({super.key});

  @override
  State<MenuWebItems> createState() => _MenuWebItemsState();
}

class _MenuWebItemsState extends State<MenuWebItems> {
  @override
  Widget build(BuildContext context) {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return ListView(
      shrinkWrap: true,
      scrollDirection:
          Responsive.isDesktop(context) ? Axis.horizontal : Axis.vertical,
      children: DemoData.menuItems
          .map(
            (item) => _buildMenuItem(item, isAndroid),
          )
          .toList(),
    );
  }

  Widget _buildMenuItem(String item, bool isAndroid) {
    return Padding(
      padding: EdgeInsets.all(
          Responsive.isMobile(context) ? 0 : Constants.defaultPadding),
      child: TextButton(
        onPressed: () {
          // Handle menu item tap (e.g., navigate to a different screen)
          switch (item) {
            case 'Login/Register':
              // Navigate to Screen 1
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
              break;
            case 'ProfileDev':
              // Navigate to Screen 1
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              break;
            case 'Add Recipe':
              // Navigate to Screen 1
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddRecipePage()),
              );
              break;

            // Add more cases for other menu items
            default:
              // Handle default case (optional)
              break;
          }
        },
        child: Text(
          item,
          style: TextStyle(
              color:
                  Responsive.isMobile(context) || Responsive.isTablet(context)
                      ? Colors.white
                      : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: isAndroid
                  ? 30
                  : Responsive.isMobile(context)
                      ? Constants.mobileFontSize
                      : Constants.desktopFontSize),
        ),
      ),
    );
  }
}
