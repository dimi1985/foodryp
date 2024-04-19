import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_screen/profile_screen.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();

    if (widget.showAllUsers) {
      _fetchAllUsers();
    } else {
      if (isAuthenticated) {
        _fetchFollowingUsers();
      }
    }
  }

  Future<void> _fetchAllUsers() async {
    final userList = await UserService.getAllUsers();
    String getCurrentUserId = await UserService().getCurrentUserId();
    currentUserId = getCurrentUserId; // Move this line outside of setState
    if (!isAuthenticated) {
      setState(() {
        users = userList;
      });
    } else {
      if (currentUserId.isNotEmpty) {
        // Get the IDs of users followed by the current user
        final followingUser = await UserService().getFollowingUsers();
        final followingUserIds =
            followingUser.map((user) => user.id).toList(); // Extract user IDs

        setState(() {
          users = userList
              .where((user) =>
                  user.id != currentUserId &&
                  !followingUserIds.contains(user.id))
              .toList();
        });
      }
    }
  }

  Future<void> _fetchFollowingUsers() async {
    String getCurrentUserId = await UserService().getCurrentUserId();
    currentUserId = getCurrentUserId; // Move this line outside of setState

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

  Future<void> checkAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    setState(() {
      isAuthenticated = userId !=
          null; // Update authentication status based on userId existence
    });
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
              return InkWell(
                onTap: () {
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ProfilePage(username: user.username)),
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
                                initialImagePath: user.profileImage,
                                allowSelection: false,
                                isForEdit: false,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              
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
                                isFollowing
                                    ? buttonText = 'Following'
                                    : 'UnFollowing';
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
                            child: Text(
                              user.followedBy!.contains(currentUserId)
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
            },
          ),
        ),
      ),
    );
  }
}
