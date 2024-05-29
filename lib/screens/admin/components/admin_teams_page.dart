import 'package:flutter/material.dart';

class AdminTeamsPage extends StatefulWidget {
  const AdminTeamsPage({super.key, String? userRole});

  @override
  State<AdminTeamsPage> createState() => _AdminTeamsPageState();
}

class _AdminTeamsPageState extends State<AdminTeamsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Teams')),
    );
  }
}
