
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/weekly_menu_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_weekly_menu_card.dart';

class WeeklyMenuPage extends StatefulWidget {
  final User? user;
  const WeeklyMenuPage({super.key, this.user});

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
          meals = fetchedWeeklyMenu;
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
            meals.addAll(fetchedRecipes);
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
      body: _buildWeeklyMenuList(isDesktop),
    );
  }

  Widget _buildWeeklyMenuList(bool isDesktop) {
    //Responsive.isDesktop(context) ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width,
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
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
                MaterialPageRoute(builder: (context) =>  WeeklyMenuDetailPage(meal: meal,)),
              );
                    },
                    child: CustomWeeklyMenuCard(
                      meal: meal,
                      currentPage: currentPage,
                      isForAll: true,
                      publicUserId: '',
                      currentUserId: '',
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
