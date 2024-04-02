import 'package:flutter/material.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/headingTitle.dart';
import 'package:foodryp/widgets/header/components/logo_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Widget customLogoWidget;
  final Widget customMenuWidget;

  const CustomAppBar({
    super.key,

    required this.customLogoWidget,
    required this.customMenuWidget,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100.0); // Set preferred height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: LogoWidget(),
      toolbarHeight: 100.0, // Set toolbar height for better alignment
    );
  }
}
