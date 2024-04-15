// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodryp/main.dart';
import 'package:foodryp/screens/admin/admin_panel_screen.dart';
import 'package:foodryp/screens/settings_page/components/delete_account_page.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/language.dart';
import 'package:foodryp/utils/language_provider.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/widgets/CustomWidgets/language_settings_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  String profileName;
  String gender;
  String profileImage;
  String? role;

  SettingsPage({
    super.key,
    required this.profileName,
    required this.gender,
    required this.profileImage,
    this.role,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<Language> supportedLanguages;
  int _selectedLanguageIndex = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    supportedLanguages = [
      Language(AppLocalizations.of(context).translate('English'),
          const Locale('en', 'US')),
      Language(AppLocalizations.of(context).translate('Greek'),
          const Locale('el', 'GR')),
    ];
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      final languageCode = prefs.getString('languageCode');
      final countryCode = prefs.getString('countryCode');
      if (languageCode != null && countryCode != null) {
        final locale = Locale(languageCode, countryCode);
        final selectedLanguage = supportedLanguages.firstWhere(
          (language) => language.locale == locale,
          orElse: () => supportedLanguages[0],
        );

        setState(() {
          _selectedLanguageIndex = supportedLanguages.indexOf(selectedLanguage);
        });

        Foodryp.setLocale(context, locale);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Scaffold(
        appBar: AppBar(

          
          title:  Text(AppLocalizations.of(context).translate('Settings')),
          actions: [
            if (widget.role!.contains('admin'))
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminPanelScreen()),
                    );
                  },
                  child: 
                   Text(AppLocalizations.of(context).translate('Settings')))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          children: [
            _sectionTitle(AppLocalizations.of(context).translate('Account')),

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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: 
                      
                       Text(AppLocalizations.of(context).translate('Delete Account')),
                       
                      content:  Text(
                          AppLocalizations.of(context).translate('Are you sure you want to delete your account along with its recipes?')),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Close dialog
                            Navigator.of(context).pop();
                          },
                          child:  Text(AppLocalizations.of(context).translate('Cancel')),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DeleteAccountPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child:  Text(AppLocalizations.of(context).translate('Delete')),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            _sectionTitle(AppLocalizations.of(context).translate('App Theme')),
            // Add app theme settings tiles here
            SizedBox(
              height: 50,
              child: ListView(
                children: [
                  ListTile(
                    
                    title:  Text(AppLocalizations.of(context).translate('Dark Theme')),
                    trailing: Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) => Switch(
                        value: themeProvider.currentTheme == ThemeType.dark,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            
            _sectionTitle(AppLocalizations.of(context).translate('Language')),
            LanguageSettingsTile(
              title: AppLocalizations.of(context).translate('English'),
              isSelected: _selectedLanguageIndex ==
                  0, // Assuming English is the first language in the supportedLanguages list
              onTap: () {
                setState(() {
                  _selectedLanguageIndex =
                      0; // Set the selected language index to English
                });
                final locale = supportedLanguages[0].locale;
                Foodryp.setLocale(context, locale);
              },
            ),
            LanguageSettingsTile(
              title: AppLocalizations.of(context).translate('Greek'),
              isSelected: _selectedLanguageIndex ==
                  1, // Assuming Greek is the second language in the supportedLanguages list
              onTap: () {
                setState(() {
                  _selectedLanguageIndex =
                      1; // Set the selected language index to Greek
                });
                final locale = supportedLanguages[1].locale;
                Foodryp.setLocale(context, locale);
              },
            ),

            _sectionTitle('Units and Measurements'),
            // Add units and measurements settings tiles here
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
      title: Text(AppLocalizations.of(context).translate(title)),
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
                  initialImagePath: widget.profileImage,
                  onImageSelected: (File imageFile, List<int> bytes) {
                    updateStatusOfSelectedImage(context, imageFile, bytes);
                  },
                  allowSelection: true,
                  gender: widget.gender,
                  isFor: '', isForEdit: false,
                )
              : widget.gender.contains('male')
                  ? ImagePickerPreviewContainer(
                      containerSize: 100.0,
                      initialImagePath: widget.profileImage,
                      onImageSelected: (File imageFile, List<int> bytes) {
                        updateStatusOfSelectedImage(context, imageFile, bytes);
                      },
                      allowSelection: true,
                      gender: widget.gender,
                      isFor: '', isForEdit: false,
                    )
                  : Container(),
          const SizedBox(
            width: 10,
          ),
          
          Text(
            AppLocalizations.of(context).translate('Change profile Pic'),
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

  void updateStatusOfSelectedImage(
      BuildContext context, File imageFile, List<int> bytes) {
    // Show SnackBar indicating file upload
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(), // Add a circular progress indicator
            SizedBox(width: 16),
            
            Text(AppLocalizations.of(context).translate('Uploading file...')), // Text indicating file upload
          ],
        ),
      ),
    );

    // Call the uploadProfile method to upload the image file
    UserService().uploadImageProfile(imageFile, bytes).then((_) {
      // Once the upload is complete, hide the SnackBar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Show a SnackBar indicating upload success
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content:
          
              Text(AppLocalizations.of(context).translate('File uploaded successfully')), // Show upload success message
        ),
      );
    }).catchError((error) {
      // If there's an error during upload, hide the SnackBar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Show a SnackBar indicating upload failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          
          content:
              Text('${AppLocalizations.of(context).translate('Error uploading file:')}''$error'), // Show upload error message
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
