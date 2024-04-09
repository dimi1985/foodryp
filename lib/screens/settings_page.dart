// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class SettingsPage extends StatefulWidget {
  String profileName;
  String gender;
  String profileImage;

  SettingsPage({
    super.key,
    required this.profileName,
    required this.gender,
    required this.profileImage,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          children: [
            _sectionTitle('Account'),

            userImageSection(context, isDesktop),
            _settingTile(
              context,
              'Change Username',
              Icons.account_circle,
              () {
                // Navigate to change username screen
              },
            ),
            _settingTile(
              context,
              'Change Email Address',
              Icons.email,
              () {
                // Navigate to change email screen
              },
            ),
            _settingTile(
              context,
              'Change Password',
              Icons.lock,
              () {
                // Navigate to change password screen
              },
            ),
            _settingTile(
              context,
              'SignOut',
              Icons.account_circle,
              () {
                signout(context);
              },
            ),
            _settingTile(
              context,
              'Delete Account',
              Icons.delete,
              () {
                // Show confirmation dialog and delete account
              },
            ),
            _sectionTitle('Notifications'),
            // Add notification settings tiles here
            _sectionTitle('App Theme'),
            // Add app theme settings tiles here
            _sectionTitle('Language'),
            // Add language settings tiles here
            _sectionTitle('Units and Measurements'),
            // Add units and measurements settings tiles here
            _sectionTitle('Search Preferences'),
            // Add search preferences settings tiles here
            _sectionTitle('Recipe Preferences'),
            // Add recipe preferences settings tiles here
            _sectionTitle('Synchronization and Backup'),
            // Add synchronization and backup settings tiles here
            _sectionTitle('About and Help'),
            // Add about and help settings tiles here
            _sectionTitle('Privacy and Data Security'),
            // Add privacy and data security settings tiles here
            _sectionTitle('Terms of Service and Legal'),
            // Add terms of service and legal settings tiles here
            _sectionTitle('Feedback and Suggestions'),
            // Add feedback and suggestions settings tiles here
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _settingTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  userImageSection(BuildContext context, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          widget.gender.contains('female')
              ? ImagePickerPreviewContainer(
                  containerSize: 100.0,
                  initialImagePath: widget.profileImage.isNotEmpty
                      ? 'assets/default_avatar_female.jpg'
                      : widget.profileImage,
                  onImageSelected: (File imageFile) {
                    updateStatusOfSelectedImage(context, imageFile);
                  },
                  allowSelection: true,
                )
              : widget.gender.contains('male')
                  ? ImagePickerPreviewContainer(
                      containerSize: 100.0,
                      initialImagePath: widget.profileImage.isNotEmpty
                          ? 'assets/default_avatar_male.jpg'
                          : widget.profileImage,
                      onImageSelected: (File imageFile) {
                        updateStatusOfSelectedImage(context, imageFile);
                      },
                      allowSelection: true,
                    )
                  : Container(),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Change profile Pic',
            style: TextStyle(
              fontSize: isDesktop
                  ? Constants.desktopFontSize
                  : Constants.mobileFontSize,
            ),
          )
        ],
      ),
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
          content:
              Text('File uploaded successfully'), // Show upload success message
        ),
      );
    }).catchError((error) {
      // If there's an error during upload, hide the SnackBar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Show a SnackBar indicating upload failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error uploading file: $error'), // Show upload error message
        ),
      );
    });
  }

  void signout(BuildContext context) async {
    // Clear user ID from shared preferences
    await UserService().clearUserId();
    // Navigating to the main screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (route) => false,
    );
  }
}
