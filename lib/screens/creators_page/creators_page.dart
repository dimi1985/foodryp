import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_app_bar.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_creator_card.dart';
import 'package:foodryp/widgets/CustomWidgets/menuWebItems.dart';

class CreatorsPage extends StatefulWidget {
  final User user;

  const CreatorsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CreatorsPage> createState() => _CreatorsPageState();
}

class _CreatorsPageState extends State<CreatorsPage> {
  late List<User> _users = [];
  bool _isLoading = false;
  String currentPage = 'Creators';
  String currentLoggedUserId = Constants.emptyField;

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
      final users = await UserService.getUsersByPage(1, 10);
      final getCurrentUserId = await UserService().getCurrentUserId();

      setState(() {
        currentLoggedUserId = getCurrentUserId;
        _users = users.where((user) => user.id != widget.user.id).toList();
      
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      appBar: kIsWeb
          ? CustomAppBar(
              isDesktop: true,
              isAuthenticated: true,
              profileImage: widget.user.profileImage,
              username: widget.user.username,
              onTapProfile: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(user: widget.user),
                  ),
                );
              },
              user: widget.user,
              menuItems: isDesktop
                  ? MenuWebItems(
                      user: widget.user,
                      currentPage: currentPage,
                    )
                  : Container(),
            )
          : AppBar(),
      endDrawer: !isDesktop
          ? MenuWebItems(user: widget.user, currentPage: currentPage)
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return CustomCreatorCard(
                  user: user,
                  currentLoggedUserId: currentLoggedUserId,
                );
              },
            ),
    );
  }
}
