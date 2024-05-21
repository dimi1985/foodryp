// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/database/database_helper.dart';
import 'package:foodryp/screens/bottom_nav_screen.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/screens/offline_recipe_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/celebration_settings_provider.dart';
import 'package:foodryp/utils/connectivity_service.dart';
import 'package:foodryp/utils/language_provider.dart';
import 'package:foodryp/utils/recipe_provider.dart';
import 'package:foodryp/utils/search_settings_provider.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Initialize the language provider and load the language
  // Ensure that the necessary bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  initializeAsyncOperations();

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
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
         ChangeNotifierProvider(create: (_) => SearchSettingsProvider()),
         ChangeNotifierProvider(create: (_) => CelebrationSettingsProvider()),
      ],
      child: Foodryp(initialLocale: initialLocale),
    ),
  );
}

void initializeAsyncOperations() async {
  var db = getDatabase();
  await db.init(); // This now happens in the background
  // Any other asynchronous initialization can also be done here
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
  late Locale _locale = widget.initialLocale;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    _streamSubscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        isOffline = true;
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityService(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return Consumer<ConnectivityService>(
            builder: (context, connectivityService, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Foodryp',
                theme: themeProvider.themeData,
                locale: _locale,
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
                home: determineMobileLayout(connectivityService),
              );
            },
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

  Widget determineMobileLayout(ConnectivityService connectivityService) {
    // Check if the platform is Web
    if (kIsWeb) {
      return connectivityService.connectionStatus
              .contains(ConnectivityResult.none)
          ? const OfflineRecipePage()
          : const EntryWebNavigationPage();
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return connectivityService.connectionStatus
              .contains(ConnectivityResult.none)
          ? const OfflineRecipePage()
          : const BottomNavScreen();
    } else {
      return const BottomNavScreen(); // Default to BottomNavScreen for other platforms
    }
  }
}
