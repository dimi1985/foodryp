// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:foodryp/screens/auth_screen/components/reusable_textfield.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:provider/provider.dart';

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
  bool isLogin = false;
  bool obscureText = true;
  bool isLoading = false;
  late UserService _userService;
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    _userService = Provider.of<UserService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo or App Name
                    Image.asset(
                      'assets/logo.png',
                      height: 300,
                      width: 300,
                    ),
                    const SizedBox(height: 30.0),
                    ReusableTextField(
                      hintText: AppLocalizations.of(context).translate('Email'),
                      controller: emailController,
                      togglePasswordVisibility: (isVisible) {},
                    ),
                    const SizedBox(height: 15.0),
                    if (!isLogin)
                      ReusableTextField(
                        hintText:
                            AppLocalizations.of(context).translate('Username'),
                        controller: userNameController,
                        togglePasswordVisibility: (isVisible) {},
                      ),
                    const SizedBox(height: 15.0),
                    ReusableTextField(
                      hintText:
                          AppLocalizations.of(context).translate('Password'),
                      controller: passwordController,
                      obscureText: obscureText,
                      togglePasswordVisibility: (isVisible) {
                        setState(() {
                          obscureText = isVisible;
                        });
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
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the radius as needed
                                color: Colors
                                    .grey[200], // Adjust the color as needed
                              ),
                              child: DropdownButton<Gender>(
                                value: _selectedGender,
                                onChanged: (Gender? newValue) {
                                  setState(() {
                                    _selectedGender = newValue;
                                  });
                                },
                                items: <Gender>[
                                  Gender.male,
                                  Gender.female,
                                ].map<DropdownMenuItem<Gender>>((Gender value) {
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
                      width: 500,
                      child: ElevatedButton(
                        onPressed: isLoading // Disable button when loading
                            ? null
                            : () => _handleAuth(),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(isLogin
                            ? AppLocalizations.of(context).translate('Login')
                            : AppLocalizations.of(context)
                                .translate('Register')),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    // Optional: Forgot Password Link
                    TextButton(
                      onPressed: () {
                        // Handle forgot password logic
                      },
                      child: Text(AppLocalizations.of(context)
                          .translate('Forgot Password?')),
                    ),

                    const SizedBox(height: 75.0),

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
              if (isLoading) // Loading indicator
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAuth() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      if (!isLogin) {
        // Perform registration

        String selectedGender = _selectedGender.toString().split('.').last;

        final success = await _userService.registerUser(
            userNameController.text,
            emailController.text,
            passwordController.text,
            selectedGender.toString().split('.').last, [], [], [], [],[]);

        if (success) {
          // Registration successful

          await navigateToHomeScreen(context);
        } else {
          // Registration failed
        }
      } else {
        // Perform login

        final success = await _userService.loginUser(
          emailController.text,
          passwordController.text,
        );

        if (success) {
          // Login successful
          await navigateToHomeScreen(context);
        } else {
          // Login failed
        }
      }
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> navigateToHomeScreen(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
