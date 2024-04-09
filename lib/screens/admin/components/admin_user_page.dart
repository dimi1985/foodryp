import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({Key? key}) : super(key: key);

  @override
  _AdminUserPageState createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  late List<User> _users = [];
  late final List<String> _roles = ['user', 'admin', 'moderator']; // Define the roles
  late Map<String, String> _selectedRoles = {};
  late Map<String, bool> _isUpdatingMap = {}; // Track update status for each user

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await UserService.getAllUsers();
      setState(() {
        _users = users;
        _selectedRoles = { for (var user in users) user.id : user.role! };
        _isUpdatingMap = { for (var user in users) user.id : false };
      });
    } catch (e) {
      print('Error fetching users: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: _users.isEmpty
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit:Responsive.isDesktop(context) ?  BoxFit.none:BoxFit.fitWidth,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Expanded(child: Text('Username'))),
                            DataColumn(label: Expanded(child: Text('Email'))),
                            DataColumn(label: Expanded(child: Text('Member Since'))),
                            DataColumn(label: Expanded(child: Text('Role'))),
                            DataColumn(label: Expanded(child: Text('Actions'))), // New column for actions
                          ],
                          rows: _users.map((user) {
                            return DataRow(cells: [
                              DataCell(Text(user.username)),
                              DataCell(Text(user.email)),
                              DataCell(
                                Text(
                                  DateFormat('dd MMM yyyy - hh:mm a')
                                      .format(user.memberSince!),
                                ),
                              ),
                              DataCell(
                                DropdownButton<String>(
                                  value: _selectedRoles[user.id],
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedRoles[user.id] = newValue!;
                                    });
                                  },
                                  items: _roles.map<DropdownMenuItem<String>>((role) {
                                    return DropdownMenuItem<String>(
                                      value: role,
                                      child: Text(role.toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: _isUpdatingMap[user.id]! // Check if updating
                                      ? null
                                      : () async {
                                          setState(() {
                                            _isUpdatingMap[user.id] = true;
                                          });
                                          try {
                                            await UserService.updateUserRole(
                                                user.id, _selectedRoles[user.id]!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Row(
                                                  children: [
                                                    Icon(Icons.check,
                                                        color: Colors.green),
                                                    SizedBox(width: 8),
                                                    Text('Role updated successfully'),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Row(
                                                  children: [
                                                    Icon(Icons.error,
                                                        color: Colors.red),
                                                    SizedBox(width: 8),
                                                    Text('Failed to update role'),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } finally {
                                            setState(() {
                                              _isUpdatingMap[user.id] = false;
                                            });
                                          }
                                        },
                                  child: _isUpdatingMap[user.id]!
                                      ? CircularProgressIndicator()
                                      : const Text('Update'),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
