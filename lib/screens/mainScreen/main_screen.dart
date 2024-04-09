import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_screen/profile_screen.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/screens/mainScreen/components/logo_widget.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/menuWebItems.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/desktopLeftSide/desktopLeftSide.dart';
import '../../widgets/DesktopMiddleSide/desktopMiddleSide.dart';
import '../../widgets/desktopRightSide/desktopRightSide.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isAuthenticated = false;
  late SharedPreferences _prefs;
  String userId = '';

  User user = User(
    id: '',
    username: '',
    email: '',
    profileImage: '',
    gender: '', memberSince: null, role: '',
  );

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final userService = UserService();
    final userProfile = await userService.getUserProfile();
    _prefs = await SharedPreferences.getInstance();
    userId =
        _prefs.getString('userId') ?? '';
    setState(() {
      if (userId.isNotEmpty) {
        isAuthenticated = true;
      }
      user = userProfile ??
          User(id: '', username: '', email: '', profileImage: '', gender: '', memberSince: null, role: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = Responsive.isDesktop(context);
    final finalProfileImageURL = ('${Constants.baseUrl}/${user.profileImage}').replaceAll('\\', '/');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          toolbarHeight: 80,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const LogoWidget(),
              const Text('Foodryp'),
              const Spacer(),
              if (isDesktop)
                Expanded(
                  child: SizedBox(
                    width: screenSize.width,
                    height: 100,
                    child: const MenuWebItems(),
                  ),
                ),
              if (isAuthenticated)
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      user.profileImage.isNotEmpty
                          ?  CircleAvatar(
                              backgroundImage: NetworkImage(finalProfileImageURL),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: user.gender!.contains('female')
                                  ? Image.asset(
                                      'assets/default_avatar_female.jpg',
                                      height: 30,
                                      width: 30,
                                    )
                                  : user.gender!.contains('male')
                                      ? Image.asset(
                                          'assets/default_avatar_male.jpg',
                                          height: 30,
                                          width: 30,
                                        )
                                      : Container(),
                            ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()),
                            );
                          },
                          child: Text(user.username)),
                    ],
                  ),
                ),
            ],
          ),
          actions: const [],
        ),
        endDrawer: screenSize.width <= 1100 ? const MenuWebItems() : null,
        body: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: isDesktop ? 1 : 1,
                child: const DesktopLeftSide(),
              ),
            Expanded(
              flex: isDesktop ? 4 : 3,
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
