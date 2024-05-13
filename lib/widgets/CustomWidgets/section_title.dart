import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDesktop;

  const SectionTitle({
    super.key,
    required this.title,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        AppLocalizations.of(context).translate(title),
        style: TextStyle(
          color: themeProvider.currentTheme == ThemeType.dark
              ? Colors.white
              : Colors.black,
          fontSize: isDesktop
              ? Constants.desktopHeadingTitleSize
              : Constants.mobileHeadingTitleSize,
        ),
      ),
    );
  }
}
