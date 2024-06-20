import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/screens/bottom_nav_screen.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/celebration_settings_provider.dart';
import 'package:foodryp/utils/connectivity_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/language_provider.dart';
import 'package:foodryp/utils/recipe_provider.dart';
import 'package:foodryp/utils/search_settings_provider.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Initialize the language provider and load the language
  // Ensure that the necessary bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  UserService userService = UserService();

  String? languageCode = Constants.emptyField;
  String? countryCode = Constants.emptyField;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? themePreference = await userService.getThemePreference();
  String? languagePreference = await userService.getLanguagePreference();

  if (themePreference != null) {
    ThemeType themeType = themeTypeFromString(themePreference);
    await prefs.setString('theme', themeType.toString());
  } else {
    print('Failed to fetch theme preference');
  }

  if (languagePreference != null) {
    // Split the languagePreference into languageCode and countryCode
    List<String> parts = languagePreference.split('-');
    languageCode = parts[0];
    countryCode = parts.length > 1 ? parts[1] : '';

    // Save languageCode and countryCode to SharedPreferences
    await prefs.setString('languageCode', languageCode);
    await prefs.setString('countryCode', countryCode);
  } else {
    print('Failed to fetch language preference');
  }

  String? userId = await UserService().getCurrentUserId();
  languageCode = prefs.getString('languageCode');
  countryCode = prefs.getString('countryCode');

  if (userId.isEmpty) {
    UserService().clearUserId();
  }

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
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
      ],
      child: Foodryp(initialLocale: initialLocale),
    ),
  );
}

ThemeType themeTypeFromString(String theme) {
  switch (theme) {
    case 'dark':
      return ThemeType.dark;
    case 'light':
    default:
      return ThemeType.light;
  }
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
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
              home: determineMobileLayout(connectivityService.connectionStatus),
            );
          },
        );
      },
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

  Widget determineMobileLayout(List<ConnectivityResult> connectionStatus) {
    bool isOffline = connectionStatus.contains(ConnectivityResult.none);

    if (kIsWeb) {
      return isOffline
          ? const Center(
              child: Text('You are offline'),
            )
          : const EntryWebNavigationPage();
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return isOffline
          ? const Center(
              child: Text('You are offline'),
            )
          : const BottomNavScreen();
    } else {
      return const BottomNavScreen(); // Default to BottomNavScreen for other platforms
    }
  }
}
