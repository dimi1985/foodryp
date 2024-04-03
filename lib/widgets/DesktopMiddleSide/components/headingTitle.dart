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
         Size screenSize = MediaQuery.of(context).size;
    return Align(
      alignment:Responsive.isDesktop(context) ? Alignment.center: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 32),
        child: Text(
          textAlign: Responsive.isDesktop(context) ? TextAlign.center : null,
          title,
          style: TextStyle(
            color: Constants.primaryColor,
            fontSize:screenSize.width <= 1100 ? 20 : 40,
          ),
        ),
      ),
    );
  }
}
