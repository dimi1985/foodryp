// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                      style: TextStyle(
                        color: themeProvider.currentTheme == ThemeType.dark
                            ? Colors.white
                            : const Color.fromARGB(255, 37, 36, 37),
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
