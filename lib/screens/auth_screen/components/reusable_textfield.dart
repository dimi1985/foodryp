import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool autofocus;

  const ReusableTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false, // Default to not obscured
    this.keyboardType = TextInputType.text, // Default text keyboard
    this.autofocus = false, // Default to not autofocusing
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: getIcon(hintText), // Use getIcon function for dynamic icons
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
