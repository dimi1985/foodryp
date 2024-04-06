// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_container.dart';

class TopProfile extends StatelessWidget {
  final String profileImage;
  final String gender;
  final String profileName;
  const TopProfile(
      {super.key,
      required this.profileImage,
      required this.gender,
      required this.profileName});

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
              signout(context, profileName);
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
                ? ImagePickerContainer(
                    containerSize: 100.0,
                    initialImagePath: profileImage.isNotEmpty
                        ? 'assets/default_avatar_female.jpg'
                        :  profileImage,
                  
                    onImageSelected: (File imageFile) {
                      updateStatusOfSelectedImage(context,imageFile);
                    },
                  )
                : gender.contains('male')
                ? ImagePickerContainer(
                    containerSize: 100.0,
                    initialImagePath: profileImage.isNotEmpty
                        ? 'assets/default_avatar_male.jpg'
                        :  profileImage,
                  
                    onImageSelected: (File imageFile) {
                         updateStatusOfSelectedImage(context,imageFile);
                    },
                  ): Container(),
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
                  child: const Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Constants.secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Following',
                    style: TextStyle(
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

  void signout(BuildContext context, String profileName) async {
    // Clear user ID from shared preferences
    await UserService().clearUserId();
    // Navigating to the main screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (route) => false,
    );
  }
  
   void updateStatusOfSelectedImage(BuildContext context, File imageFile) {
  // Show SnackBar indicating file upload
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Row(
        children: [
          CircularProgressIndicator(), // Add a circular progress indicator
          SizedBox(width: 16),
          Text('Uploading file...'), // Text indicating file upload
        ],
      ),
    ),
  );

  // Call the uploadProfile method to upload the image file
  UserService().uploadImageProfile(imageFile).then((_) {
    // Once the upload is complete, hide the SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show a SnackBar indicating upload success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File uploaded successfully'), // Show upload success message
      ),
    );
  }).catchError((error) {
    // If there's an error during upload, hide the SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show a SnackBar indicating upload failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error uploading file: $error'), // Show upload error message
      ),
    );
  });
}

}
