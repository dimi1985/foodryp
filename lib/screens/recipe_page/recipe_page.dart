// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/search_settings_provider.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';
import 'package:foodryp/widgets/CustomWidgets/shimmer_loader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatefulWidget {
  final User? user;
  final bool seeAll;
  const RecipePage({super.key, this.user, required this.seeAll});

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  List<Recipe> recipes = [];
  List<Recipe> filteredRecipes = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  late String currentPage;
  String _searchQuery = '';
  bool _noResultsFound = false;
  bool _showFilter = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    currentPage = 'Recipes';
    _fetchRecipes();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedRecipes = await RecipeService().getAllRecipesByPage(
        _currentPage,
        _pageSize,
      );
      setState(() {
        recipes = fetchedRecipes;
        filteredRecipes = fetchedRecipes;
        _isLoading = false;
        _hasMoreData = fetchedRecipes.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreRecipes() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final fetchedRecipes = await RecipeService().getAllRecipesByPage(
        _currentPage + 1, // Fetch next page
        _pageSize,
      );
      setState(() {
        if (fetchedRecipes.isEmpty) {
          _hasMoreData = false;
        } else {
          recipes.addAll(fetchedRecipes);
          filteredRecipes.addAll(fetchedRecipes);
          _currentPage++; // Increment current page
        }
        _isLoadingMore = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching more recipes: $e');
      }
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> fetchRecipesBySearch(String searchQuery) async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
    });
    try {
      final fetchedRecipes = await RecipeService().getRecipesBySearch(
        searchQuery,
        _currentPage,
        _pageSize,
      );
      setState(() {
        recipes = fetchedRecipes;
        filteredRecipes = fetchedRecipes;
        _noResultsFound = fetchedRecipes.isEmpty;
        _isLoading = false;
        _hasMoreData = fetchedRecipes.length == _pageSize;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching recipes: $e');
      }
      setState(() => _isLoading = false);
    }
  }

  void _toggleFilter() {
    setState(() {
      _showFilter = !_showFilter;
      if (!_showFilter) {
        filteredRecipes = recipes;
      }
    });
  }

  void _filterRecipesByDuration(
      String durationType, int minDuration, int maxDuration) {
    List<Recipe> filtered;
    if (durationType == 'Preparation Time') {
      filtered = recipes.where((recipe) {
        if (recipe.prepDuration != null) {
          final prepDurationString = recipe.prepDuration!.split(' ').first;
          final prepDuration = int.tryParse(prepDurationString);
          if (prepDuration != null) {
            final isInRange =
                prepDuration >= minDuration && prepDuration <= maxDuration;
           
            return isInRange;
          }
        }
        return false;
      }).toList();
    } else if (durationType == 'Cooking Time') {
      filtered = recipes.where((recipe) {
        if (recipe.cookDuration != null) {
          final cookDurationString = recipe.cookDuration!.split(' ').first;
          final cookDuration = int.tryParse(cookDurationString);
          if (cookDuration != null) {
            final isInRange =
                cookDuration >= minDuration && cookDuration <= maxDuration;
            
            return isInRange;
          }
        }
        return false;
      }).toList();
    } else {
      // Handle other types of duration if needed
      filtered = recipes;
    }

    setState(() {
      filteredRecipes = filtered;
      _noResultsFound = filtered.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final searchSettingsProvider = Provider.of<SearchSettingsProvider>(context);
    bool searchOnEveryKeystroke = searchSettingsProvider.searchOnEveryKeystroke;
    final isAndroid = Constants.checiIfAndroid(context);
    return Scaffold(
      appBar: widget.seeAll
          ? AppBar(
              title:
                  Text(AppLocalizations.of(context).translate('All Recipes')),
            )
          : null,
      body: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: EdgeInsets.only(
                top: Constants.checiIfAndroid(context) ? 50 : 0,
                left: Constants.checiIfAndroid(context) ? 30 : 0,
                right: Constants.checiIfAndroid(context) ? 30 : 0,
              ),
              child: _buildSearchField(searchOnEveryKeystroke, isDesktop),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          _buildFilterButton(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showFilter
                ? isAndroid || !isDesktop
                    ? 250.0
                    : 150.0
                : 0.0,
            child: _showFilter
                ? _buildFilterOptions(isAndroid, isDesktop)
                : Container(),
          ),
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
          child: _isLoading && _currentPage == 1
              ? _buildLoader()
              : _noResultsFound
                  ? _buildNoResultsWidget() // Display no results message
                  : ListView.builder(
                      key: const PageStorageKey<String>('recipes'),
                      controller: _scrollController,
                      itemCount: filteredRecipes.length + 1,
                      itemBuilder: (context, index) {
                        if (index < filteredRecipes.length) {
                          final recipe = filteredRecipes[index];
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
                                             user: widget.user,
                                      ),
                                    ),
                                  ).then((_) {
                                    // Update the state of the recipe list after navigating back
                                    if (_searchQuery.isEmpty) {
                                      _fetchRecipes();
                                    } else {
                                      fetchRecipesBySearch(_searchQuery);
                                    }
                                  });
                                },
                                child: CustomRecipeCard(
                                    internalUse: 'RecipePage', recipe: recipe),
                              ),
                            ),
                          );
                        } else {
                          return _hasMoreData
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: _fetchMoreRecipes,
                                    child: _isLoadingMore
                                        ? const CircularProgressIndicator()
                                        : Text(AppLocalizations.of(context)
                                            .translate('Load More')),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(AppLocalizations.of(context)
                                      .translate('No more recipes')),
                                );
                        }
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return const ShimmerLoader(); // Use the shimmer loader here
  }

  Widget _buildSearchField(bool searchOnEveryKeystroke, bool isDesktop) {
    return Container(
      constraints: BoxConstraints(maxWidth: isDesktop ? 600 : 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[200],
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('Search Recipes'),
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            // If the TextField is empty, reset searchQuery and fetch normal recipes
            setState(() {
              _searchQuery = '';
              _currentPage = 1;
              recipes.clear();
              filteredRecipes.clear();
              _isLoading = false;
              _fetchRecipes(); // Fetch normal recipes
            });
          } else {
            // If the TextField has a value, perform search based on search behavior
            if (searchOnEveryKeystroke) {
              setState(() {
                _searchQuery = value;
                recipes.clear();
                filteredRecipes.clear();
                fetchRecipesBySearch(value);
              });
            }
          }
        },
        onSubmitted: (value) {
          if (!searchOnEveryKeystroke) {
            setState(() {
              _searchQuery = value;
              recipes.clear();
              filteredRecipes.clear();
              fetchRecipesBySearch(value);
            });
          }
        },
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          textAlign: TextAlign.center,
          AppLocalizations.of(context).translate('No results found.'),
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Center(
      child: TextButton.icon(
        icon: Icon(MdiIcons.filterMenuOutline),
        label: Text(AppLocalizations.of(context)
            .translate('Filter the recipes once more')),
        onPressed: _toggleFilter,
      ),
    );
  }

  Widget _buildFilterOptions(bool isAndroid, bool isDesktop) {
    return Center(
      child: ListView(
        scrollDirection:
            isAndroid || !isDesktop ? Axis.vertical : Axis.horizontal,
        shrinkWrap: true,
        children: [
          _buildChip(AppLocalizations.of(context).translate('Prep: 0-15 mins'),
              'Preparation Time', 0, 15),
          _buildChip(AppLocalizations.of(context).translate('Prep: 15-30 mins'),
              'Preparation Time', 15, 30),
          _buildChip(AppLocalizations.of(context).translate('Cook: 0-30 mins'),
              'Cooking Time', 0, 30),
          _buildChip(AppLocalizations.of(context).translate('Cook: 30-60 mins'),
              'Cooking Time', 30, 60),
        ],
      ),
    );
  }

  Widget _buildChip(
      String label, String durationType, int minDuration, int maxDuration) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ActionChip(
        label: Text(label),
        onPressed: () {
          _filterRecipesByDuration(durationType, minDuration, maxDuration);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
