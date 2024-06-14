import 'package:flutter/material.dart';
import 'package:foodryp/utils/user_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController usernameController = TextEditingController();
  List<TextEditingController> pinControllers =
      List.generate(4, (_) => TextEditingController());
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  UserService userService = UserService();
  bool isPINValidated = false;
  bool usernameError = false;
  bool pinError = false;
  int retryCount = 0;
  int maxRetries = 3;

  @override
  void dispose() {
    usernameController.dispose();
    pinControllers.forEach((controller) => controller.dispose());
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your username and PIN to reset your password.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                errorText: usernameError ? 'Username not found or empty' : null,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter PIN',
              style: TextStyle(color: Colors.grey, fontSize: 20),
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
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          // Move focus to the next box
                          if (i < 3) {
                            FocusScope.of(context).nextFocus();
                          } else {
                            // Last pin box, validate PIN
                            _validatePIN();
                          }
                        }
                      },
                    ),
                  ),
              ],
            ),
            if (isPINValidated) ...[
              const SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  hintText: 'Confirm your new password',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement logic to reset password
                  _resetPassword();
                },
                child: Text('Reset Password'),
              ),
            ],
            const SizedBox(height: 20),
            Text('Remaining tries: ${maxRetries - retryCount}'),
          ],
        ),
      ),
    );
  }

  void _validatePIN() async {
    String username = usernameController.text.trim();
    String pin = pinControllers.map((controller) => controller.text).join();

    // Check if username is empty
    if (username.isEmpty) {
      setState(() {
        usernameError = true;
        pinError = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username should not be empty.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Check if PIN is empty or not 4 digits
    if (pin.length != 4) {
      setState(() {
        pinError = true;
        usernameError = false; // Reset username error state
      });
      return;
    }

    // Perform PIN validation
    final response = await userService.validatePIN(username, pin);
    setState(() {
      if (response == 'Username not found') {
        usernameError = true;
        pinError = false;
        isPINValidated = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username not found.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (response == 'Invalid PIN') {
        pinError = true;
        usernameError = false;
        isPINValidated = false;
        retryCount++;
        if (retryCount >= maxRetries) {
          // Implement logic for handling max retries exceeded
          print('Max retries exceeded');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PIN validation failed. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (response == 'PIN validated successfully') {
        isPINValidated = true;
        pinError = false;
        usernameError = false;
        retryCount = 0; // Reset retry count on successful validation
      }
    });
  }

  void _resetPassword() {
    String newPassword = newPasswordController.text;
    String confirmedPassword = confirmNewPasswordController.text;
    String username = usernameController.text.trim();

    // Implement your logic to reset the password here
    if (newPassword == confirmedPassword) {
      // Passwords match, proceed with password reset
      userService.resetPassword(username, newPassword).then((success) {
        if (success) {
          // Password reset successful, navigate to success screen or handle accordingly
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset successfully.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // Handle password reset failure
          // Example: Show snackbar or dialog to inform the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to reset password. Please try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    } else {
      // Passwords do not match, show error message or handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

class PinBox extends StatelessWidget {
  final TextEditingController controller;
  final bool error;
  final ValueChanged<String>? onChanged;

  const PinBox({
    Key? key,
    required this.controller,
    required this.error,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: error ? Colors.red : Colors.grey),
        ),
      ),
      maxLength: 1,
      onChanged: onChanged,
    );
  }
}
