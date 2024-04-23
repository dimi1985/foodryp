import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/auth_screen/auth_screen.dart';
import 'package:foodryp/screens/creators_page/creators_page.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuWebItems extends StatefulWidget {
  final User? user;
  final String currentPage; // Add this parameter

  const MenuWebItems({Key? key, required this.user, required this.currentPage})
      : super(key: key);

  @override
  State<MenuWebItems> createState() => _MenuWebItemsState();
}

class _MenuWebItemsState extends State<MenuWebItems> {
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
  }

  Future<void> checkAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    setState(() {
      isAuthenticated = userId != null;
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
      children: menuItems
          .map((item) => _buildMenuItem(item, isAndroid, themeProvider))
          .toList(),
    );
  }

  Widget _buildMenuItem(
      String item, bool isAndroid, ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.all(
          Responsive.isMobile(context) ? 0 : Constants.defaultPadding),
      child: TextButton(
        onPressed: () {
          // Handle menu item tap (e.g., navigate to a different screen)
          if (item == widget.currentPage) {
            return; // Do nothing if the current page is selected
          }

          switch (item) {
            case 'Home':
              kIsWeb
                  ? Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreen(user: widget.user!),
                          maintainState: true),
                      (Route<dynamic> route) => false)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreen(user: widget.user!)),
                    );
              break;

            case 'Sign Up/Sign In':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
              break;

            case 'Add Recipe':
              kIsWeb
                  ? Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddRecipePage(
                                recipe: null,
                                isForEdit: false,
                                user: widget.user!,
                              ),
                          maintainState: true),
                      (Route<dynamic> route) => false)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddRecipePage(
                          recipe: null,
                          isForEdit: false,
                          user: widget.user!,
                        ),
                      ),
                    );
              break;

            case 'Recipes':
              kIsWeb
                  ? Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipePage(user: widget.user!),
                          maintainState: true),
                      (Route<dynamic> route) => false)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipePage(user: widget.user!)),
                    );
              break;

            case 'Creators':
              kIsWeb
                  ? Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreatorsPage(user: widget.user!),
                          maintainState: true),
                      (Route<dynamic> route) => false)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreatorsPage(user: widget.user!)),
                    );
              break;

            default:
              break;
          }
        },
        child: Text(
          AppLocalizations.of(context).translate(item),
          style: TextStyle(
            color:item == widget.currentPage ? Colors.orange: Responsive.isMobile(context) ||
                    Responsive.isTablet(context) ||
                    themeProvider.currentTheme == ThemeType.dark
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
