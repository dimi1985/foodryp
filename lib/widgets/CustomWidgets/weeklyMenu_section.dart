import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/add_weekly_menu_page.dart';
import 'package:foodryp/screens/weekly_menu_detail_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_weekly_menu_card.dart';
import 'package:foodryp/widgets/CustomWidgets/shimmer_weekly_menu_list.dart';
import 'package:foodryp/widgets/shimmer_custom_weekly_menu_card.dart';

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
  List<WeeklyMenu> weeklyDietList = [];
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
      setState(() {
        isLoading = true;
      });

      currentUserId = await UserService().getCurrentUserId();
      List<WeeklyMenu> fetchedMenus = [];

      if (widget.showAll) {
        fetchedMenus = await mealService.getWeeklyMenusFixedLength(4);
      } else {
        if (widget.publicUserId == currentUserId) {
          fetchedMenus = await mealService.getWeeklyMenusByPageAndUser(1, 10);
        } else {
          fetchedMenus = await mealService.getWeeklyMenusByPageAndPublicUser(
              1, 10, widget.publicUserId);
        }
      }

      // Clear existing lists before populating with new data
      setState(() {
        if (widget.isForDiet) {
          weeklyDietList =
              fetchedMenus.where((menu) => menu.isForDiet).toList();
        } else {
          weeklyList = fetchedMenus.where((menu) => !menu.isForDiet).toList();
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching weekly menus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayList = widget.isForDiet ? weeklyDietList : weeklyList;
    final isUserProfile = widget.publicUserId == currentUserId;

    return displayList.isEmpty
        ? isLoading
            ? const ShimmerWeeklyMenuList() // Use the shimmer widget here
            : widget.showAll
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isUserProfile)
                        Center(
                          child: MaterialButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddWeeklyMenuPage(
                                    meal: null,
                                    isForEdit: false,
                                    isForDiet: widget.isForDiet,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context).translate(
                                  widget.isForDiet
                                      ? AppLocalizations.of(context)
                                          .translate('Add Weekly Diet Menu')
                                      : AppLocalizations.of(context)
                                          .translate('Add Weekly Menu')),
                            ),
                          ),
                        ),
                    ],
                  )
        : ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!widget.showAll && isUserProfile)
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
                      child: Text(
                        AppLocalizations.of(context).translate(
                          widget.isForDiet
                              ? AppLocalizations.of(context)
                                  .translate('Add Weekly Diet Menu')
                              : AppLocalizations.of(context)
                                  .translate('Add Weekly Menu'),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: isLoading ? 4 : displayList.length, // Show shimmer cards while loading
                    itemBuilder: (context, index) {
                      if (isLoading) {
                        return const ShimmerCustomWeeklyMenuCard();
                      } else {
                        final meal = displayList[index];
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
                            isForDiet: widget.isForDiet,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
