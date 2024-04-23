import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class CreatorsPage extends StatefulWidget {
  const CreatorsPage({Key? key}) : super(key: key);

  @override
  _CreatorsPageState createState() => _CreatorsPageState();
}

class _CreatorsPageState extends State<CreatorsPage> {
  late List<User> users = [];
  late String loggedUserID;
 int _page = 1; // Initial page number
  final int _pageSize = 10; // Number of recipes per page
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creators'),
      ),
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
              return InkWell(
                  
                  onTap: () {
                    print('got : ${user.username}');
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProfilePage(user:user)),
                );
                  },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                onImageSelected:  (file, bytes) {},
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
                                'Member Since: ${user.memberSince}',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Recipe Length: ${user.recipes!.length}',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              // Toggle follow/unfollow action here
                            },
                            child: Text(
                              user.followedBy!.contains(loggedUserID)
                                  ? 'Unfollow'
                                  : 'Follow',
                            ),
                          ),
                        ],
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
