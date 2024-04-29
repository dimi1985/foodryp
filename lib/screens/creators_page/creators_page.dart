import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_app_bar.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/widgets/CustomWidgets/menuWebItems.dart';

class CreatorsPage extends StatefulWidget {
  final User user;
  const CreatorsPage({super.key, required this.user});

  @override
  _CreatorsPageState createState() => _CreatorsPageState();
}

class _CreatorsPageState extends State<CreatorsPage> {
  late List<User> users = [];
  late String loggedUserID;
  int _page = 1; // Initial page number
  final int _pageSize = 10; // Number of recipes per page
  bool _isLoading = false;
  late String currentPage;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    currentPage = 'Creators';
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final allUsers = await UserService.getUsersByPage(_page, _pageSize);
      final String currentUserId = await UserService().getCurrentUserId();

      setState(() {
        users.addAll(allUsers.where((user) => user.id != currentUserId));
        loggedUserID = currentUserId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreUsers() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _page++;
      });
      try {
        final allUsers = await UserService.getUsersByPage(_page, _pageSize);
        final String currentUserId = await UserService().getCurrentUserId();

        setState(() {
          users.addAll(allUsers.where((user) => user.id != currentUserId));
          loggedUserID = currentUserId;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      appBar: CustomAppBar(
        isDesktop: true,
        isAuthenticated: true,
        profileImage: widget.user.profileImage,
        username: widget.user.username,
        user: widget.user,
        menuItems: isDesktop
            ? MenuWebItems(
                user: widget.user,
                currentPage: currentPage,
              )
            : Container(),
      ),
      endDrawer: !isDesktop
          ? MenuWebItems(user: widget.user, currentPage: currentPage)
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMoreUsers();
            return true;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: users.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < users.length) {
              final user = users[index];
              return Padding(
                padding: const EdgeInsets.all(Constants.defaultPadding),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                              user: user, publicUsername: user.username)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Constants.defaultPadding),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ImagePickerPreviewContainer(
                                  initialImagePath: user.profileImage,
                                  containerSize: 100,
                                  onImageSelected: (file, bytes) {},
                                  gender: user.gender!,
                                  isFor: '',
                                  isForEdit: false,
                                ),
                                Text(
                                  user.username,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '${AppLocalizations.of(context).translate('Member Since:')} ${Constants.calculateMembershipDuration(context, user.memberSince!)}',
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '${AppLocalizations.of(context).translate('Total Recipes:')} ${user.recipes!.length}',
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      // Toggle follow/unfollow action here

                                      setState(() {
                                        _isLoading = true;
                                      });
                                      user.followedBy!.contains(loggedUserID)
                                          ? UserService()
                                              .unfollowUser(user.id)
                                              .then((value) {
                                              if (value) {
                                                user.followedBy!.remove(
                                                    loggedUserID); // Update the local model
                                                setState(() {});
                                              }
                                            })
                                          : UserService()
                                              .followUser(user.id)
                                              .then((value) {
                                              if (value) {
                                                user.followedBy!.add(
                                                    loggedUserID); // Update the local model
                                                setState(() {});
                                              }
                                            });
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                              child: Text(
                                user.followedBy!.contains(loggedUserID)
                                    ? AppLocalizations.of(context)
                                        .translate('Unfollow')
                                    : AppLocalizations.of(context)
                                        .translate('Follow'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return _buildLoader();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
