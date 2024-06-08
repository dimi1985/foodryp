import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_profile_recipe_card.dart';
import 'package:foodryp/widgets/CustomWidgets/shimmer_custom_profile_recipe_card.dart'; // Import the shimmer card

class RecipeCardProfileSection extends StatefulWidget {
  final User user;
  const RecipeCardProfileSection({
    Key? key,
    required this.user,
  });

  @override
  State<RecipeCardProfileSection> createState() => _RecipeCardProfileSectionState();
}

class _RecipeCardProfileSectionState extends State<RecipeCardProfileSection> {
  late ScrollController _scrollController;
  List<Recipe> recipes = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  double lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
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
    if (_scrollController.position.pixels > lastScrollPosition) {
      if (!_isLoading &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        _fetchMoreRecipes();
      }
    }
    lastScrollPosition = _scrollController.position.pixels;
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedRecipes = await _fetchRecipesData(_currentPage, _pageSize);
      setState(() {
        recipes = fetchedRecipes;
        _isLoading = false;
      });
    } catch (_) {
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
        final fetchedRecipes =
            await _fetchRecipesData(_currentPage + 1, _pageSize);
        setState(() {
          recipes.addAll(fetchedRecipes);
          _currentPage++;
          _isLoading = false;
        });
      } catch (_) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<List<Recipe>> _fetchRecipesData(int currentPage, int pageSize) async {
    final currentUserId = await UserService().getCurrentUserId();
    try {
      List<Recipe> fetchedRecipes = [];
      if (widget.user.id == currentUserId) {
        fetchedRecipes = await RecipeService().getUserRecipesByPage(
          currentPage,
          pageSize,
        );
      } else {
        fetchedRecipes = await RecipeService().getUserPublicRecipesByPage(
          widget.user.username,
          currentPage,
          pageSize,
        );
      }
      return fetchedRecipes;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Responsive.isDesktop(context) ? 32 : 16),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (Responsive.isDesktop(context)) {
                      return null;
                    }
                    if (_isLoading && index >= recipes.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShimmerCustomProfileRecipeCard(),
                      );
                    }
                    final recipe = recipes[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailPage(
                                recipe: recipe,
                                internalUse: Constants.emptyField,
                                missingIngredients: const [],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 350,
                          width: 350,
                          child: CustomProfileRecipeCard(
                            internalUse: '',
                            recipe: recipe,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _isLoading ? recipes.length + 1 : recipes.length,
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (_isLoading && index >= recipes.length) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ShimmerCustomProfileRecipeCard(),
                        );
                      }
                      final recipe = recipes[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            hoverColor: Colors.transparent,
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
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Constants.defaultPadding),
                                color: Colors.transparent,
                              ),
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: CustomProfileRecipeCard(
                                  internalUse: '',
                                  recipe: recipe,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _isLoading ? recipes.length + 1 : recipes.length,
                  ),
                ),
              ),
            if (_isLoading)
              const SliverPadding(
                padding: EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
