import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool autofocus;
  final Function(bool) togglePasswordVisibility; // Function to toggle password visibility

  const ReusableTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    required this.togglePasswordVisibility, // Toggle password visibility function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: getIcon(hintText),
        suffixIcon: hintText == 'Password'
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // Toggle password visibility when icon button is pressed
                  togglePasswordVisibility(!obscureText);
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Icon? getIcon(String hintText) {
    switch (hintText.toLowerCase()) {
      case 'password':
        return const Icon(Icons.lock);
      case 'username':
        return const Icon(Icons.account_circle);
      case 'email':
        return const Icon(Icons.email);
      default:
        return null; // No icon for other cases
    }
  }
}