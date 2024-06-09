// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/utils/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  final UserService _userService = UserService();

  void _handleForgotPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool success = await _userService.forgotPassword(emailController.text);

      String message = success
          ? AppLocalizations.of(context)
              .translate('Password reset email sent successfully.')
          : AppLocalizations.of(context)
              .translate('Failed to send password reset email.');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Forgot Password')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).translate(
                  'Enter your email to receive password reset instructions.'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate('Email'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleForgotPassword,
                    child: Text(AppLocalizations.of(context)
                        .translate('Send Reset Email')),
                  ),
          ],
        ),
      ),
    );
  }
}
