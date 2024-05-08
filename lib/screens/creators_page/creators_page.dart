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

  const CreatorsPage({super.key, required this.user});

  @override
  State<CreatorsPage> createState() => _CreatorsPageState();
}

class _CreatorsPageState extends State<CreatorsPage> {
  late List<User> _users = [];

  String currentPage = 'Creators';
  String currentLoggedUserId = Constants.emptyField;

  @override
  void initState() {
    super.initState();
   
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
 
    try {
      final users = await UserService.getUsersByPage(1, 10);
      final getCurrentUserId = await UserService().getCurrentUserId();

      setState(() {
        currentLoggedUserId = getCurrentUserId;

        _users = users.where((user) => user.id != widget.user.id).toList();

   
      });
    } catch (e) {
      print('Error fetching users: $e');
    
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
      endDrawer: !isDesktop && kIsWeb
          ? MenuWebItems(user: widget.user, currentPage: currentPage)
          : null,
      body: Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  user: user,
                                )),
                      );
                    },
                    child: CustomCreatorCard(
                      user: user,
                      currentLoggedUserId: currentLoggedUserId,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
