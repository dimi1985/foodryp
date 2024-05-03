import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class AddWeeklyMenuPage extends StatefulWidget {
  final WeeklyMenu? meal;
  final bool isForEdit;
  const AddWeeklyMenuPage(
      {super.key, required this.meal, required this.isForEdit});

  @override
  State<AddWeeklyMenuPage> createState() => _AddWeeklyMenuPageState();
}

class _AddWeeklyMenuPageState extends State<AddWeeklyMenuPage> {
  late User userProfile =
      Constants.defaultUser; // Initialize with default value
  List<Recipe> userRecipes = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool isFetching = false;
  late Map<Recipe, bool> recipeCheckedState = {};
  bool isChecked = false;
  List<Recipe> selectedRecipes = [];
  List<Recipe> unSelectedRecipes = [];
  TextEditingController titleController = TextEditingController();
  int removedIndex = -1;

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
    _scrollController.dispose();
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

      for (var recipe in userRecipes) {
        if (recipe.meal.contains(widget.meal?.id)) {
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

      setState(() {
        userRecipes.addAll(filteredRecipes);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Weekly Menu'),
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
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return _buildSelectedRecipeList(index);
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
                      'Hi ${userProfile.username} Here you can check and put the meals of the day',
                    ),
                    CustomTextField(
                        controller: titleController,
                        hintText: 'Enter Title',
                        labelText: 'Title'),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() {
                                isLoading = true;
                              });
                              widget.isForEdit
                                  ? MealService()
                                      .updateWeeklyMenu(
                                          widget.meal!.id,
                                          titleController.text,
                                          unSelectedRecipes,
                                          selectedRecipes,
                                          userProfile.username,
                                          userProfile.profileImage)
                                      .then((value) {
                                      if (value) {
                                        print('Meal Updated');
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    })
                                  : MealService()
                                      .saveWeeklyMenu(
                                          titleController.text,
                                          selectedRecipes,
                                          userProfile.username,
                                          userProfile.profileImage)
                                      .then((value) {
                                      if (value) {
                                        print('Meal Saved');
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    });
                            },
                      child:
                          Text(widget.isForEdit ? 'Update Menu' : 'Add Menu'),
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
                                    Opacity(
                                      opacity:
                                          recipeCheckedState[recipe] ?? false
                                              ? 0.5
                                              : 1.0,
                                      child: ColorFiltered(
                                        colorFilter:
                                            recipeCheckedState[recipe] ?? false
                                                ? const ColorFilter.mode(
                                                    Colors.grey,
                                                    BlendMode.saturation,
                                                  )
                                                : const ColorFilter.mode(
                                                    Colors.transparent,
                                                    BlendMode.saturation,
                                                  ),
                                        child: SizedBox(
                                          height: 300,
                                          width: 300,
                                          child: CustomRecipeCard(
                                            internalUse: '',
                                            recipe: recipe,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Checkbox(
                                        value:
                                            recipeCheckedState[recipe] ?? false,
                                        onChanged: (isChecked) {
                                          setState(() {
                                            if (isChecked != null) {
                                              if (!isChecked!) {
                                                removedIndex = selectedRecipes
                                                    .indexWhere((r) =>
                                                        r.id == recipe.id);

                                                selectedRecipes.removeWhere(
                                                    (r) => r.id == recipe.id);
                                                unSelectedRecipes.add(recipe);
                                              } else {
                                                if (selectedRecipes.length <
                                                    7) {
                                                  // Check if there was a previously removed item
                                                  if (removedIndex != -1) {
                                                    // Insert the new recipe at the previously removed index
                                                    selectedRecipes.insert(
                                                        removedIndex, recipe);

                                                    // Reset removedIndex to indicate that it has been used
                                                    removedIndex = -1;
                                                  } else {
                                                    // If no item was previously removed, just add the recipe to the end
                                                    selectedRecipes.add(recipe);
                                                  }

                                                  unSelectedRecipes.removeWhere(
                                                      (r) => r.id == recipe.id);
                                                } else {
                                                  // If the maximum limit of selected recipes is reached, keep the checkbox unchecked
                                                  isChecked = false;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'You have reached the maximum number of selected recipes.',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                              // Update the checkbox state
                                              recipeCheckedState[recipe] =
                                                  isChecked!;
                                            }
                                          });
                                        },
                                      ),
                                    ),
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

  Widget _buildSelectedRecipeList(int index) {
    if (index < selectedRecipes.length) {
      final recipe = selectedRecipes[index];
      final recipeImage =
          '${Constants.imageURL}/${recipe.recipeImage}'.replaceAll('\r', '/');
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
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
                              'Day ${index + 1}', // Adjust day text as needed
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            getWeekdayName(index, recipe),
                            const SizedBox(height: 10),
                            // Recipe details
                            Text(
                              recipe.recipeTitle,
                              style: GoogleFonts.getFont(
                                recipe.categoryFont,
                                color: HexColor(recipe.categoryColor)
                                    .withOpacity(0.7),
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
                            recipeImage,
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
    TextStyle textStyle = GoogleFonts.getFont(recipe.categoryFont,
        color: HexColor(
          recipe.categoryColor,
        ).withOpacity(0.7),
        fontSize: Responsive.isDesktop(context)
            ? Constants.desktopHeadingTitleSize
            : Constants.mobileHeadingTitleSize);

    switch (index) {
      case 0:
        return Text(
          'Monday',
          style: textStyle,
        );
      case 1:
        return Text(
          'Tuesday',
          style: textStyle,
        );
      case 2:
        return Text(
          'Wednesday',
          style: textStyle,
        );
      case 3:
        return Text(
          'Thursday',
          style: textStyle,
        );
      case 4:
        return Text(
          'Friday',
          style: textStyle,
        );
      case 5:
        return Text(
          'Saturday',
          style: textStyle,
        );
      case 6:
        return Text(
          'Sunday',
          style: textStyle,
        );
      default:
        return Container();
    }
  }
}
