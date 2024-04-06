import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDesktop;

  const SectionTitle({
    Key? key,
    required this.title,
    required this.isDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: isDesktop
              ? Constants.desktopHeadingTitleSize
              : Constants.mobileHeadingTitleSize,
        ),
      ),
    );
  }
}