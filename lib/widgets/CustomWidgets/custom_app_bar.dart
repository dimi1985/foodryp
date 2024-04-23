import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/mainScreen/components/logo_widget.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;
  final bool isAuthenticated;

  final String profileImage;
  final String username;
  final Function()? onTapProfile;
  final Widget menuItems;
  final User user;

  const CustomAppBar({
    super.key,
    required this.isDesktop,
    required this.isAuthenticated,
    required this.profileImage,
    required this.username,
    this.onTapProfile,
    required this.menuItems,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final finalProfileImageURL =
        ('${Constants.baseUrl}/${user.profileImage}').replaceAll('\\', '/');
    return AppBar(
      surfaceTintColor: Colors.white,
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const LogoWidget(),
          const Text('Foodryp'),
          const Spacer(),
          if (isDesktop)
            Expanded(
              child: SizedBox(
                width: screenSize.width,
                height: 100,
                child: menuItems,
              ),
            ),
          if (isAuthenticated)
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  finalProfileImageURL == Constants.imageURL || username.isEmpty
                      ? Container()
                      : ImagePickerPreviewContainer(
                          initialImagePath: user.profileImage,
                          containerSize: 30,
                          onImageSelected: (iamge, bytes) {},
                          gender: user.gender ?? '',
                          isFor: '',
                          isForEdit: false,
                          allowSelection: false,
                        ),
                  const SizedBox(
                    width: 8,
                  ),
                  username.isEmpty
                      ? Container()
                      : InkWell(
                          onTap: onTapProfile,
                          child: Text(username),
                        ),
                ],
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
