import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_profile_recipe_card.dart';
import 'package:foodryp/widgets/CustomWidgets/shimmer_custom_profile_recipe_card.dart';

class RecipeCardProfileSection extends StatefulWidget {
  final User user;
  const RecipeCardProfileSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<RecipeCardProfileSection> createState() =>
      _RecipeCardProfileSectionState();
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
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      final fetchedRecipes = await _fetchRecipesData(_currentPage, _pageSize);
      setState(() {
        recipes = fetchedRecipes;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isDesktop(context) ? 3 : 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      itemCount: _isLoading ? recipes.length + 1 : recipes.length,
      itemBuilder: (context, index) {
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
            child: CustomProfileRecipeCard(
              internalUse: '',
              recipe: recipe,
            ),
          ),
        );
      },
    );
  }
}
