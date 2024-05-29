// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/main.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/admin/admin_panel_screen.dart';
import 'package:foodryp/screens/bottom_nav_screen.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/screens/settings_page/components/delete_account_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/language.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/search_settings_provider.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/token_manager.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/changeFieldDialog.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/widgets/CustomWidgets/language_settings_tile.dart';
import 'package:foodryp/widgets/measurement_conversion_table.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final User user;
  const SettingsPage({
    super.key,
    required this.user,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<Language> supportedLanguages;
  int _selectedLanguageIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final searchSettingsProvider = Provider.of<SearchSettingsProvider>(context);


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Settings')),
        actions: [
          if (widget.user.role!.contains('admin'))
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  AdminPanelScreen(user:widget.user)),
                  );
                },
                child: Text(AppLocalizations.of(context).translate('Admin Panel')))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        children: [
          _sectionTitle(AppLocalizations.of(context).translate('Account')),

          userImageSection(context, isDesktop),

          _settingTile(
            context,
            'Change Email Address',
            Icons.email,
            () {
              showDialog(
                context: _scaffoldKey.currentContext!,
                builder: (BuildContext context) {
                  return ChangeFieldDialog(
                    context: context,
                    title:
                        '${AppLocalizations.of(context).translate('Change Email')}\n(${widget.user.email})\n${AppLocalizations.of(context).translate('(Signout is automatic after change)')}',
                    hintText: 'Enter new email',
                    newHintText: '',
                    onSave: (String newEmail, String nullValue) async {
                      UserService()
                          .changeCredentials(
                        oldPassword: '',
                        newUsername: '',
                        newEmail: newEmail,
                        newPassword: '',
                      )
                          .then((value) {
                        if (value) {
                          // Email changed successfully
                          // Show success snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)
                                  .translate('Email changed successfully')),
                              duration: const Duration(
                                  seconds: 2), // Adjust duration as needed
                            ),
                          );

                          signout(_scaffoldKey.currentContext!);
                        } else {
                          // Failed to change email
                          // Show error snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context).translate(
                                  AppLocalizations.of(context).translate('Failed to change email, Please try again.'))),
                              duration: const Duration(
                                  seconds: 2), // Adjust duration as needed
                            ),
                          );
                        }
                      }).catchError((error) {
                        // Show error snackbar if something went wrong
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context).translate('Failed to change email, Please try again.')),
                            duration: const Duration(
                                seconds: 2), // Adjust duration as needed
                          ),
                        );
                      });
                    },
                    isForPassword: false,
                  );
                },
              );
            },
          ),
          _settingTile(
            context,
            'Change Password',
            Icons.lock,
            () {
              showDialog(
                context: _scaffoldKey.currentContext!,
                builder: (BuildContext context) {
                  return ChangeFieldDialog(
                    context: context, 
                    title:
                        '${ AppLocalizations.of(context).translate('Change Password')}\n${AppLocalizations.of(context).translate('(Signout is automatic after change)')}',
                    hintText: AppLocalizations.of(context).translate('Enter old Password'),
                    newHintText: AppLocalizations.of(context).translate('Enter new Password'),
                    onSave: (String oldPassword, String newPassword) async {
                      UserService()
                          .changeCredentials(
                        oldPassword: oldPassword,
                        newUsername: '',
                        newEmail: '',
                        newPassword: newPassword,
                      )
                          .then((value) {
                        if (value) {
                          // Password changed successfully
                          // Show success snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                              
                              content: Text(AppLocalizations.of(context).translate('Password changed successfully')),
                              duration:const Duration(
                                  seconds: 2), // Adjust duration as needed
                            ),
                          );

                          signout(_scaffoldKey.currentContext!);
                        } else {
                          // Failed to change password
                          // Show error snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Failed to change password. Please try again.'),
                              duration: Duration(
                                  seconds: 2), // Adjust duration as needed
                            ),
                          );
                        }
                      }).catchError((error) {
                        // Show error snackbar if something went wrong
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context).translate('Password changed successfully')),
                            duration: const Duration(
                                seconds: 2), // Adjust duration as needed
                          ),
                        );
                      });
                    },
                    isForPassword: true,
                  );
                },
              );
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
                    title: Text(AppLocalizations.of(context)
                        .translate('Delete Account')),
                    content: Text(AppLocalizations.of(context).translate(
                        'Are you sure you want to delete your account along with its recipes?')),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Close dialog
                          Navigator.of(context).pop();
                        },
                        child: Text(
                            AppLocalizations.of(context).translate('Cancel')),
                            
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
                        child: Text(
                            AppLocalizations.of(context).translate('Delete')),
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
                  title: Text(
                      AppLocalizations.of(context).translate('Dark Theme')),
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
            isSelected: _selectedLanguageIndex == 0,
            onTap: () {
              setState(() {
                _selectedLanguageIndex = 0;
              });
              const locale = Locale('en', 'US');
              Foodryp.setLocale(context, locale);
            },
          ),
          LanguageSettingsTile(
            title: AppLocalizations.of(context).translate('Greek'),
            isSelected: _selectedLanguageIndex == 1,
            onTap: () {
              setState(() {
                _selectedLanguageIndex = 1;
              });
              const locale = Locale('el', 'GR');
              Foodryp.setLocale(context, locale);
            },
          ),

          _sectionTitle(
              AppLocalizations.of(context).translate('Units and Measurements')),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MeasurementConversionTable(),
          ),

          _sectionTitle(AppLocalizations.of(context).translate(
              AppLocalizations.of(context).translate('Search Settings'))),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                    AppLocalizations.of(context).translate('Search on Submit')),
                leading: Radio(
                  value: false,
                  groupValue: searchSettingsProvider.searchOnEveryKeystroke,
                  onChanged: (value) {
                    searchSettingsProvider.searchOnEveryKeystroke = value!;
                  },
                ),
                onTap: () {
                  searchSettingsProvider.searchOnEveryKeystroke = false;
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)
                    .translate('Search on Every Keystroke')),
                leading: Radio(
                  value: true,
                  groupValue: searchSettingsProvider.searchOnEveryKeystroke,
                  onChanged: (value) {
                    searchSettingsProvider.searchOnEveryKeystroke = value!;
                  },
                ),
                onTap: () {
                  searchSettingsProvider.searchOnEveryKeystroke = true;
                },
              ),
            ],
          ),
          // Add units and measurements settings tiles here
        ],
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
          widget.user.gender!.contains('female')
              ? ImagePickerPreviewContainer(
                  containerSize: 100.0,
                  initialImagePath: widget.user.profileImage,
                  onImageSelected: (File imageFile, List<int> bytes) {
                    updateStatusOfSelectedImage(context, imageFile, bytes);
                  },
                  allowSelection: true,
                  gender: widget.user.gender!,
                  isFor: '',
                  isForEdit: false,
                )
              : widget.user.gender!.contains('male')
                  ? ImagePickerPreviewContainer(
                      containerSize: 100.0,
                      initialImagePath: widget.user.profileImage,
                      onImageSelected: (File imageFile, List<int> bytes) {
                        updateStatusOfSelectedImage(context, imageFile, bytes);
                      },
                      allowSelection: true,
                      gender: widget.user.gender!,
                      isFor: '',
                      isForEdit: false,
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
            const CircularProgressIndicator(), // Add a circular progress indicator
            const SizedBox(width: 16),

            Text(AppLocalizations.of(context)
                .translate('Uploading file...')), // Text indicating file upload
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
          content: Text(AppLocalizations.of(context).translate(
              'File uploaded successfully')), // Show upload success message
        ),
      );
    }).catchError((error) {
      // If there's an error during upload, hide the SnackBar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Show a SnackBar indicating upload failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${AppLocalizations.of(context).translate('Error uploading file:')}'
              '$error'), // Show upload error message
        ),
      );
    });
  }

  void signout(BuildContext context) async {
    // Clear user ID from shared preferences
    await UserService().clearUserId();
    await TokenManager.clearTokenLocally();
    // Navigating to the main screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            kIsWeb ? const EntryWebNavigationPage() : const BottomNavScreen(),
      ),
      (route) => false,
    );
  }
}
