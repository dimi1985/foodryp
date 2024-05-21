// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AddWeeklyMenuPage extends StatefulWidget {
  final WeeklyMenu? meal;
  final bool isForEdit;
  final bool isForDiet;
  const AddWeeklyMenuPage(
      {super.key,
      required this.meal,
      required this.isForEdit,
      required this.isForDiet});

  @override
  State<AddWeeklyMenuPage> createState() => _AddWeeklyMenuPageState();
}

class _AddWeeklyMenuPageState extends State<AddWeeklyMenuPage> {
  late User userProfile =
      Constants.defaultUser; // Initialize with default value
  List<Recipe> userRecipes = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerForSelctedRecipes =
      ScrollController();
  bool isFetching = false;
  late Map<Recipe, bool> recipeCheckedState = {};
  bool isChecked = false;
  List<Recipe> selectedRecipes = [];
  List<Recipe> unSelectedRecipes = [];
  TextEditingController titleController = TextEditingController();
  int removedIndex = -1;
  bool isMultipleDays = false;
  Map<Recipe, int> recipeCount =
      {}; // Map to hold the count of each recipe added
  @override
  void initState() {
    super.initState();
    fetchUserProfileAndRecipes();

    if (widget.isForEdit) {
      setState(() {
        titleController.text = widget.meal!.title;
        for (var day in widget.meal!.dayOfWeek) {
          final recipe = day;
          selectedRecipes.add(recipe);
        }
      });
    }
    // Add scroll listener
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollControllerForSelctedRecipes.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !isFetching) {
      // Fetch more recipes when the user reaches the end of the list
      fetchMoreRecipes();
    }
  }

  Future<void> fetchUserProfileAndRecipes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final UserService userService = UserService();
      final RecipeService recipeService = RecipeService();

      // Fetch user profile
      userProfile = (await userService.getUserProfile())!;

      // Fetch user recipes with pagination
      userRecipes = await recipeService.getUserRecipesByPage(1, 10);

      // Check if isForDiet is true, filter and exclude non-diet recipes
      // If false, fetch all recipes but exclude diet ones
      if (widget.isForDiet) {
        userRecipes = userRecipes.where((recipe) => recipe.isForDiet).toList();
      } else {
        userRecipes = userRecipes.where((recipe) => !recipe.isForDiet).toList();
      }

      // Check if the meal contains widget meal id and update the checked state accordingly
      for (var recipe in userRecipes) {
        if (recipe.meal?.contains(widget.meal?.id) ?? false) {
          setState(() {
            recipeCheckedState[recipe] = true;
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      SnackBar(
        content: Text(
            '${AppLocalizations.of(context).translate('Error fetching user profile and recipes:')} , $e'),
      );
      print('Error fetching user profile and recipes: $e');
    }
  }

  Future<void> fetchMoreRecipes() async {
    setState(() {
      isFetching = true;
    });
    try {
      final RecipeService recipeService = RecipeService();
      final List<Recipe> moreRecipes = await recipeService.getUserRecipesByPage(
        (userRecipes.length ~/ 10) + 1, // Calculate the next page number
        10, // Adjust as needed
      );

      // Remove duplicates from the new recipes list
      final Set<String?> recipeIds =
          userRecipes.map((recipe) => recipe.id).toSet();
      final List<Recipe> filteredRecipes = moreRecipes
          .where((recipe) => !recipeIds.contains(recipe.id))
          .toList();

      // If isForDiet is true, filter out non-diet recipes
      if (widget.isForDiet) {
        userRecipes.addAll(filteredRecipes.where((recipe) => recipe.isForDiet));
      } else {
        userRecipes.addAll(filteredRecipes);
      }

      setState(() {
        isFetching = false;
      });
    } catch (e) {
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate(
            widget.isForDiet ? 'Add Weekly Diet Menu' : 'Add Weekly Menu')),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Give A Box to drag in the recipes.
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      controller: _scrollControllerForSelctedRecipes,
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return _buildSelectedRecipeList(index, themeProvider);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '${userProfile.username.toUpperCase()} ${AppLocalizations.of(context).translate(widget.isForDiet ? 'Here you can check and put the diet meals of the Week' : 'Here you can check and put the normal meals of the Week')}',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Single Day'),
                          Switch(
                            value: isMultipleDays,
                            onChanged: (value) {
                              setState(() {
                                isMultipleDays = value;
                              });
                            },
                          ),
                          Text('Multiple Days'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Constants.defaultPadding),
                      child: CustomTextField(
                          controller: titleController,
                          hintText: AppLocalizations.of(context)
                              .translate('Enter Title'),
                          labelText:
                              AppLocalizations.of(context).translate('Title')),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Prevent dismissing the dialog by tapping outside
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Row(
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(width: 16),
                                  Text(AppLocalizations.of(context)
                                      .translate('Processing...')),
                                ],
                              ),
                            );
                          },
                        );

                        Future<void> handleResult(Future<bool> result) async {
                          await Future.delayed(Duration(
                              seconds:
                                  Random().nextInt(3) + 1)); // Add delay here
                          bool value = await result;
                          Navigator.pop(context); // Close the alert dialog
                          if (value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EntryWebNavigationPage(),
                                maintainState: false,
                              ),
                              (Route<dynamic> route) => false,
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }

                        if (widget.isForEdit) {
                          handleResult(MealService().updateWeeklyMenu(
                            widget.meal!.id,
                            titleController.text,
                            unSelectedRecipes,
                            selectedRecipes,
                            userProfile.username,
                            userProfile.profileImage,
                            widget.isForDiet,
                          ));
                        } else {
                          handleResult(MealService().saveWeeklyMenu(
                            titleController.text,
                            selectedRecipes,
                            userProfile.username,
                            userProfile.profileImage,
                            widget.isForDiet,
                          ));
                        }
                      },
                      child: Text(AppLocalizations.of(context).translate(
                          widget.isForEdit ? 'Update Menu' : 'Add Menu')),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                // Display user recipes
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Constants.defaultPadding),
                    child: SizedBox(
                      height: 300,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: userRecipes.length + (isFetching ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < userRecipes.length) {
                              final recipe = userRecipes[index];

                              return Padding(
                                padding: const EdgeInsets.all(
                                    Constants.defaultPadding),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Opacity(
                                        opacity:
                                            recipeCheckedState[recipe] ?? false
                                                ? 0.5
                                                : 1.0,
                                        child: ColorFiltered(
                                          colorFilter:
                                              recipeCheckedState[recipe] ??
                                                      false
                                                  ? const ColorFilter.mode(
                                                      Colors.grey,
                                                      BlendMode.saturation,
                                                    )
                                                  : const ColorFilter.mode(
                                                      Colors.transparent,
                                                      BlendMode.saturation,
                                                    ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(32),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 200,
                                                        width: 300,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: themeProvider
                                                                      .currentTheme ==
                                                                  ThemeType.dark
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  37, 36, 37)
                                                              : Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset:
                                                                  const Offset(
                                                                      0, 3),
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
                                                                          .all(
                                                                          20),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      // Recipe details
                                                                      Text(
                                                                        recipe.recipeTitle ??
                                                                            Constants.emptyField,
                                                                        style: GoogleFonts
                                                                            .getFont(
                                                                          recipe.categoryFont ??
                                                                              Constants.emptyField,
                                                                          color:
                                                                              HexColor(recipe.categoryColor ?? Constants.emptyField).withOpacity(0.7),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Expanded(
                                                                        child: isMultipleDays
                                                                            ? Row(
                                                                                children: [
                                                                                  IconButton(
                                                                                    icon: const Icon(Icons.add),
                                                                                    onPressed: () {
                                                                                      // Add recipe logic for multiple days
                                                                                      setState(() {
                                                                                        if (selectedRecipes.length < 7) {
                                                                                          addRecipeByIcon(recipe);
                                                                                        } else {
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                            SnackBar(
                                                                                              content: Text(
                                                                                                AppLocalizations.of(context).translate('You have reached the maximum number of selected recipes.'),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                  IconButton(
                                                                                    icon: const Icon(Icons.remove),
                                                                                    onPressed: () {
                                                                                      // Remove recipe logic for multiple days
                                                                                      setState(() {
                                                                                        removeRecipeByIcon(recipe);
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Checkbox(
                                                                                value: recipeCheckedState[recipe] ?? false,
                                                                                onChanged: (isChecked) {
                                                                                  setState(() {
                                                                                    if (isChecked != null) {
                                                                                      if (!isChecked!) {
                                                                                        removedIndex = selectedRecipes.indexWhere((r) => r.id == recipe.id);
                                                                                        selectedRecipes.removeWhere((r) => r.id == recipe.id);
                                                                                        unSelectedRecipes.add(recipe);
                                                                                      } else {
                                                                                        if (selectedRecipes.length < 7) {
                                                                                          if (removedIndex != -1) {
                                                                                            selectedRecipes.insert(removedIndex, recipe);
                                                                                            removedIndex = -1;
                                                                                          } else {
                                                                                            addRecipe(recipe);
                                                                                          }
                                                                                          unSelectedRecipes.removeWhere((r) => r.id == recipe.id);
                                                                                        } else {
                                                                                          isChecked = false;
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                            SnackBar(
                                                                                              content: Text(
                                                                                                AppLocalizations.of(context).translate('You have reached the maximum number of selected recipes.'),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }
                                                                                      }
                                                                                      recipeCheckedState[recipe] = isChecked!;
                                                                                    }
                                                                                  });
                                                                                },
                                                                              ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              // Right side - Recipe image
                                                              Expanded(
                                                                flex: 5,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              20),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              20),
                                                                    ),
                                                                    child: Image
                                                                        .network(
                                                                      recipe.recipeImage ??
                                                                          Constants
                                                                              .emptyField,
                                                                      fit: BoxFit
                                                                          .cover,
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
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSelectedRecipeList(int index, ThemeProvider themeProvider) {
    if (index < selectedRecipes.length) {
      final recipe = selectedRecipes[index];

      return Padding(
        padding: const EdgeInsets.all(32),
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: themeProvider.currentTheme == ThemeType.dark
                    ? const Color.fromARGB(255, 37, 36, 37)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SizedBox(
                height: 200,
                width: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side - Day and recipe details
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context).translate('Day')} ${index + 1}', // Adjust day text as needed
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    themeProvider.currentTheme == ThemeType.dark
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.7),
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            getWeekdayName(index, recipe),
                            const SizedBox(height: 10),
                            // Recipe details
                            Expanded(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                recipe.recipeTitle ?? Constants.emptyField,
                                style: GoogleFonts.getFont(
                                  recipe.categoryFont ?? Constants.emptyField,
                                  color: HexColor(recipe.categoryColor ??
                                          Constants.emptyField)
                                      .withOpacity(0.7),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Add more recipe details here
                          ],
                        ),
                      ),
                    ),
                    // Right side - Recipe image

                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            recipe.recipeImage ?? Constants.emptyField,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(); // Or any other widget if needed
    }
  }

  Widget getWeekdayName(int index, Recipe recipe) {
    TextStyle textStyle = GoogleFonts.getFont(
        recipe.categoryFont ?? Constants.emptyField,
        color: HexColor(
          recipe.categoryColor ?? Constants.emptyField,
        ).withOpacity(0.7),
        fontSize: Responsive.isDesktop(context)
            ? Constants.desktopHeadingTitleSize
            : Constants.mobileHeadingTitleSize);

    switch (index) {
      case 0:
        return Text(
          AppLocalizations.of(context).translate('Monday'),
          style: textStyle,
        );
      case 1:
        return Text(
          AppLocalizations.of(context).translate('Tuesday'),
          style: textStyle,
        );
      case 2:
        return Text(
          AppLocalizations.of(context).translate('Wednesday'),
          style: textStyle,
        );
      case 3:
        return Text(
          AppLocalizations.of(context).translate('Thursday'),
          style: textStyle,
        );
      case 4:
        return Text(
          AppLocalizations.of(context).translate('Friday'),
          style: textStyle,
        );
      case 5:
        return Text(
          AppLocalizations.of(context).translate('Saturday'),
          style: textStyle,
        );
      case 6:
        return Text(
          AppLocalizations.of(context).translate('Sunday'),
          style: textStyle,
        );
      default:
        return Container();
    }
  }

  void addRecipe(Recipe recipe) {
    setState(() {
      selectedRecipes.add(recipe);
    });
    _scrollToLastAdded(); // Make sure this is called after the state is updated
  }

  void addRecipeByIcon(Recipe recipe) {
  setState(() {
    if (recipeCount.containsKey(recipe)) {
      recipeCount[recipe] = recipeCount[recipe]! + 1;
    } else {
      recipeCount[recipe] = 1;
    }
    selectedRecipes.add(recipe);
    unSelectedRecipes.remove(recipe);
    _scrollToLastAdded(); // Make sure this is called after the state is updated
  });
  print('Added recipe: ${recipe.recipeTitle}, count: ${recipeCount[recipe]}');
}

void removeRecipeByIcon(Recipe recipe) {
  setState(() {
    if (recipeCount.containsKey(recipe) && recipeCount[recipe]! > 1) {
      recipeCount[recipe] = recipeCount[recipe]! - 1;
      // Remove one instance of the recipe from selectedRecipes
      selectedRecipes.removeAt(selectedRecipes.indexOf(recipe));
    } else {
      recipeCount.remove(recipe);
      selectedRecipes.removeWhere((r) => r.id == recipe.id);
    }
    unSelectedRecipes.add(recipe);
  });
  print('Removed recipe: ${recipe.recipeTitle}, count: ${recipeCount[recipe]}');
}

  void _scrollToLastAdded() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollControllerForSelctedRecipes.hasClients &&
          selectedRecipes.isNotEmpty) {
        _scrollControllerForSelctedRecipes.animateTo(
          _scrollControllerForSelctedRecipes.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
