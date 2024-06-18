// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/user_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController usernameController = TextEditingController();
  List<TextEditingController> pinControllers =
      List.generate(4, (_) => TextEditingController());
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  UserService userService = UserService();
  bool pinError = false;
  bool isPINValidated = false;
  int validationAttempts = 0;
  final int maxAttempts = 3;

  @override
  void dispose() {
    usernameController.dispose();
    for (var controller in pinControllers) {
      controller.dispose();
    }
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('Reset Password Page')),
      ),
      body: Center(
        child: SizedBox(
           width: 600,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).translate(
                        'Please enter your username and you secret PIN registered in your setting page to reset your password.\n You have three attempts after that you will have to send us an email to support@foodryp.com\n with a subject-Foodryp reset password.'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate('Username'),
                      hintText: AppLocalizations.of(context)
                          .translate('Enter your username'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < 4; i++)
                        Expanded(
                          child: PinBox(
                            controller: pinControllers[i],
                            error: pinError,
                            onChanged: (String value) {
                              if (value.length == 1) {
                                if (i < 3) {
                                  FocusScope.of(context).nextFocus();
                                } else {
                                  FocusScope.of(context).unfocus();
                                }
                              } else if (value.isEmpty && i > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _validatePIN,
                    child: Text(
                        AppLocalizations.of(context).translate('Validate PIN')),
                  ),
                  if (!isPINValidated &&
                      validationAttempts > 0 &&
                      validationAttempts < maxAttempts)
                    Text(
                      '${AppLocalizations.of(context)
                              .translate('Remaining attempts: ')}${maxAttempts - validationAttempts}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (validationAttempts >= maxAttempts)
                    Text(
                      AppLocalizations.of(context)
                          .translate('No more attempts left.'),
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (isPINValidated) ...[
                    const SizedBox(height: 20),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('New Password'),
                        hintText: AppLocalizations.of(context)
                            .translate('Enter your new password'),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('Confirm New Password'),
                        hintText: AppLocalizations.of(context)
                            .translate('Confirm your new password'),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text(AppLocalizations.of(context)
                          .translate('Reset Password')),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validatePIN() async {
    String username = usernameController.text.trim();
    String pin = pinControllers.map((controller) => controller.text).join();

    if (username.isEmpty || pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate(
              'Please ensure the username is entered and the PIN is exactly 4 digits.')),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    bool isValid = await userService.validatePIN(username, pin);
    setState(() {
      isPINValidated = isValid;
      pinError = !isValid;
      if (!isValid) {
        validationAttempts++;
        for (var controller in pinControllers) {
          controller.clear();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('PIN validation failed. Please try again.')),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('PIN validated successfully.')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    if (validationAttempts >= maxAttempts) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate('Maximum validation attempts exceeded.')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetPassword() {
    String newPassword = newPasswordController.text;
    String confirmedPassword = confirmPasswordController.text;

    if (newPassword != confirmedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate('Passwords do not match.')),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (newPassword.isEmpty || confirmedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate('Password cannot be empty.')),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    userService
        .resetPassword(usernameController.text, newPassword)
        .then((success) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('Password reset successfully.')),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('Failed to reset password. Please try again.')),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }
}


class PinBox extends StatelessWidget {
  final TextEditingController controller;
  final bool error;
  final Function(String) onChanged;

  const PinBox({
    Key? key,
    required this.controller,
    required this.error,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        obscureText: true,
        textAlign: TextAlign.center,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: error ? Colors.red : Colors.grey),
          ),
        ),
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        buildCounter: (BuildContext context,
            {int? currentLength, bool? isFocused, int? maxLength}) {
          return null; // Remove the character counter
        },
      ),
    );
  }
}
