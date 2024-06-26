// ignore_for_file: library_private_types_in_public_api
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/screens/recipe_by_category_page/recipe_by_category_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_category_card.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<CategoryModel> categories = [];
  late int currentPage = 1;
  final int pageSize = 10;

  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchCategories(currentPage, pageSize);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreCategories();
    }
  }

  Future<void> _fetchCategories(int page, int pageSize) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<CategoryModel> fetchedCategories =
          await CategoryService().getCategoriesByPage(page, pageSize);
      setState(() {
        categories.addAll(fetchedCategories);
        _isLoading = false;
        currentPage++; // Increment current page for the next fetch
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreCategories() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      try {
        final List<CategoryModel> fetchedCategories =
            await CategoryService().getCategoriesByPage(currentPage, pageSize);
        setState(() {
          categories.addAll(fetchedCategories);
          _isLoading = false;
          currentPage++; // Increment current page for the next fetch
        });
      } catch (e) {
        print('Error fetching more categories: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Categories')),
      ),
      body: Center(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: categories.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == categories.length) {
                return _buildLoader(); // Show loading indicator
              } else {
                final category = categories[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeByCategoryPage(
                          category: category,
                        ),
                      ),
                    );
                  },
                  child: CustomCategoryCard(category: category),
                );
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
