import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class Creators extends StatefulWidget {
  final bool showAllUsers;

  const Creators({
    Key? key,
    required this.showAllUsers,
  }) : super(key: key);

  @override
  State<Creators> createState() => _CreatorsState();
}

class _CreatorsState extends State<Creators> {
  late List<User> users = [];
  String currentUserId = '';
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    if (widget.showAllUsers) {
      _fetchAllUsers();
    } else {
      _fetchFollowingUsers();
    }
  }

 

  Future<void> _fetchAllUsers() async {
    final userList = await UserService.getAllUsers();
    String getCurrentUserId = await UserService().getCurrentUserId();
    currentUserId = getCurrentUserId; // Move this line outside of setState

    if (currentUserId != null) {
      // Get the IDs of users followed by the current user
      final followingUser = await UserService().getFollowingUsers();
      final followingUserIds =
          followingUser.map((user) => user.id).toList(); // Extract user IDs

      setState(() {
        users = userList
            .where((user) =>
                user.id != currentUserId && !followingUserIds.contains(user.id))
            .toList();
      });
    }
  }

  Future<void> _fetchFollowingUsers() async {
    try {
      // Query your backend to fetch the list of followed users for the current user
      final List<User> followedUsers = await UserService().getFollowingUsers();
      String getCurrentUserId = await UserService().getCurrentUserId();
      currentUserId = getCurrentUserId; // Move this line outside of setStat
      setState(() {
        // Update the users list with the filtered list of followed users
        users = followedUsers;
      });
    } catch (e) {
      print('Error fetching followed users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return SizedBox(
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
                              initialImagePath: user.profileImage,
                              allowSelection: false, isForEdit: false,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRoleChip(user.role ?? ''),
                                Text(
                                  user.username,
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
                          '${user.recipes!.length} Recipes',
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
                              isFollowing ? buttonText = 'Following' : 'UnFollowing';
                            });
                            if (user.followedBy!.contains(currentUserId)) {
                              // Call the unfollowUser method from the UserService
                              UserService().unfollowUser(user.id).then((_) {
                                // Handle success                     
                                setState(() {
                                  // Update the UI to reflect the change
                                  isFollowing = false;
                                  
                                  widget.showAllUsers
                                      ? _fetchAllUsers()
                                      : _fetchFollowingUsers();
                                });
                              }).catchError((error) {
                                // Handle error
                               
                              });
                            } else {
                              // Call the followUser method from the UserService
                              UserService().followUser(user.id).then((_) {
                                // Handle success
                              
                                setState(() {
                                  // Update the UI to reflect the change

                                  isFollowing = true;
                                  
                                  widget.showAllUsers
                                      ? _fetchAllUsers()
                                      : _fetchFollowingUsers();
                                });
                              }).catchError((error) {
                                // Handle error
                              
                              });
                            }
                          },
                          child:  Text(
                                  user.followedBy!.contains(currentUserId)
                                      ? 'Unfollow'
                                      : 'Follow',
                                )
                             ,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: _getRoleColor(role),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: Responsive.isDesktop(context)
              ? Constants.desktopFontSize
              : Constants.mobileFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.yellow;
      case 'user':
        return Colors.grey;
      case 'New Member':
        return Colors.blue;
      case 'Old Member':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
