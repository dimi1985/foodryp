import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/widgets/animated_arrow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum Category { vegetables, generalItems, meatAndFish }

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
  final List<String> generalItemsList = [];
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
    if (mounted) {
      setState(() {
        doorsOpened = !doorsOpened;
      });
    }
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
      generalItemsList.clear();
      meatAndFishList.clear();

      for (var item in fridgeItems!) {
        switch (item['category']) {
          case 'vegetables':
            vegetablesList.add(item['name']);

            break;
          case 'generalItems':
            generalItemsList.add(item['name']);

            break;
          case 'meatAndFish':
            meatAndFishList.add(item['name']);

            break;
        }
      }
      if (mounted) {
        setState(() {});
      }
    }
    return;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreRecipes();
    }
  }

  String removeGreekDiacritics(String input) {
  const Map<String, String> diacriticMap = {
    'Ά': 'Α',
    'Έ': 'Ε',
    'Ή': 'Η',
    'Ί': 'Ι',
    'Ό': 'Ο',
    'Ύ': 'Υ',
    'Ώ': 'Ω',
    'ά': 'α',
    'έ': 'ε',
    'ή': 'η',
    'ί': 'ι',
    'ό': 'ο',
    'ύ': 'υ',
    'ώ': 'ω',
    'ϊ': 'ι',
    'ϋ': 'υ',
    'ΐ': 'ι',
    'ΰ': 'υ',
  };

  final buffer = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    final char = input[i];
    buffer.write(diacriticMap[char] ?? char);
  }
  return buffer.toString();
}

String normalizeString(String input) {
  return removeGreekDiacritics(input.toLowerCase().replaceAll(
    RegExp(r'[^a-zα-ωάέήίόύώ0-9 ]'),
    '',
  ));
}

String toSingular(String word) {
  if (word.endsWith('ες')) {
    return '${word.substring(0, word.length - 2)}α';
  }
  if (word.endsWith('οι')) {
    return '${word.substring(0, word.length - 2)}ος';
  }
  return word;
}

bool ingredientMatches(
    String recipeIngredient, List<String> fridgeItemsNormalized) {
  List<String> ignoreWords = [
    'of', 'the', 'with', 'a', 'an', 'some', 'in', 'for', 'on', 'at', 'to', 'from', 'by', 'as',
    'της', 'σου', 'κρεας', 'κρέας', 'κον', 'κασσε', 'g', 'kg', 'ml', 'l', 'cup', 'cups', 'tbsp', 'tsp',
  ];

  List<String> wordsInIngredient = normalizeString(recipeIngredient)
      .split(' ')
      .where((word) => !ignoreWords.contains(word) && word.length > 2)
      .toList();

  String normalizedRecipeIngredient = normalizeString(recipeIngredient);
  if (fridgeItemsNormalized.contains(normalizedRecipeIngredient)) {
    return true;
  }

  List<List<String>> fridgeItemWordsList = fridgeItemsNormalized.map((item) {
    return normalizeString(item).split(' ');
  }).toList();

  return fridgeItemWordsList.any((fridgeItemWords) {
    if (fridgeItemWords.length > 1) {
      bool allWordsMatch = fridgeItemWords.every((fridgeWord) =>
          wordsInIngredient.contains(fridgeWord) ||
          wordsInIngredient.any((word) =>
              word.contains(fridgeWord) || fridgeWord.contains(word)));
      if (allWordsMatch) {
        return true;
      }
    } else {
      return fridgeItemWords.any((fridgeWord) {
        if (wordsInIngredient.contains(fridgeWord)) {
          return true;
        }
        return false;
      });
    }
    return false;
  });
}

