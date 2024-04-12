import 'package:flutter/material.dart';

class LanguageSettingsTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageSettingsTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      trailing: isSelected ? const Icon(Icons.check) : null,
    );
  }
}
