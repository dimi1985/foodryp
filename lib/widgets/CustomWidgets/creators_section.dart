import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_screen/profile_screen.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/widgets/custom_creator_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Creators extends StatefulWidget {
  final bool showAllUsers;

  const Creators({
    super.key,
    required this.showAllUsers,
  });

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
    currentUserId = getCurrentUserId; 
    if (!isAuthenticated) {
      setState(() {
        users = userList.take(5).toList(); // Limit the users to the first 5
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
              .take(5) // Limit the users to the first 5
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
        users =
            followedUsers.take(4).toList(); // Limit the users to the first 5
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
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return CustomCreatorCard(
                  user: user,
                  currentUserId: currentUserId,
                  fetchAllUsers: _fetchAllUsers,
                  fetchFollowingUsers: _fetchFollowingUsers,
                  showAllUsers: widget.showAllUsers,
                  isFollowing: isFollowing,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
