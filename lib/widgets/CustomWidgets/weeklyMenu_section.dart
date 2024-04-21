import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/add_weekly_menu_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class WeeklyMenuSection extends StatefulWidget {
  final bool showAll;
  final String publicUsername;
  const WeeklyMenuSection({super.key, required this.showAll, required this.publicUsername});

  @override
  State<WeeklyMenuSection> createState() => _WeeklyMenuSectionState();
}

class _WeeklyMenuSectionState extends State<WeeklyMenuSection> {
  List<WeeklyMenu> weeklyList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWeeklyMenus();
  }

  Future<void> fetchWeeklyMenus() async {
    try {
      // Fetch weekly menus
      setState(() {
        isLoading = true;
      });

      List<WeeklyMenu> fetchedMenus = [];
      if(widget.showAll){
        fetchedMenus =
          await MealService().getWeeklyMenusByPage(1, 10);
      }else{
 fetchedMenus =
          await MealService().getWeeklyMenusByPageAndUser(1, 10);
      }
      
      setState(() {
        weeklyList = fetchedMenus;
        isLoading = false;
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
            :!widget.showAll? Container(): Center(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddWeeklyMenuPage(
                                meal: null,
                                isForEdit: false,
                              )),
                    );
                  },
                  child: const Text('Add Weekly Menu'),
                ),
              )
        : SizedBox(
            height: 300,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!widget.showAll)
                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddWeeklyMenuPage(
                                    meal: null,
                                    isForEdit: false,
                                  )),
                        );
                      },
                      child: const Text('Add Weekly Menu'),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weeklyList.length,
                      itemBuilder: (context, index) {
                        final meal = weeklyList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddWeeklyMenuPage(
                                      meal: meal, isForEdit: true)),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.all(Constants.defaultPadding),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ImagePickerPreviewContainer(
                                          containerSize: 10,
                                          onImageSelected: (file, list) {},
                                          gender: '',
                                          isFor: '',
                                          initialImagePath:
                                              meal.userProfileImage,
                                          isForEdit: false,
                                          allowSelection: false,
                                        ),
                                        const SizedBox(width: 5), //
                                        Text(
                                          meal.username,
                                        ),
                                        const SizedBox(
                                            width:
                                                5), // Adjust the spacing as needed
                                        Text(
                                          '•',
                                          style: TextStyle(
                                            fontSize:
                                                Responsive.isDesktop(context)
                                                    ? Constants.desktopFontSize
                                                    : Constants.mobileFontSize,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          meal.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: meal.dayOfWeek.length,
                                        itemBuilder: (context, index) {
                                          final dayOfWeek =
                                              meal.dayOfWeek[index];

                                          final recipeImage =
                                              ('${Constants.baseUrl}/${dayOfWeek.recipeImage}')
                                                  .replaceAll('\\', '/');
                                          return Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Left side - Day and recipe details
                                                      Expanded(
                                                        flex: 5,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Day ${index + 1}', // Adjust day text as needed
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.7),
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              getWeekdayName(
                                                                  index),
                                                              const SizedBox(
                                                                  height: 10),
                                                              // Recipe details
                                                              Text(
                                                                dayOfWeek
                                                                    .recipeTitle,
                                                                style:
                                                                    GoogleFonts
                                                                        .getFont(
                                                                  dayOfWeek
                                                                      .categoryFont,
                                                                  color: HexColor(
                                                                          dayOfWeek
                                                                              .categoryColor)
                                                                      .withOpacity(
                                                                          0.7),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              // Add more recipe details here
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      // Right side - Recipe image
                                                      Expanded(
                                                        flex: 5,
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child:
                                                                Image.network(
                                                              recipeImage,
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const SizedBox(
                                            width: 15,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget getWeekdayName(int index) {
    switch (index) {
      case 0:
        return const Text('Monday');
      case 1:
        return const Text('Tuesday');
      case 2:
        return const Text('Wednesday');
      case 3:
        return const Text('Thursday');
      case 4:
        return const Text('Friday');
      case 5:
        return const Text('Saturday');
      case 6:
        return const Text('Sunday');
      default:
        return Container();
    }
  }
}
