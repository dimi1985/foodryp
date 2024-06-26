import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/bottom_nav_screen.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AddWeeklyMenuPage extends StatefulWidget {
  final WeeklyMenu? meal;
  final bool isForEdit;
  final bool isForDiet;
  const AddWeeklyMenuPage({
    super.key,
    required this.meal,
    required this.isForEdit,
    required this.isForDiet,
  });

  @override
  State<AddWeeklyMenuPage> createState() => _AddWeeklyMenuPageState();
}

class _AddWeeklyMenuPageState extends State<AddWeeklyMenuPage> {
  late User userProfile = Constants.defaultUser;
  List<Recipe> userRecipes = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _selectedScrollController = ScrollController();
  bool isFetching = false;
  List<Recipe> selectedRecipes = [];
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserProfileAndRecipes();
    if (widget.isForEdit) {
      initializeEditState();
    }
    _scrollController.addListener(_scrollListener);
    _selectedScrollController.addListener(selectedSListener);
  }

  void initializeEditState() {
    titleController.text = widget.meal!.title;
    for (var day in widget.meal!.dayOfWeek) {
      final recipe = day;
      selectedRecipes.add(recipe);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !isFetching) {
      fetchMoreRecipes();
    }
  }

  void selectedSListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !isFetching) {}
  }

  Future<void> fetchUserProfileAndRecipes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userService = UserService();
      final recipeService = RecipeService();

      userProfile = (await userService.getUserProfile())!;
      userRecipes = await recipeService.getUserRecipesByPage(1, 10);

      if (widget.isForDiet) {
        userRecipes = userRecipes.where((recipe) => recipe.isForDiet).toList();
      } else {
        userRecipes = userRecipes.where((recipe) => !recipe.isForDiet).toList();
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            '${AppLocalizations.of(context).translate('Error fetching user profile and recipes:')} , $e'),
      ));
      log('Error fetching user profile and recipes: $e');
    }
  }

  Future<void> fetchMoreRecipes() async {
    setState(() {
      isFetching = true;
    });
    try {
      final recipeService = RecipeService();
      final moreRecipes = await recipeService.getUserRecipesByPage(
        (userRecipes.length ~/ 10) + 1,
        10,
      );

      final Set<String?> recipeIds =
          userRecipes.map((recipe) => recipe.id).toSet();
      final filteredRecipes = moreRecipes
          .where((recipe) => !recipeIds.contains(recipe.id))
          .toList();

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
                _buildSelectedRecipes(themeProvider),
                _buildUserInfo(),
                _buildTitleInput(),
                _buildAddUpdateButton(),
                _buildUserRecipesList(themeProvider),
              ],
            ),
    );
  }

  Widget _buildSelectedRecipes(ThemeProvider themeProvider) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DragTarget<Recipe>(
        onWillAcceptWithDetails: (details) => selectedRecipes.length < 7,
        onAcceptWithDetails: (details) {
          setState(() {
            if (selectedRecipes.length < 7) {
              selectedRecipes.add(details.data);
              _scrollToEnd();
            }
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            height: Constants.checiIfAndroid(context) ? 300 : 300,
            color: Colors.grey.shade200,
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: ReorderableListView(
                    scrollController: _selectedScrollController,
                    scrollDirection: Axis.horizontal,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = selectedRecipes.removeAt(oldIndex);
                        selectedRecipes.insert(newIndex, item);
                      });
                    },
                    children: [
                      for (int index = 0;
                          index < selectedRecipes.length;
                          index++)
                        _buildSelectedRecipeCard(index, themeProvider),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      MdiIcons.arrowLeftBoldBox,
                      size: 30,
                    ),
                    onPressed: () {
                      _selectedScrollController.animateTo(
                        _selectedScrollController.offset - 300,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      MdiIcons.arrowRightBoldBox,
                      size: 30,
                    ),
                    onPressed: () {
                      _selectedScrollController.animateTo(
                        _selectedScrollController.offset + 300,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _scrollToEnd() {
    _selectedScrollController.animateTo(
      _selectedScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildSelectedRecipeCard(int index, ThemeProvider themeProvider) {
    final recipe = selectedRecipes[index];
    return Draggable<Recipe>(
  key: ValueKey('selected_$index'), // Ensure unique keys
  data: recipe,
  feedback: Material(
    elevation: 6.0,
    child: _buildRecipeCard(recipe, themeProvider),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  childWhenDragging: SizedBox.shrink(),
  onDragEnd: (details) {
    if (!details.wasAccepted) {
      setState(() {
        selectedRecipes.removeAt(index);
      });
    }
  },
  child: Padding(
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDayOfWeek(index),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeProvider.currentTheme == ThemeType.dark
                              ? Colors.white
                              : Colors.black.withOpacity(0.7),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          recipe.recipeTitle ?? Constants.emptyField,
                          style: GoogleFonts.getFont(
                            recipe.categoryFont ?? Constants.emptyField,
                            color: HexColor(
                              recipe.categoryColor ?? Constants.emptyField,
                            ).withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
      ],
    ),
  ),
);
  }

  String _getDayOfWeek(int index) {
    List daysOfWeek = [
      AppLocalizations.of(context).translate('Monday'),
      AppLocalizations.of(context).translate('Tuesday'),
      AppLocalizations.of(context).translate('Wednesday'),
      AppLocalizations.of(context).translate('Thursday'),
      AppLocalizations.of(context).translate('Friday'),
      AppLocalizations.of(context).translate('Saturday'),
      AppLocalizations.of(context).translate('Sunday'),
    ];
    return daysOfWeek[index % 7];
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          '${userProfile.username.toUpperCase()} ${AppLocalizations.of(context).translate('Drag and drop recipes to build your weekly menu, reorder them as needed, and use the arrows to scroll through your selections; you can add up to 7 recipes.')}',
        ),
      ],
    );
  }

  Widget _buildTitleInput() {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: CustomTextField(
        controller: titleController,
        hintText: AppLocalizations.of(context).translate('Enter Title'),
        labelText: AppLocalizations.of(context).translate('Title'),
      ),
    );
  }

  Widget _buildAddUpdateButton() {
    return TextButton(
      onPressed: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 16),
                  Text(AppLocalizations.of(context).translate('Processing...')),
                ],
              ),
            );
          },
        );

        final mealService = MealService();
        final success = widget.isForEdit
            ? await mealService.updateWeeklyMenu(
                widget.meal!.id,
                titleController.text,
                [],
                selectedRecipes,
                userProfile.username,
                userProfile.profileImage,
                widget.isForDiet,
                true,
              )
            : await mealService.saveWeeklyMenu(
                titleController.text,
                selectedRecipes,
                userProfile.username,
                userProfile.profileImage,
                widget.isForDiet,
                true,
              );

        Navigator.pop(context); // Close the alert dialog

        if (success) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => kIsWeb
                  ? const EntryWebNavigationPage()
                  : const BottomNavScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        }

        setState(() {
          isLoading = false;
        });
      },
      child: Text(AppLocalizations.of(context)
          .translate(widget.isForEdit ? 'Update Menu' : 'Add Menu')),
    );
  }

  Widget _buildUserRecipesList(ThemeProvider themeProvider) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset - 200, // Adjust the scroll amount as needed
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: userRecipes.length + (isFetching ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < userRecipes.length) {
                    final recipe = userRecipes[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LongPressDraggable<Recipe>(
                        data: recipe,
                        feedback: Material(
                          elevation: 6.0,
                          child: _buildRecipeCard(recipe, themeProvider),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: _buildRecipeCard(recipe, themeProvider),
                        ),
                        onDragCompleted: () {
                          setState(() {
                            // Allow multiple instances of a recipe, so don't remove it from the list.
                          });
                        },
                        child: _buildRecipeCard(recipe, themeProvider),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset + 200, // Adjust the scroll amount as needed
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    ),
  );
}

  Widget _buildRecipeCard(Recipe recipe, ThemeProvider themeProvider,
      {bool isSelected = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        recipe.recipeTitle ?? Constants.emptyField,
                        style: GoogleFonts.getFont(
                          recipe.categoryFont ?? Constants.emptyField,
                          color: HexColor(
                            recipe.categoryColor ?? Constants.emptyField,
                          ).withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
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
    );
  }
}
