import 'package:flutter/material.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/auth_screen/auth_screen.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuWebItems extends StatefulWidget {
  const MenuWebItems({Key? key}) : super(key: key);

  @override
  State<MenuWebItems> createState() => _MenuWebItemsState();
}

class _MenuWebItemsState extends State<MenuWebItems> {
  bool isAuthenticated = false; // Track user's authentication status

  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus(); // Check authentication status when widget is initialized
  }

  Future<void> checkAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    setState(() {
      isAuthenticated = userId !=
          null; // Update authentication status based on userId existence
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> menuItems = [
      'Home',
      'Creators',
      'Recipes',
      if (isAuthenticated) 'My Fridge',
      if (!isAuthenticated) 'Sign Up/Sign In',
      if (isAuthenticated) 'Add Recipe',
    ];

    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView(
      shrinkWrap: true,
      scrollDirection:
          Responsive.isDesktop(context) ? Axis.horizontal : Axis.vertical,
      children:
          menuItems.map((item) => _buildMenuItem(item, isAndroid,themeProvider)).toList(),
    );
  }

  Widget _buildMenuItem(String item, bool isAndroid, ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.all(
          Responsive.isMobile(context) ? 0 : Constants.defaultPadding),
      child: TextButton(
        onPressed: () {
          // Handle menu item tap (e.g., navigate to a different screen)
          switch (item) {
            case 'Sign Up/Sign In':
              // Navigate to AuthScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
              break;

            case 'Add Recipe':
              // Navigate to AddRecipePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddRecipePage(recipe: null, isForEdit: false,)),
              );
              break;
            // Add more cases for other menu items
            default:
              // Handle default case (optional)
              break;
          }
        },
        child: Text(
           AppLocalizations.of(context).translate(item),
          style: TextStyle(
            color: Responsive.isMobile(context) || Responsive.isTablet(context) || themeProvider.currentTheme == ThemeType.dark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isAndroid
                ? 30
                : Responsive.isMobile(context)
                    ? Constants.mobileFontSize
                    : Constants.desktopFontSize,
          ),
        ),
      ),
    );
  }

  
}
