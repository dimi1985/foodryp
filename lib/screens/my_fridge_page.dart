import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_app_bar.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:foodryp/widgets/CustomWidgets/menuWebItems.dart';
import 'package:foodryp/models/user.dart';

enum Category { vegetables, milkAndDairy, meatAndFish }

class MyFridgePage extends StatefulWidget {
  final User user;
  const MyFridgePage({super.key, required this.user});

  @override
  State<MyFridgePage> createState() => _MyFridgePageState();
}

class _MyFridgePageState extends State<MyFridgePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late String currentPage;
  bool doorsOpened = false;
  final List<String> vegetablesList = [];
  final List<String> milkAndDairyList = [];
  final List<String> meatAndFishList = [];
  List<String> generalListItems = [];
  List<dynamic>? fridgeItems;
  List<Recipe> filteredRecipes = [];
  late ScrollController _scrollController;
  List<Recipe> recipes = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  Map<String, List<String>> recipeMissingIngredients = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    currentPage = 'My Fridge';
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    fetchFridgeItems().then((_) {
      _fetchRecipes();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFridge() {
    setState(() {
      doorsOpened = !doorsOpened;
    });
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  Future fetchFridgeItems() async {
    fridgeItems = await UserService().getFridgeItems();
    if (fridgeItems != null) {
      // Clear existing items
      vegetablesList.clear();
      milkAndDairyList.clear();
      meatAndFishList.clear();

      for (var item in fridgeItems!) {
        switch (item['category']) {
          case 'vegetables':
            vegetablesList.add(item['name']);
            break;
          case 'milkAndDairy':
            milkAndDairyList.add(item['name']);
            break;
          case 'meatAndFish':
            meatAndFishList.add(item['name']);
            break;
        }
      }
      setState(() {});
    }
    return;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreRecipes();
    }
  }

// Function to normalize text by removing non-alphanumeric characters and converting to lowercase
  // Function to normalize text by removing non-alphanumeric characters and converting to lowercase
  String normalizeString(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-zα-ωάέήίόύώ0-9 ]'),
        ''); // Includes space and Greek characters
  }

