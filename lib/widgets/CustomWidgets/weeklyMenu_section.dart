import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/add_weekly_menu_page.dart';
import 'package:foodryp/screens/weekly_menu_detail_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_weekly_menu_card.dart';

class WeeklyMenuSection extends StatefulWidget {
  final bool showAll;
  final String publicUsername;
  final String publicUserId;
  final List<String>? userRecipes;
  final bool isForDiet;

  const WeeklyMenuSection({
    super.key,
    required this.showAll,
    required this.publicUsername,
    required this.publicUserId,
    this.userRecipes,
    required this.isForDiet,
  });

  @override
  State<WeeklyMenuSection> createState() => _WeeklyMenuSectionState();
}

class _WeeklyMenuSectionState extends State<WeeklyMenuSection> {
  List<WeeklyMenu> weeklyList = [];
  bool isLoading = false;
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    fetchWeeklyMenus().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> fetchWeeklyMenus() async {
    final mealService = MealService();
    try {
      // Fetch weekly menus
      setState(() {
        isLoading = true;
      });

      List<WeeklyMenu> fetchedMenus = [];

      currentUserId = await UserService().getCurrentUserId();

      if (widget.showAll) {
        fetchedMenus = await mealService.getWeeklyMenusFixedLength(4);
      } else {
        if (widget.publicUserId.isEmpty) {
          // Fetch user profile if it's the logged-in user's profile
          mealService.getWeeklyMenusByPageAndUser(
            1,
            10,
          );
        } else {
          // Fetch public user profile if it's a different user's profile
          fetchedMenus = await mealService.getWeeklyMenusByPageAndPublicUser(
              1, 10, widget.publicUserId);
        }
      }

     setState(() {
  if (widget.isForDiet) {
    weeklyList = fetchedMenus.where((menu) => menu.isForDiet == true).toList();
  } else {
    weeklyList = fetchedMenus;
  }
  isLoading = false;
  print(weeklyList);
});
    } catch (e) {
      print('Error fetching weekly menus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return weeklyList.isEmpty
        ? isLoading
            ? const LinearProgressIndicator()
            : widget.showAll
                ? Container()
                : Center(
                    child: widget.userRecipes!.length < 7
                        ? null
                        : MaterialButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddWeeklyMenuPage(
                                        meal: null,
                                        isForEdit: false,
                                        isForDiet: widget.isForDiet)),
                              );
                            },
                            child: Text(AppLocalizations.of(context).translate(
                                widget.isForDiet
                                    ? 'Add Weekly Diet Menu'
                                    : 'Add Weekly Menu')),
                          ),
                  )
        : ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!widget.showAll && widget.publicUserId == currentUserId)
                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWeeklyMenuPage(
                                    meal: null,
                                    isForEdit: false,
                                    isForDiet: widget.isForDiet,
                                  )),
                        );
                      },
                      child:  Text(AppLocalizations.of(context).translate(
                                widget.isForDiet
                                    ? 'Add Weekly Diet Menu'
                                    : 'Add Weekly Menu')),
                    ),
                  ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: weeklyList.length,
                    itemBuilder: (context, index) {
                      final meal = weeklyList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WeeklyMenuDetailPage(meal: meal)),
                          );
                        },
                        child: CustomWeeklyMenuCard(
                          meal: meal,
                          currentPage: '',
                          isForAll: widget.showAll,
                          publicUserId: widget.publicUserId,
                          currentUserId: currentUserId,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
