import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_screen/profile_screen.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class CustomCreatorCard extends StatefulWidget {
  final User user;
  final String currentUserId;
  final Future<void> Function() fetchAllUsers;
  Future<void> Function() fetchFollowingUsers;
  final bool showAllUsers;
  bool isFollowing;
  CustomCreatorCard({
    super.key,
    required this.user,
    required this.currentUserId,
    required this.fetchAllUsers,
    required this.fetchFollowingUsers,
    required this.showAllUsers,
    required this.isFollowing,
  });

  @override
  State<CustomCreatorCard> createState() => _CustomCreatorCardState();
}

class _CustomCreatorCardState extends State<CustomCreatorCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    user: widget.user,
                  )),
        );
      },
      child: SizedBox(
        width: 250,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImagePickerPreviewContainer(
                      containerSize: 40,
                      onImageSelected: (file, list) {},
                      gender: '',
                      isFor: '',
                      initialImagePath: widget.user.profileImage,
                      allowSelection: false,
                      isForEdit: false,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.username,
                          style: TextStyle(
                            fontSize: Responsive.isDesktop(context)
                                ? Constants.desktopFontSize
                                : Constants.mobileFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  '${widget.user.recipes!.length} Recipes',
                  style: TextStyle(
                    fontSize: Responsive.isDesktop(context)
                        ? Constants.desktopFontSize
                        : Constants.mobileFontSize,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String buttonText = '';
                    setState(() {
                      widget.isFollowing
                          ? buttonText = 'Following'
                          : 'UnFollowing';
                    });
                    if (widget.user.followedBy!
                        .contains(widget.currentUserId)) {
                      // Call the unfollowUser method from the UserService
                      UserService().unfollowUser(widget.user.id).then((_) {
                        // Handle success
                        setState(() {
                          // Update the UI to reflect the change
                          widget.isFollowing = false;

                          widget.showAllUsers
                              ? widget.fetchAllUsers()
                              : widget.fetchFollowingUsers();
                        });
                      }).catchError((error) {
                        // Handle error
                      });
                    } else {
                      // Call the followUser method from the UserService
                      UserService().followUser(widget.user.id).then((_) {
                        // Handle success

                        setState(() {
                          // Update the UI to reflect the change

                          widget.isFollowing = true;

                          widget.showAllUsers
                              ? widget.fetchAllUsers()
                              : widget.fetchFollowingUsers();
                        });
                      }).catchError((error) {
                        // Handle error
                      });
                    }
                  },
                  child: Text(
                    widget.user.followedBy!.contains(widget.currentUserId)
                        ? 'Unfollow'
                        : 'Follow',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
