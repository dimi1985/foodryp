import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/language_provider.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/mainScreen/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Initialize the language provider and load the language
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('languageCode');
  String? countryCode = prefs.getString('countryCode');
  Locale initialLocale = Locale(languageCode ?? 'el', countryCode ?? 'GR');

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (_) => LanguageProvider()), // Add LanguageProvider
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

 
  @override
  Widget build(BuildContext context) {
    // Retrieve providers
    
    // final languageProvider = Provider.of<LanguageProvider>(context);

    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
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
            home: MainScreen(),
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
}
