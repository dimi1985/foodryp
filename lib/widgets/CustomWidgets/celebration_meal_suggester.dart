// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/celebration_day.dart';
import 'package:foodryp/utils/celebration_settings_provider.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:intl/intl.dart';
import 'package:foodryp/database/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CelebrationMealSuggester extends StatefulWidget {
  const CelebrationMealSuggester({super.key});

  @override
  _CelebrationMealSuggesterState createState() =>
      _CelebrationMealSuggesterState();
}

class _CelebrationMealSuggesterState extends State<CelebrationMealSuggester> {
  late List<CelebrationDay> _celebrations;
  int? daysBeforeNotification;
  var db = getDatabase();

  @override
  void initState() {
    super.initState();
    _celebrations = Constants.defaultCelebEmptyList;
    _loadData();
  }

  Future<void> _loadData() async {
    _celebrations = await db.queryAllCelebrations();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<CelebrationSettingsProvider>(context);

    int daysBeforeNotification = settingsProvider.daysBeforeNotification;
    if (_celebrations.isEmpty) {
      return const Text('No celebrations found.');
    }

    String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    DateTime currentDate = DateTime.now();

    CelebrationDay upcomingCelebration = _celebrations.firstWhere(
      (celebration) => celebration.dueDate.isAfter(currentDate),
      orElse: () => _celebrations.last,
    );

    int daysUntilCelebration =
        upcomingCelebration.dueDate.difference(currentDate).inDays;

    if (daysBeforeNotification != null &&
        daysUntilCelebration <= daysBeforeNotification) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEEE').format(currentDate),
            style: const TextStyle(color: Colors.blue, fontSize: 25.0),
          ),
          Text(
            DateFormat('dd MMMM yyyy').format(currentDate),
            style: const TextStyle(color: Colors.blue, fontSize: 14.0),
          ),
          const SizedBox(height: 20),
          Text(
            '${upcomingCelebration.description} is on ${DateFormat('d MMMM').format(upcomingCelebration.dueDate)} so in $daysUntilCelebration days!',
            style: const TextStyle(color: Colors.blue, fontSize: 14.0),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEEE').format(currentDate),
            style: const TextStyle(color: Colors.blue, fontSize: 25.0),
          ),
          Text(
            DateFormat('dd MMMM yyyy').format(currentDate),
            style: const TextStyle(color: Colors.blue, fontSize: 14.0),
          ),
        ],
      ); // No notification to display
    }
  }
}