// Function to check if any fridge item matches any recipe ingredient
  bool ingredientMatches(
      String recipeIngredient, List<String> fridgeItemsNormalized) {
    // List of common words and quantities to ignore for more meaningful matches
    List<String> ignoreWords = [
      'of',
      'the',
      'with',
      'a',
      'an',
      'some',
      'in',
      'for',
      'on',
      'at',
      'to',
      'from',
      'by',
      'as',
      'της',
      'σου',
      'κρεας',
      'κρέας',
      'κον',
      'κασσε',
      'g',
      'kg',
      'ml',
      'l',
      'cup',
      'cups',
      'tbsp',
      'tsp'
    ];

    // Normalize and split the ingredient into words, filtering out ignored words
    List<String> wordsInIngredient = normalizeString(recipeIngredient)
        .split(' ')
        .where((word) =>
            !ignoreWords.contains(word) &&
            word.length > 2) // Ignore common or short words
        .toList();

    // Check if any significant word in the ingredient matches any fridge item
    return wordsInIngredient.any(
        (word) => fridgeItemsNormalized.any((item) => item.contains(word)));
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var fetchedRecipes = await RecipeService().getAllRecipesByPage(
        _currentPage,
        _pageSize,
      );

      // List<dynamic> filteredRecipes = [];  // This will now include all recipes

      if (fridgeItems != null) {
        List<String> fridgeItemsNormalized =
            fridgeItems!.map((item) => normalizeString(item['name'])).toList();

        for (var recipe in fetchedRecipes) {
          bool hasMatchingIngredient = false;
          List<String> missingIngredients = [];

          for (var ingredient in recipe.ingredients) {
            if (ingredientMatches(ingredient, fridgeItemsNormalized)) {
              hasMatchingIngredient = true; // At least one ingredient matches
            } else {
              missingIngredients.add(ingredient); // Collect missing ingredients
            }
          }

          if (hasMatchingIngredient) {
            filteredRecipes.add(
                recipe); // Add the recipe if at least one ingredient matches
          }

          if (missingIngredients.isNotEmpty) {
            recipeMissingIngredients[recipe.id!] = missingIngredients;
          }
        }

        // Optionally print missing ingredients for each recipe
                recipeMissingIngredients.forEach((id, missing) {
                  print(
                      'Recipe ID $id is missing these ingredients: ${missing.join(', ')}');
                });
      }

      setState(() {
        recipes = filteredRecipes;

        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreRecipes() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      try {
        final fetchedRecipes = await RecipeService().getAllRecipesByPage(
          _currentPage + 1, // Fetch next page
          _pageSize,
        );
        setState(() {
          recipes.addAll(fetchedRecipes);
          _currentPage++; // Increment current page
          _isLoading = false;
        });
      } catch (e) {
        print('Error fetching more recipes: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    Map<Category, String> categoryNames = {
      Category.vegetables: AppLocalizations.of(context).translate('Vegetables'),
      Category.milkAndDairy:
          AppLocalizations.of(context).translate('Milk and Dairy'),
      Category.meatAndFish:
          AppLocalizations.of(context).translate('Meat and Fish'),
    };

    return Scaffold(
      appBar: kIsWeb
          ? CustomAppBar(
              isDesktop: true,
              isAuthenticated: true,
              profileImage: widget.user.profileImage,
              username: widget.user.username,
              onTapProfile: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(user: widget.user),
                  ),
                );
              },
              user: widget.user,
              menuItems: isDesktop
                  ? MenuWebItems(user: widget.user, currentPage: currentPage)
                  : Container(),
            )
          : AppBar(),
      endDrawer: !isDesktop
          ? MenuWebItems(user: widget.user, currentPage: currentPage)
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 800,
                  child: isDesktop
                      ? Row(
                          children: [
                            Expanded(
                                child: _buildColumn(
                                    Category.vegetables,
                                    categoryNames[Category.vegetables]!,
                                    isDesktop)),
                            Expanded(
                                child: _buildColumn(
                                    Category.milkAndDairy,
                                    categoryNames[Category.milkAndDairy]!,
                                    isDesktop)),
                            Expanded(
                                child: _buildColumn(
                                    Category.meatAndFish,
                                    categoryNames[Category.meatAndFish]!,
                                    isDesktop)),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: _buildColumn(
                                  Category.vegetables,
                                  categoryNames[Category.vegetables]!,
                                  isDesktop),
                            ),
                            Expanded(
                              child: _buildColumn(
                                  Category.milkAndDairy,
                                  categoryNames[Category.milkAndDairy]!,
                                  isDesktop),
                            ),
                            Expanded(
                              child: _buildColumn(
                                  Category.meatAndFish,
                                  categoryNames[Category.meatAndFish]!,
                                  isDesktop),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        -MediaQuery.of(context).size.width * _animation.value,
                        0,
                      ),
                      child: _buildFridgeVisualization(),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        MediaQuery.of(context).size.width * _animation.value,
                        0,
                      ),
                      child: _buildFridgeVisualization(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            doorsOpened ? _buildRecipeList() : Container(),
            const SizedBox(height: 20),
            doorsOpened
                ? ElevatedButton(
                    onPressed: _toggleFridge,
                    child: Text(AppLocalizations.of(context).translate(
                        doorsOpened ? 'Close Fridge' : 'Open Fridge')),
                  )
                : Container(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(Category category, String categoryName, bool isDesktop) {
    generalListItems = getCategoryItems(category);
    return SizedBox(
      height: isDesktop ? 500 : 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                categoryName,
                style: const TextStyle(fontSize: 24),
              ),
              IconButton(
                onPressed: () {
                  showEditFridgeItemDialog(
                      category: category,
                      context: context,
                      existingItem: categoryName,
                      isForEdit: false);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildCategoryList(generalListItems, category)),
        ],
      ),
    );
  }

  List<String> getCategoryItems(Category category) {
    switch (category) {
      case Category.vegetables:
        return vegetablesList;
      case Category.milkAndDairy:
        return milkAndDairyList;
      case Category.meatAndFish:
        return meatAndFishList;
    }
  }

  Widget _buildCategoryList(List<String> items, Category category) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            showEditFridgeItemDialog(
                context: context,
                category: category,
                isForEdit: true,
                existingItem: item);
          },
          child: Card(
            child: ListTile(
              title: Center(
                // Wrap with Center widget
                child: Text(
                  items[index],
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void addItemToList(Category category, String item) {
    switch (category) {
      case Category.vegetables:
        vegetablesList.add(item);
        break;
      case Category.milkAndDairy:
        milkAndDairyList.add(item);
        break;
      case Category.meatAndFish:
        meatAndFishList.add(item);
        break;
    }
  }

  void updateListUI() {
    setState(() {});
  }

  Widget _buildFridgeVisualization() {
    return Container(
      height: 800,
      width: MediaQuery.of(context).size.width,
      color: const Color.fromARGB(255, 32, 32, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate('Fridge'),
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _toggleFridge,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: Text(
              AppLocalizations.of(context)
                  .translate(doorsOpened ? 'Close Fridge' : 'Open Fridge'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddFridgeItem(Category category, String name) async {
    bool success =
        await UserService().addFridgeItem(getCategoryName(category), name);

    if (success) {
      // Update your UI accordingly
      print('Fridge item added successfully.');
    } else {
      // Show an error message
      print('Failed to add fridge item.');
    }
  }

  String getCategoryName(Category category) {
    return category.toString().split('.').last;
  }

  Widget _buildRecipeList() {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Center(
        child: SizedBox(
          height: 300,
          width: 1200,
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
              itemCount: recipes.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < recipes.length) {
                  final recipe = recipes[index];
                  final missingIngredients =
                      recipeMissingIngredients[recipe.id] ??
                          []; // Get missing ingredients if available
                  return Padding(
                      padding: const EdgeInsets.all(Constants.defaultPadding),
                      child: SizedBox(
                        height: 400,
                        width: 400,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailPage(recipe: recipe, internalUse: 'RecipePage',  missingIngredients: missingIngredients,),
                              ),
                            );
                          },
                          child: CustomRecipeCard(
                            internalUse: 'RecipePage',
                            recipe: recipe,
                            missingIngredients: missingIngredients,
                          ),
                        ),
                      ));
                } else {
                  return _buildLoader();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void showEditFridgeItemDialog({
    required BuildContext context,
    required Category category,
    String existingItem = "",
    bool isForEdit = false,
  }) {
    TextEditingController controller =
        TextEditingController(text: existingItem);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate(getCategoryName(category)),
                    style: const TextStyle(fontSize: 24),
                  ),
                  CustomTextField(
                    controller: controller,
                    hintText: AppLocalizations.of(context)
                        .translate('Add your fridge item'),
                    labelText: AppLocalizations.of(context)
                        .translate('Add your fridge item'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (isForEdit) {
                        updateFridgeItem(context, category, existingItem,
                            controller.text.trim());
                      } else {
                        addItemToList(category, controller.text.trim());
                        _onAddFridgeItem(category, controller.text.trim());
                      }
                      updateListUI();
                      _fetchRecipes();

                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)
                        .translate(isForEdit ? 'Update' : 'Add')),
                  ),
                  if (isForEdit) ...[
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        deleteFridgeItem(existingItem, category);

                        Navigator.pop(context);
                      },
                      child: Text(
                          AppLocalizations.of(context).translate('Delete')),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void updateFridgeItem(
    BuildContext context,Category category, String oldItem, String newItem) {
  // Update the item in the local list
  List<String> itemList = getCategoryItems(category);
  int index = itemList.indexOf(oldItem);
  if (index != -1) {
    itemList[index] = newItem;
    updateListUI();
  }

  // Get category name as string
  String categoryStr = categoryToString(category);

  // Call the server update method
  UserService().updateFridgeItem( oldItem, newItem, categoryStr).then((success) {
    if (success) {
      print('Fridge item updated successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fridge item updated successfully!'))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update fridge item.'))
      );
    }
  });
}


  void deleteFridgeItem(String item, Category category) {
    // Logic to remove an item from the fridge list based on category
    UserService().deleteFridgeItem(item).then((value) {
      if (value) {
        print('Fridge item deleted successfully.');
        // Remove item from the correct list based on category
        switch (category) {
          case Category.vegetables:
            vegetablesList.remove(item);
            break;
          case Category.milkAndDairy:
            milkAndDairyList.remove(item);
            break;
          case Category.meatAndFish:
            meatAndFishList.remove(item);
            break;
        }
        updateListUI();
      } else {
        print('Error deleting fridge item');
      }
    }).catchError((error) {
      print('Error deleting fridge item: $error');
    });
  }
  
  String categoryToString(Category category) {
  return category.toString().split('.').last;
}
}
