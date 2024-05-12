// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/database/database_helper.dart';
import 'package:foodryp/screens/bottom_nav_screen.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/celebration_settings_provider.dart';
import 'package:foodryp/utils/language_provider.dart';
import 'package:foodryp/utils/recipe_provider.dart';
import 'package:foodryp/utils/search_settings_provider.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_profile_provider.dart';
import 'package:foodryp/utils/users_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Initialize the language provider and load the language
  // Ensure that the necessary bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  var db = getDatabase(); // This will fetch the appropriate database instance
  await db.init(); // Initialize the database
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('languageCode');
  String? countryCode = prefs.getString('countryCode');
  Locale initialLocale = Locale(languageCode ?? 'el', countryCode ?? 'GR');

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
        ChangeNotifierProvider(create: (_) => UsersListProvider()),
        ChangeNotifierProvider(create: (_) => SearchSettingsProvider()),
        ChangeNotifierProvider(create: (_) => CelebrationSettingsProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: Foodryp(initialLocale: initialLocale),
    ),
  );
}

class Foodryp extends StatefulWidget {
  final Locale initialLocale;

  const Foodryp({super.key, required this.initialLocale});

  @override
  State<Foodryp> createState() => _FoodrypState();

  static void setLocale(BuildContext context, Locale locale) {
    _FoodrypState? state = context.findAncestorStateOfType<_FoodrypState>();
    if (state != null) {
      state.setLocale(locale);
    }
  }
}

class _FoodrypState extends State<Foodryp> {
  late Locale _locale = const Locale('el');
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Foodryp',
            theme: themeProvider.themeData,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('el', 'GR'),
            ],
            locale: _locale,
            home: determineMobileLayout(),
          );
        },
      ),
    );
  }

  void setLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode!);
    setState(() {
      _locale = locale;
    });
  }

  Widget determineMobileLayout() {
    // Check if the platform is Android
    if (kIsWeb) {
      return const EntryWebNavigationPage();
    } else {
      // Optionally handle other platforms, such as iOS
      return const BottomNavScreen(); // Default to web layout for other platforms
    }
  }
}
