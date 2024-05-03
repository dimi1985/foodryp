// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/settings_page/settings_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class TopProfile extends StatefulWidget {
  User user;
  TopProfile({
    super.key,
    required this.user,
  });

  @override
  State<TopProfile> createState() => _TopProfileState();
}

class _TopProfileState extends State<TopProfile> {
  @override
  Widget build(BuildContext context) {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;

    return Stack(
      children: [
        SizedBox(
          height: Responsive.isDesktop(context) ? 450 : 300,
          width: double.infinity,
        ),
        Container(
          height: Responsive.isDesktop(context) ? 350 : 250,
          width: double.infinity,
          color: const Color(0xFFFA624F),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _goToSettingsPage(context);
            },
            color: Constants.secondaryColor,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            widget.user.gender!.contains('female')
                ? ImagePickerPreviewContainer(
                    containerSize: 100.0,
                    initialImagePath: widget.user.profileImage,
                    onImageSelected: (File imageFile, List<int> bytes) {},
                    allowSelection: false,
                    gender: widget.user.gender!,
                    isFor: '',
                    isForEdit: false,
                  )
                : widget.user.gender!.contains('male')
                    ? ImagePickerPreviewContainer(
                        containerSize: 100.0,
                        initialImagePath: widget.user.profileImage,
                        onImageSelected: (File imageFile, List<int> bytes) {},
                        allowSelection: false,
                        gender: widget.user.gender!,
                        isFor: '',
                        isForEdit: false,
                      )
                    : Container(),
            Text(
              widget.user.username,
              style: const TextStyle(
                color: Constants.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _goToSettingsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(user: widget.user),
      ),
    );
  }
}
