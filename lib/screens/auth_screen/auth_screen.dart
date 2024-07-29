// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:foodryp/screens/auth_screen/components/reusable_textfield.dart';
import 'package:foodryp/screens/bottom_nav_screen.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/screens/forgot_password_screen.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the Gender enum
enum Gender {
  male,
  female,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLogin = true; // Set to true to show login screen first
  bool obscureText = true;
  bool isLoading = false;
  final UserService _userService = UserService();
  Gender? _selectedGender;

  final _formKey = GlobalKey<FormState>();

  void _handleAuth(bool isAndroid) async {
    if (!_formKey.currentState!.validate()) return;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
    String? languageCode = sharedPreferences.getString('languageCode');
    String? countryCode = sharedPreferences.getString('countryCode');

    String locale = languageCode != null && countryCode != null
        ? '$languageCode-$countryCode'
        : 'en-US';

    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      bool success = false;
      String message = '';

      if (!isLogin) {
        // Perform registration
        String selectedGender = _selectedGender.toString().split('.').last;

        success = await _userService.registerUser(
            userNameController.text,
            emailController.text,
            passwordController.text,
            selectedGender,
            [],
            [],
            [],
            [],
            [],
            [],
            'light',
            locale);

        if (!success) {
          message = AppLocalizations.of(context).translate(
              'Registration failed: Email or Username already exists');
        }
      } else {
        // Perform login
        success = await _userService.loginUser(
          emailController.text,
          passwordController.text,
        );

        if (!success) {
          message = AppLocalizations.of(context)
              .translate('Login failed: Invalid email or password');
        }
      }

      if (success) {
        // Authentication successful
        await navigateToHomeScreen(context, isAndroid);
      } else {
        // Authentication failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = Constants.checkIfAndroid();
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo or App Name
                      Image.asset(
                        'assets/logo.png',
                        height: isAndroid ? 200 : 300,
                        width: isAndroid ? 200 : 300,
                      ),
                      const SizedBox(height: 30.0),
                      ReusableTextField(
                        hintText: 'Email',
                        controller: emailController,
                        togglePasswordVisibility: (isVisible) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('Please enter your email');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      if (!isLogin)
                        ReusableTextField(
                          hintText: 'Username',
                          controller: userNameController,
                          togglePasswordVisibility: (isVisible) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('Please enter your username');
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 15.0),
                      ReusableTextField(
                        hintText: 'Password',
                        controller: passwordController,
                        obscureText: obscureText,
                        togglePasswordVisibility: (isVisible) {
                          setState(() {
                            obscureText = isVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('Please enter your password');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      if (!isLogin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('Pick Gender: '),
                                style: TextStyle(
                                  color: themeProvider.currentTheme ==
                                          ThemeType.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            if (!isAndroid) const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: themeProvider.currentTheme ==
                                          ThemeType.dark
                                      ? Colors.white
                                      : Colors.black,
                                  width: 1,
                                ),
                                color: Colors.transparent,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Gender>(
                                  value: _selectedGender,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: themeProvider.currentTheme ==
                                            ThemeType.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  iconSize: 24,
                                  elevation: 0,
                                  style: TextStyle(
                                    color: themeProvider.currentTheme ==
                                            ThemeType.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16.0,
                                  ),
                                  onChanged: (Gender? newValue) {
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },
                                  items: <Gender>[
                                    Gender.male,
                                    Gender.female,
                                  ].map<DropdownMenuItem<Gender>>(
                                      (Gender value) {
                                    return DropdownMenuItem<Gender>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          value == Gender.male
                                              ? AppLocalizations.of(context)
                                                  .translate('Male')
                                              : AppLocalizations.of(context)
                                                  .translate('Female'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: themeProvider.currentTheme ==
                                                    ThemeType.dark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20.0),
                      // Login/Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              (_selectedGender == null && !isLogin) || isLoading
                                  ? null
                                  : () => _handleAuth(isAndroid),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange.withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            isLogin
                                ? AppLocalizations.of(context)
                                    .translate('Login')
                                : AppLocalizations.of(context)
                                    .translate('Register'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      // Optional: Forgot Password Link
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(AppLocalizations.of(context)
                            .translate('Forgot Password?')),
                      ),
                      SizedBox(height: isAndroid ? 20 : 75.0),
                      // Optional: Sign up/in toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(isLogin
                              ? AppLocalizations.of(context)
                                  .translate('Dont Have an Account?')
                              : AppLocalizations.of(context)
                                  .translate('Already Have an Account?')),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(isLogin
                                ? AppLocalizations.of(context)
                                    .translate('Sign Up')
                                : AppLocalizations.of(context)
                                    .translate('Sign In')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigateToHomeScreen(
      BuildContext context, bool isAndroid) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => isAndroid
              ? const BottomNavScreen()
              : const EntryWebNavigationPage()),
      (Route<dynamic> route) => false,
    );
  }
}
