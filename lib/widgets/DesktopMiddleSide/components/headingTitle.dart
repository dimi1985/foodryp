import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class HeadingTitle extends StatelessWidget {
  final String title;

  const HeadingTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 32),
        child: Text(
          title,
          style: TextStyle(
            color: Constants.primaryColor,
            fontSize: Responsive.isMobile(context)
                ? Constants.mobileHeadingTitleSize
                : Constants.desktopHeadingTitleSize,
          ),
        ),
      ),
    );
  }
}
