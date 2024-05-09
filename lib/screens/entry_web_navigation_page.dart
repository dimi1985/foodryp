import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/auth_screen/auth_screen.dart';
import 'package:foodryp/screens/creators_page/creators_page.dart';
import 'package:foodryp/screens/mainScreen/components/logo_widget.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/screens/my_fridge_page.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/screens/settings_page/settings_page.dart';
import 'package:foodryp/screens/weekly_menu_page/weekly_menu_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/utils/users_list_provider.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class EntryWebNavigationPage extends StatefulWidget {
  const EntryWebNavigationPage({super.key});

  @override
  State<EntryWebNavigationPage> createState() => _EntryWebNavigationPageState();
}

class _EntryWebNavigationPageState extends State<EntryWebNavigationPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool isAuthenticated = false;
  String userId = '';
  late List<User> users = [];
  bool valueSet = false;
  UsersListProvider usersProvider = UsersListProvider();
  late User user = Constants.defaultUser;
  List<String> menuItems = [];
  bool isForInternalUse = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (kIsWeb) {
      await _fetchUserProfile();
    }
  }

  Future<void> _fetchUserProfile() async {
    final userService = UserService();
    final userProfile = await userService.getUserProfile();
    userId = await userService.getCurrentUserId();
    setState(() {
      if (userId.isNotEmpty) {
        isAuthenticated = true;
      }
      if (userProfile != null) {
        user = userProfile;
      } else {
        user = Constants.defaultUser;
      }
    });
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isMobile = Responsive.isMobile(context);
    final isAndroid = Constants.checiIfAndroid(context);

    menuItems = [
      'Home',
      if (isAuthenticated) 'Creators',
      'Recipes',
      'Weekly Menu Page',
      if (isAuthenticated) 'My Fridge',
      if (isAuthenticated) 'Add Recipe',
      if (!isAuthenticated) 'Sign Up/Sign In',
      if (isForInternalUse) 'ProfilePage',
    ];
    final finalProfileImageURL =
        ('${Constants.baseUrl}/${user.profileImage}').replaceAll('\\', '/');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const LogoWidget(),
            const Text('Foodryp'),
            if (isDesktop)
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 100,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: menuItems
                        .where((item) =>
                            item !=
                            'ProfilePage') // Exclude 'ProfilePage' from view
                        .map((item) => _buildMenuItem(item))
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
        actions: [
          if (isAuthenticated)
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile section components
                  if (user.username.isNotEmpty)
                    InkWell(
                      onTap: () {
                        _navigateToPage(menuItems.indexOf('ProfilePage'));
                      },
                      child: Row(
                        children: [
                          if (user.profileImage.isNotEmpty)
                            ImagePickerPreviewContainer(
                              initialImagePath: finalProfileImageURL,
                              containerSize: isDesktop ? 30 : 20,
                              onImageSelected: (image, bytes) {},
                              gender: user.gender ?? '',
                              isFor: '',
                              isForEdit: false,
                              allowSelection: false,
                            ),
                          const SizedBox(width: 8),
                          Text(user.username),
                        ],
                      ),
                    ),

                  if (isMobile && kIsWeb && !isAndroid || !isAuthenticated)
                    PopupMenuButton<String>(
                      itemBuilder: (context) => menuItems.map((item) {
                        return PopupMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onSelected: (String item) {
                        // Handle item selection here
                        _navigateToPage(menuItems.indexOf(item));
                      },
                      icon: const Icon(Icons.menu),
                    ),
                ],
              ),
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          MainScreen(
            user: user,
          ),
          if (isAuthenticated)
            CreatorsPage(
              user: user,
            ),
          RecipePage(
            user: user,
          ),
          WeeklyMenuPage(
            user: user,
          ),
          if (isAuthenticated)
            MyFridgePage(
              user: user,
            ),
          if (isAuthenticated) const AddRecipePage(isForEdit: false),
          if (isAuthenticated)
            ProfilePage(
              user: user,
            ),
          if (!isAuthenticated) const AuthScreen(),

          // Add other pages here as needed
        ],
      ),
    );
  }

  Widget _buildMenuItem(String item) {
    return Padding(
      padding: EdgeInsets.all(
          Responsive.isMobile(context) ? 0 : Constants.defaultPadding),
      child: TextButton(
        onPressed: () {
          // Handle menu item tap
          final index = menuItems.indexOf(item);
          _navigateToPage(index);
        },
        child: Text(
          AppLocalizations.of(context).translate(item),
          style: TextStyle(
            color: _currentPageIndex == menuItems.indexOf(item)
                ? Colors.orange
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
