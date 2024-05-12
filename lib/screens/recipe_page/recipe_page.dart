// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/search_settings_provider.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatefulWidget {
  final User? user;
  const RecipePage({super.key, this.user});

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late ScrollController _scrollController;
  List<Recipe> recipes = [];
  List<Recipe> fetchedRecipes = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  late String currentPage;
  String _searchQuery = '';
  bool _noResultsFound = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    currentPage = 'Recipes';
    if (recipes.isEmpty) {
      _fetchRecipes();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading &&
        !_noResultsFound &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      if (fetchedRecipes.isEmpty) {
        _fetchMoreRecipes();
      }
    }
  }

  Future<void> fetchRecipesBySearch(String searchQuery) async {
    if (mounted) {
      setState(() => _isLoading = true);
    }
    try {
      final fetchedRecipes = await RecipeService().getRecipesBySearch(
        searchQuery,
        _pageSize,
        _currentPage,
      );
      if (mounted) {
        setState(() {
          if (_currentPage == 1) recipes.clear();
          recipes.addAll(fetchedRecipes);
          _noResultsFound = fetchedRecipes.isEmpty;
        });
      }
    } catch (e) {
      print('Error fetching recipes: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchRecipes() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      fetchedRecipes = await RecipeService().getAllRecipesByPage(
        _currentPage,
        _pageSize,
      );
      if (mounted) {
        setState(() {
          recipes = fetchedRecipes;
          _isLoading = false;
        });
      }
    } catch (e) {
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
        fetchedRecipes = await RecipeService().getAllRecipesByPage(
          _currentPage + 1, // Fetch next page
          _pageSize,
        );
        if (fetchedRecipes.isEmpty) {
          // No more recipes to fetch, stop loading
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              recipes.addAll(fetchedRecipes);
              _currentPage++; // Increment current page
              _isLoading = false;
            });
          }
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
    final bool isDesktop = Responsive.isDesktop(context);
    final searchSettingsProvider = Provider.of<SearchSettingsProvider>(context);
    bool searchOnEveryKeystroke = searchSettingsProvider.searchOnEveryKeystroke;

    return Scaffold(
      body: Column(
        children: [
          Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: _buildSearchField(searchOnEveryKeystroke, isDesktop)),
          Expanded(
            child: _buildRecipeList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList() {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Center(
        child: SizedBox(
          width: 600,
          child: _isLoading
              ? _buildLoader()
              : _noResultsFound
                  ? _buildNoResultsWidget() // Display no results message
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: recipes.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < recipes.length) {
                          final recipe = recipes[index];
                          return Padding(
                            padding:
                                const EdgeInsets.all(Constants.defaultPadding),
                            child: SizedBox(
                              height: 300,
                              width: 300,
                              child: InkWell(
                                splashColor: Colors
                                    .transparent, // Ensures no splash color is shown
                                highlightColor: Colors
                                    .transparent, // Ensures no highlight color on tap
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeDetailPage(
                                        recipe: recipe,
                                        internalUse: '',
                                        missingIngredients: const [],
                                      ),
                                    ),
                                  ).then((_) {
                                    // Update the state of the recipe list after navigating back

                                    _fetchRecipes();
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  });
                                },
                                child: CustomRecipeCard(
                                    internalUse: 'RecipePage', recipe: recipe),
                              ),
                            ),
                          );
                        } else {
                          return _buildLoader();
                        }
                      },
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

  Widget _buildSearchField(bool searchOnEveryKeystroke, bool isDesktop) {
    return Container(
      constraints: BoxConstraints(maxWidth: isDesktop ? 600 : 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[200],
      ),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search Recipes',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            // If the TextField is empty, reset searchQuery and fetch normal recipes
            if (mounted) {
              setState(() {
                _searchQuery = '';
                _currentPage = 1;
                recipes.clear();
                _fetchRecipes(); // Fetch normal recipes
              });
            }
          } else {
            // If the TextField has a value, perform search based on search behavior
            if (searchOnEveryKeystroke) {
              if (mounted) {
                setState(() {
                  _currentPage = 1;
                  _searchQuery = value;
                  recipes.clear();
                  fetchRecipesBySearch(value);
                });
              }
            }
          }
        },
        onSubmitted: (value) {
          if (!searchOnEveryKeystroke) {
            if (mounted) {
              setState(() {
                _currentPage = 1;
                _searchQuery = value;
                recipes.clear();
                fetchRecipesBySearch(value);
              });
            }
          }
        },
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: const Text(
        'No results found.',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
