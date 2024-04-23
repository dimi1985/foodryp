import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_app_bar.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_weekly_menu_card.dart';

class WeeklyMenuPage extends StatefulWidget {
  const WeeklyMenuPage({super.key});

  @override
  State<WeeklyMenuPage> createState() => _WeeklyMenuPageState();
}

class _WeeklyMenuPageState extends State<WeeklyMenuPage> {
  late ScrollController _scrollController;
  List<WeeklyMenu> meals = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  late String currentPage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    currentPage = 'WeeklyMenuPage';
    _fetchWeeklyMenu(); // Fetch initial set of recipes
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreWeeklyMenu(); // Fetch more recipes when reaching the end of the list
    }
  }

  Future<void> _fetchWeeklyMenu() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedWeeklyMenu = await MealService().getWeeklyMenusByPage(
        _currentPage,
        _pageSize,
      );
      setState(() {
        meals = fetchedWeeklyMenu;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreWeeklyMenu() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      try {
        final fetchedRecipes = await MealService().getWeeklyMenusByPage(
          _currentPage + 1, // Fetch next page
          _pageSize,
        );
        setState(() {
          meals.addAll(fetchedRecipes);
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
    final bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      body: _buildWeeklyMenuList(),
    );
  }

  Widget _buildWeeklyMenuList() {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Center(
        child: SizedBox(
          width: 600,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: meals.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < meals.length) {
                final meal = meals[index];
                return Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: InkWell(
                      onTap: () {},
                      child: CustomWeeklyMenuCard(
                        meal: meal,
                        currentPage:currentPage, isForAll: true, publicUserId: '', currentUserId: '',
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
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
