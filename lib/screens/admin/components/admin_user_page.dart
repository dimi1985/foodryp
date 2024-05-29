// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:intl/intl.dart';

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key, String? userRole});

  @override
  _AdminUserPageState createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  late List<User> _users = [];
  late final List<String> _roles = [
    'user',
    'admin',
    'moderator'
  ]; // Define the roles
  late Map<String, String> _selectedRoles = {};
  late Map<String, bool> _isUpdatingMap =
      {}; // Track update status for each user

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
        _selectedRoles = {for (var user in users) user.id: user.role!};
        _isUpdatingMap = {for (var user in users) user.id: false};
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${AppLocalizations.of(context).translate('Error fetching users:')} , $e'),
        ),
      );
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('All Users')),
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
                        fit: Responsive.isDesktop(context)
                            ? BoxFit.none
                            : BoxFit.fitWidth,
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Expanded(
                                child: Text(AppLocalizations.of(context)
                                    .translate('Username')),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(AppLocalizations.of(context)
                                    .translate('Email')),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(AppLocalizations.of(context)
                                    .translate('Member Since')),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(AppLocalizations.of(context)
                                    .translate('Role')),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(AppLocalizations.of(context)
                                    .translate('Actions')),
                              ),
                            ), // New column for actions
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
                                  items: _roles
                                      .map<DropdownMenuItem<String>>((role) {
                                    return DropdownMenuItem<String>(
                                      value: role,
                                      child: Text(role.toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: _isUpdatingMap[
                                          user.id]! // Check if updating
                                      ? null
                                      : () async {
                                          setState(() {
                                            _isUpdatingMap[user.id] = true;
                                          });
                                          try {
                                            await UserService.updateUserRole(
                                                user.id,
                                                _selectedRoles[user.id]!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    const Icon(Icons.check,
                                                        color: Colors.green),
                                                    const SizedBox(width: 8),
                                                    Text(AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            'Role updated successfully')),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    const Icon(Icons.error,
                                                        color: Colors.red),
                                                    const SizedBox(width: 8),
                                                    Text(AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            'Failed to update role')),
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
                                      ? const CircularProgressIndicator()
                                      : Text(AppLocalizations.of(context)
                                          .translate('Update')),
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
