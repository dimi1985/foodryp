// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/screens/settings_page/settings_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class TopProfile extends StatelessWidget {
  final String profileImage;
  final String gender;
  final String profileName;
  final String? role;
  const TopProfile(
      {super.key,
      required this.profileImage,
      required this.gender,
      required this.profileName, this.role});

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
            gender.contains('female')
                ? ImagePickerPreviewContainer(
                    containerSize: 100.0,
                    initialImagePath: profileImage,
                    onImageSelected: (File imageFile, List<int> bytes) {
                     
                    },
                    allowSelection: false,
                     gender : gender, isFor: '',
                  )
                : gender.contains('male')
                    ? ImagePickerPreviewContainer(
                        containerSize: 100.0,
                        initialImagePath:  profileImage,
                        onImageSelected: (File imageFile, List<int> bytes) {
                         
                        },
                        allowSelection: false,
                         gender : gender, isFor: '',
                      )
                    : Container(),
            Text(
              profileName,
              style: const TextStyle(
                color: Constants.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            ),
            SizedBox(height: Responsive.isDesktop(context) ? 35 : 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                
                TextButton(
                  onPressed: () {},
                  child:  Text(
                    AppLocalizations.of(context).translate('Message'),
                    style:const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Constants.secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                TextButton(
                  onPressed: () {},
                  child:  Text(
                    AppLocalizations.of(context).translate('Following'),
                    style:const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Constants.secondaryColor,
                    ),
                  ),
                ),
              ],
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
        builder: (context) => SettingsPage(
          profileName: profileName,
          gender: gender,
          profileImage: profileImage,
          role: role
        ),
      ),
    );
  }

  
}
