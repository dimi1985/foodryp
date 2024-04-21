import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class AddWeeklyMenuPage extends StatefulWidget {
  final WeeklyMenu? meal;
  final bool isForEdit;
  const AddWeeklyMenuPage(
      {Key? key, required this.meal, required this.isForEdit})
      : super(key: key);

  @override
  State<AddWeeklyMenuPage> createState() => _AddWeeklyMenuPageState();
}

class _AddWeeklyMenuPageState extends State<AddWeeklyMenuPage> {
  late User userProfile = User(
      id: '',
      username: '',
      email: '',
      profileImage: '',
      memberSince: null,
      role: '',
      recipes: [],
      following: [],
      followedBy: [],
      likedRecipes: []); // Initialize with default value
  List<Recipe> userRecipes = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool isFetching = false;
  late Map<Recipe, bool> recipeCheckedState = {};
  bool isChecked = false;
  List<Recipe> selectedRecipes = [];
  TextEditingController titleController = TextEditingController();

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
      print('Error fetching more recipes: $e');
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
                              MealService()
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
                      child: const Text('Add Recipe'),
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
                                            onTap: () {},
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
                                                // If the checkbox is unchecked, remove the recipe from selectedRecipes
                                                selectedRecipes.removeWhere(
                                                    (r) => r.id == recipe.id);
                                                log(selectedRecipes.length
                                                    .toString());
                                              } else {
                                                if (selectedRecipes.length <
                                                    7) {
                                                  // Assuming 7 as the maximum limit of selected recipes
                                                  selectedRecipes.add(recipe);
                                                  log(selectedRecipes.length
                                                      .toString());
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
                            getWeekdayName(index),
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
            //Divider maybe n Future updates
            // Positioned(
            //   right: 0,
            //   bottom: 50,
            //   child: Container(
            //     width: 200, // Adjust divider length as needed
            //     height: 1,
            //     color: Colors.black, // Adjust divider color as needed
            //     transform: Matrix4.skewX(-0.25),
            //   ),
            // ),
          ],
        ),
      );
    } else {
      return Container(); // Or any other widget if needed
    }
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
