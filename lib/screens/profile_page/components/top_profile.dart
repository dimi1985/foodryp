// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/settings_page/settings_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/celebration_meal_suggester.dart';
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
    final isAndroid = Constants.checiIfAndroid(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              user: widget.user,
                            )),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            ),
          ],
        ),
        SizedBox(
          height: Responsive.isDesktop(context) ? 350 : 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.user.gender == 'female' ||
                            widget.user.gender == 'male'
                        ? ImagePickerPreviewContainer(
                            containerSize: 75.0,
                            initialImagePath: widget.user.profileImage,
                            onImageSelected:
                                (File imageFile, List<int> bytes) {},
                            allowSelection: false,
                            gender: widget.user.gender!,
                            isFor: '',
                            isForEdit: false,
                          )
                        : Container(),
                    Text(
                      widget.user.username,
                      style: const TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: CelebrationMealSuggester()),
            ],
          ),
        ),
      ],
    );
  }
}
