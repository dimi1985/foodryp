import 'package:flutter/foundation.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/auth_screen/auth_screen.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/screens/mainScreen/components/logo_widget.dart';
import 'package:foodryp/utils/users_list_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_app_bar.dart';
import 'package:foodryp/widgets/CustomWidgets/menuWebItems.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/desktopLeftSide/desktopLeftSide.dart';
import '../../widgets/DesktopMiddleSide/desktopMiddleSide.dart';
import '../../widgets/desktopRightSide/desktopRightSide.dart';

class MainScreen extends StatefulWidget {
  final User? user;
  const MainScreen({Key? key, this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isAuthenticated = false;
  late SharedPreferences _prefs;
  String userId = '';
  late List<User> users = [];
  bool valueSet = false;
  UsersListProvider usersProvider = UsersListProvider();
  late String currentPage;
  User user = Constants.defaultUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      fetchUserProfile().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

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
      if (userProfile != null) {
        user = userProfile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
   final isAndroid =  Constants.checiIfAndroid(context);
    return SafeArea(
      child: _isLoading && kIsWeb
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: isAndroid
                  ? AppBar(
                      toolbarHeight: 80,
                      surfaceTintColor: Colors.white,
                      elevation: 0,
                      title: const Row(
                        children: [
                          LogoWidget(),
                          Text('Foodryp'),
                        ],
                      ),
                      actions: [
                        if (isAndroid)
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AuthScreen()),
                                );
                              },
                              child: Text(AppLocalizations.of(context)
                                  .translate('Sign Up/Sign In')))
                      ],
                    )
                  : CustomAppBar(
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
                  ? isAndroid
                      ? null
                      : MenuWebItems(user: user, currentPage: currentPage)
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
