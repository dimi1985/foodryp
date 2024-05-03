import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/screens/mainScreen/components/logo_widget.dart';
import 'package:foodryp/utils/user_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_app_bar.dart';
import 'package:foodryp/widgets/CustomWidgets/menuWebItems.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/desktopLeftSide/desktopLeftSide.dart';
import '../../widgets/DesktopMiddleSide/desktopMiddleSide.dart';
import '../../widgets/desktopRightSide/desktopRightSide.dart';

class MainScreen extends StatefulWidget {
  final User? user;
  MainScreen({Key? key, this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isAuthenticated = false;
  late SharedPreferences _prefs;
  String userId = '';
  late List<User> users = [];
  bool valueSet = false;
  UsersProvider usersProvider = UsersProvider();
  late String currentPage;
  User user = Constants.defaultUser;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    currentPage = 'Home';
  }

  Future<void> fetchUserProfile() async {
    final userService = UserService();
    final userProfile = await userService.getUserProfile();
    _prefs = await SharedPreferences.getInstance();
    userId = _prefs.getString('userId') ?? '';
    setState(() {
      if (userId.isNotEmpty) {
        isAuthenticated = true;
      }
      user = userProfile ?? Constants.defaultUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          isDesktop: true,
          isAuthenticated: true,
          profileImage: user.profileImage,
          username: user.username,
          onTapProfile: () {
            // Handle profile onTap action
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        user: user,
                      )),
            );
          },
          user: user,
          menuItems: isDesktop
              ? MenuWebItems(
                  user: user,
                  currentPage: currentPage,
                )
              : Container(),
        ),
        endDrawer: !isDesktop
            ? MenuWebItems(user: user, currentPage: currentPage)
            : null,
        body: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: isDesktop ? 1 : 1,
                child: const DesktopLeftSide(),
              ),
            Expanded(
              flex: isDesktop ? 4 : 2,
              child: const DesktopMiddleSide(),
            ),
            if (isDesktop)
              Expanded(
                flex: isDesktop ? 1 : 1,
                child: const DesktopRightSide(),
              ),
          ],
        ),
      ),
    );
  }
}
