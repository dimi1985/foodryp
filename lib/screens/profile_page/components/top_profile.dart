// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
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
  UserService userService = UserService();
  List<String> userIdFollowedByRequest = [];
  List<User> followingUsers = [];
  bool _isLoading = false;

  @override
  void initState() {
    getFolowedUserAddForSearch(userIdFollowedByRequest);
     fetchFollowingUsers();
    super.initState();
  }

  void getFolowedUserAddForSearch(List<String> userIdFollowedByRequest) {
    for (var userId in widget.user.followedByRequest!) {
      userIdFollowedByRequest.add(userId);
    }
  }

    Future<void> fetchFollowingUsers() async {
    try {
      final List<User> users = await userService.getFollowingUsers();
      setState(() {
        followingUsers = users;
      });
    } catch (error) {
      print('Error fetching following users: $error');
    }
  }

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
            SizedBox(height: Responsive.isDesktop(context) ? 35 : 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context).translate('Message'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Constants.secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                Stack(
                  children: [
                    TextButton(
                      onPressed: () {
                        _showFollowBackMenu(context, widget.user.followedBy!);
                      },
                      child: Text(
                        AppLocalizations.of(context).translate('Following'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Constants.secondaryColor,
                        ),
                      ),
                    ),
                    if (widget.user.followedByRequest!.isNotEmpty)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 10, // Adjust size as needed
                          height: 10, // Adjust size as needed
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
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
        builder: (context) => SettingsPage(user: widget.user),
      ),
    );
  }

  void _showFollowBackMenu(
      BuildContext context, List<String> followedBy) async {
    final List<User> users =
        await userService.searchUsersByFollowedByRequest(followedBy);

    // Show a context menu with information about the users following you
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: 400,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Display users following you
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {
                        final User userToFollowBack = users[index];
                        final bool isFollowing = followingUsers.any((user) => user.id == userToFollowBack.id);
                        return ListTile(
                          leading: userToFollowBack.gender!.contains('female')
                              ? ImagePickerPreviewContainer(
                                  containerSize: 100.0,
                                  initialImagePath:
                                      userToFollowBack.profileImage,
                                  onImageSelected:
                                      (File imageFile, List<int> bytes) {},
                                  allowSelection: false,
                                  gender: userToFollowBack.gender!,
                                  isFor: '',
                                  isForEdit: false,
                                )
                              : userToFollowBack.gender!.contains('male')
                                  ? ImagePickerPreviewContainer(
                                      containerSize: 100.0,
                                      initialImagePath:
                                          userToFollowBack.profileImage,
                                      onImageSelected:
                                          (File imageFile, List<int> bytes) {},
                                      allowSelection: false,
                                      gender: userToFollowBack.gender!,
                                      isFor: '',
                                      isForEdit: false,
                                    )
                                  : Container(),
                          title: Text(userToFollowBack.username),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Logic to follow the user back
                              setState(() {
                                _isLoading = true;
                              });
                              userService
                                  .followBack(userToFollowBack.id)
                                  .then((success) {
                                if (success) {
                                  // Refresh the UI if necessary
                                  setState(() {
                                    _isLoading = false;
                                    ;
                                  });
                                }
                              });
                            },
                             child: _isLoading ? const CircularProgressIndicator() : Text(isFollowing ? 'Following' : 'Follow Back'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
  

}
