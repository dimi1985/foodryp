import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/weekly_menu_detail_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_weekly_menu_card.dart';
import 'package:foodryp/widgets/CustomWidgets/shimmer_loader.dart';

class WeeklyMenuPage extends StatefulWidget {
  final User? user;
  final bool isForDiet;
  final bool showAll;

  const WeeklyMenuPage({super.key, this.user, required this.isForDiet, required this.showAll});

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
    currentPage = 'Weekly Menu Page';
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
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      final fetchedWeeklyMenu = await MealService().getWeeklyMenusByPage(
        _currentPage,
        _pageSize,
      );
      if (mounted) {
        setState(() {
          meals = widget.showAll ? fetchedWeeklyMenu : fetchedWeeklyMenu.where((meal) => meal.isForDiet == widget.isForDiet).toList();
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

  Future<void> _fetchMoreWeeklyMenu() async {
    if (!_isLoading) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      try {
        final fetchedRecipes = await MealService().getWeeklyMenusByPage(
          _currentPage + 1, // Fetch next page
          _pageSize,
        );
        if (mounted) {
          setState(() {
            meals.addAll(widget.showAll ? fetchedRecipes : fetchedRecipes.where((meal) => meal.isForDiet == widget.isForDiet));
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
    final bool isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate(widget.showAll ? 'All Menus' : (widget.isForDiet ? 'Diet Menus' : 'Non-Diet Menus'))),
      ),
      body: _buildWeeklyMenuList(isDesktop),
    );
  }

  Widget _buildWeeklyMenuList(bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(
            maxWidth: 600
          ),
          child: ListView.builder(
              key:  const PageStorageKey<String>('weekly_menu_page'),
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: meals.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < meals.length) {
                final meal = meals[index];
                return Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeeklyMenuDetailPage(meal: meal),
                        ),
                      );
                    },
                    child: CustomWeeklyMenuCard(
                      meal: meal,
                      currentPage: currentPage,
                      isForAll: true,
                      publicUserId: '', 
                      currentUserId: '',
                       isForDiet: widget.isForDiet,
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
    return const ShimmerLoader(); // Use the shimmer loader here
  }
}
