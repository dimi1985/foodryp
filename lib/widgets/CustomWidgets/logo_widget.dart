import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Image.asset(
        'assets/logo.png',
        width: Responsive.isDesktop(context) ? 60 : 40,
        height: Responsive.isDesktop(context) ? 60 : 40,
      ),
    );
  }
}
