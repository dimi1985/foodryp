import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/mainScreen/components/logo_widget.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;
  final bool isAuthenticated;
  final Function()? onTapProfile;
  final Widget menuItems;
  final User user;

  const CustomAppBar({
    super.key,
    required this.isDesktop,
    required this.isAuthenticated,
    this.onTapProfile,
    required this.menuItems,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return AppBar(
      surfaceTintColor: Colors.white,
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const LogoWidget(),
          const Text('Foodryp'),
          if (isDesktop)
            Expanded(
              flex: isDesktop ? 3 : 1,
              child: SizedBox(
                width: screenSize.width,
                height: isDesktop ? 100 : 50,
                child: menuItems,
              ),
            ),
        ],
      ),
      actions: const [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