Future<void> _fetchRecipes() async {
  if (mounted) {
    setState(() {
      _isLoading = true;
    });
  }
  try {
    var fetchedRecipes = await RecipeService().getAllRecipesByPage(
      _currentPage,
      _pageSize,
    );

    filteredRecipes.clear();

    if (fridgeItems != null) {
      List<String> fridgeItemsNormalized =
          fridgeItems!.map((item) => normalizeString(item['name'])).toList();

      for (var recipe in fetchedRecipes) {
        bool hasMatchingIngredient = false;
        List<String> missingIngredients = [];
        List<String> matchedIngredients = [];

        for (var ingredient in recipe.ingredients ?? []) {
          if (ingredientMatches(ingredient, fridgeItemsNormalized)) {
            hasMatchingIngredient = true;
            matchedIngredients.add(ingredient);
          } else {
            missingIngredients.add(ingredient);
          }
        }

        // If no exact match found, try partial match
        if (!hasMatchingIngredient) {
          for (var ingredient in recipe.ingredients ?? []) {
            if (fridgeItemsNormalized.any((fridgeItem) =>
                normalizeString(fridgeItem).contains(normalizeString(ingredient)) ||
                normalizeString(ingredient).contains(normalizeString(fridgeItem)))) {
              hasMatchingIngredient = true;
              matchedIngredients.add(ingredient);
              missingIngredients.remove(ingredient);
            }
          }
        }

        if (hasMatchingIngredient) {
          filteredRecipes.add(recipe);
        }

        recipeMissingIngredients[recipe.id!] = missingIngredients;
      }

      if (mounted) {
        setState(() {
          recipes = filteredRecipes;
          _isLoading = false;
        });
      }
    }
  } catch (e) {
    print('Error fetching recipes: $e');
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  Future<void> _fetchMoreRecipes() async {
    if (!_isLoading) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      try {
        final fetchedRecipes = await RecipeService().getAllRecipesByPage(
          _currentPage + 1, // Fetch next page
          _pageSize,
        );
        if (mounted) {
          setState(() {
            recipes.addAll(fetchedRecipes);
            _currentPage++; // Increment current page
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching more recipes: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    Map<Category, String> categoryNames = {
      Category.vegetables: AppLocalizations.of(context).translate('Vegetables'),
      Category.generalItems:
          AppLocalizations.of(context).translate('General Items'),
      Category.meatAndFish:
          AppLocalizations.of(context).translate('Meat and Fish'),
    };

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          if (!isDesktop) const SizedBox(height: 25),
          if (!isDesktop && doorsOpened)
            Text(
              AppLocalizations.of(context)
                  .translate('What do you have in your Fridge?'),
              style: const TextStyle(fontSize: 18),
            ),
          const SizedBox(height: 25),
          Stack(
            children: [
              if (isDesktop && doorsOpened)
                Positioned(
                  top: 50,
                  left: 100,
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('What do you have in your Fridge?'),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              SizedBox(
                height: 800,
                child: isDesktop
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildColumn(
                              Category.vegetables,
                              categoryNames[Category.vegetables]!,
                              isDesktop,
                            ),
                          ),
                          Expanded(
                            child: _buildColumn(
                              Category.generalItems,
                              categoryNames[Category.generalItems]!,
                              isDesktop,
                            ),
                          ),
                          Expanded(
                            child: _buildColumn(
                              Category.meatAndFish,
                              categoryNames[Category.meatAndFish]!,
                              isDesktop,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: _buildColumn(
                              Category.vegetables,
                              categoryNames[Category.vegetables]!,
                              isDesktop,
                            ),
                          ),
                          Expanded(
                            child: _buildColumn(
                              Category.generalItems,
                              categoryNames[Category.generalItems]!,
                              isDesktop,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildColumn(
                              Category.meatAndFish,
                              categoryNames[Category.meatAndFish]!,
                              isDesktop,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              if ((!isDesktop || Constants.checiIfAndroid(context)) &&
                  filteredRecipes.isNotEmpty &&
                  doorsOpened)
                Positioned(
                  bottom: 50,
                  left: MediaQuery.of(context).size.width / 2 -
                      15, // Center the arrow
                  child: AnimatedArrow(),
                ),
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
          if (isDesktop && filteredRecipes.isNotEmpty && doorsOpened)
            AnimatedArrow(),
          const SizedBox(height: 20),
          doorsOpened ? _buildRecipeList() : Container(),
          const SizedBox(height: 20),
          doorsOpened
              ? ElevatedButton(
                  onPressed: _toggleFridge,
                  child: Text(AppLocalizations.of(context)
                      .translate(doorsOpened ? 'Close Fridge' : 'Open Fridge')),
                )
              : Container(),
          const SizedBox(height: 20),
        ],
      )),
    );
  }

  Widget _buildColumn(Category category, String categoryName, bool isDesktop) {
    generalListItems = getCategoryItems(category);
    return SizedBox(
      height: isDesktop ? 500 : 300,
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
                icon: Icon(MdiIcons.plusCircle),
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
      case Category.generalItems:
        return generalItemsList;
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
      case Category.generalItems:
        generalItemsList.add(item);
        break;
      case Category.meatAndFish:
        meatAndFishList.add(item);
        break;
    }
  }

  void updateListUI() {
    if (mounted) {
      setState(() {});
    }
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
      await fetchFridgeItems();
      await _fetchRecipes();
      updateListUI();
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
          width: double.infinity,
          child: Stack(
            children: [
              ScrollConfiguration(
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
                          recipeMissingIngredients[recipe.id] ?? [];

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
                                  builder: (context) => RecipeDetailPage(
                                    recipe: recipe,
                                    internalUse: 'RecipePage',
                                    missingIngredients: missingIngredients,
                                  ),
                                ),
                              );
                            },
                            child: CustomRecipeCard(
                              internalUse: 'RecipePage',
                              recipe: recipe,
                              missingIngredients: missingIngredients,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return _buildLoader();
                    }
                  },
                ),
              ),
              if (recipes.length > 1)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(MdiIcons.arrowLeft),
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.position.pixels - 400,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              if (recipes.length > 1)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(MdiIcons.arrowRight),
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.position.pixels + 400,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
            ],
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
        TextEditingController(text:isForEdit ? existingItem :null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
            final bottomPadding = MediaQuery.of(context).padding.bottom;

            return SingleChildScrollView(
              reverse: true,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: keyboardPadding +
                      bottomPadding +
                      16.0, // Adjust padding based on keyboard height
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('Fridge Items'),
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate('Add your fridge items here'),
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.0),
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blueGrey
                                  .withOpacity(0.5), // Set border color here
                              width: 1, // Set border width here
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible:
                                false, // Prevent dismissing the dialog by tapping outside
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                content: Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 16),
                                    Text("Processing..."),
                                  ],
                                ),
                              );
                            },
                          );

                          Future.delayed(
                              Duration(seconds: Random().nextInt(3) + 1), () {
                            if (isForEdit) {
                              updateFridgeItem(context, category, existingItem,
                                  controller.text.trim());
                            } else {
                              addItemToList(category, controller.text.trim());
                              _onAddFridgeItem(
                                  category, controller.text.trim());
                            }
                            Navigator.pop(
                                context); // Dismiss the dialog after operation is initiated
                            Navigator.pop(context);
                          });
                        },
                        child: Text(AppLocalizations.of(context)
                            .translate(isForEdit ? 'Update' : 'Add')),
                      ),
                      if (isForEdit) ...[
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 16),
                                      Text("Processing..."),
                                    ],
                                  ),
                                );
                              },
                            );

                            Future.delayed(
                                Duration(seconds: Random().nextInt(3) + 1), () {
                              deleteFridgeItem(existingItem, category);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                              AppLocalizations.of(context).translate('Delete')),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    ;
  }

  void updateFridgeItem(
      BuildContext context, Category category, String oldItem, String newItem) {
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
    UserService()
        .updateFridgeItem(oldItem, newItem, categoryStr)
        .then((success) async {
      if (success) {
        await fetchFridgeItems();
        await _fetchRecipes();
        updateListUI();
        print('Fridge item updated successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fridge item updated successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update fridge item.')));
      }
    });
  }

  void deleteFridgeItem(String item, Category category) async {
    // Remove item from the correct list based on category
    switch (category) {
      case Category.vegetables:
        vegetablesList.remove(item);
        break;
      case Category.generalItems:
        generalItemsList.remove(item);
        break;
      case Category.meatAndFish:
        meatAndFishList.remove(item);
        break;
    }

    // Update the UI immediately
    updateListUI();

    // Call the server to delete the fridge item
    bool success = await UserService().deleteFridgeItem(item);

    if (success) {
      await fetchFridgeItems();
      await _fetchRecipes();
      updateListUI();
      print('Fridge item deleted successfully.');
    } else {
      print('Error deleting fridge item');
    }
  }

  String categoryToString(Category category) {
    return category.toString().split('.').last;
  }
}
