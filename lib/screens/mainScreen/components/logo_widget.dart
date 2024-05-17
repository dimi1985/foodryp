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
        'assets/foodryp_logo.png',
        width:Responsive.isDesktop(context ) ? 100 :40,
        height: Responsive.isDesktop(context ) ? 100 :40,
      ),
    );
  }
}
