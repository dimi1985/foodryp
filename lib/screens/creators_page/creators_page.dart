import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_creator_card.dart';
import 'package:foodryp/widgets/CustomWidgets/shimmer_custom_creator_card.dart';

class CreatorsPage extends StatefulWidget {
  final User user;

  const CreatorsPage({super.key, required this.user});

  @override
  State<CreatorsPage> createState() => _CreatorsPageState();
}

class _CreatorsPageState extends State<CreatorsPage> {
  late List<User> _users = [];
  bool _isLoading = true;

  String currentPage = 'Creators';
  String currentLoggedUserId = Constants.emptyField;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchCurrentUserId();
  }

  Future<void> _fetchCurrentUserId() async {
    final getCurrentUserId = await UserService().getCurrentUserId();
    if (mounted) {
      setState(() {
        currentLoggedUserId = getCurrentUserId;
      });
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await UserService.getUsersByPage(1, 10);
      if (mounted) {
        setState(() {
          _users = users.where((user) => user.id != widget.user.id).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creators'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: ListView.builder(
          itemCount: _isLoading ? 10 : _users.length,
          itemBuilder: (context, index) {
            if (_isLoading) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ShimmerCustomCreatorCard(),
              );
            } else {
              final user = _users[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(user: user),
                      ),
                    );
                  },
                  child: CustomCreatorCard(
                    user: user,
                    currentLoggedUserId: currentLoggedUserId,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
