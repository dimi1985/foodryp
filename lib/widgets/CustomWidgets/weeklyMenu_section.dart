import 'package:flutter/material.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/add_weekly_menu_page.dart';
import 'package:foodryp/utils/meal_service.dart';

class WeeklyMenuSection extends StatefulWidget {
  const WeeklyMenuSection({Key? key}) : super(key: key);

  @override
  State<WeeklyMenuSection> createState() => _WeeklyMenuSectionState();
}

class _WeeklyMenuSectionState extends State<WeeklyMenuSection> {
  List<WeeklyMenu> weeklyList = [];

  @override
  void initState() {
    super.initState();
    fetchWeeklyMenus();
  }

  Future<void> fetchWeeklyMenus() async {
    try {
      // Fetch weekly menus
      final List<WeeklyMenu> fetchedMenus =
          await MealService.getWeeklyMenusByPage(1, 10);
      setState(() {
        weeklyList = fetchedMenus;
      });
    } catch (e) {
      print('Error fetching weekly menus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return weeklyList.isEmpty
        ? Center(
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddWeeklyMenuPage()),
                );
              },
              child: const Text('Add Weekly Menu'),
            ),
          )
        : SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weeklyList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(weeklyList[index].title),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
