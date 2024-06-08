import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/screens/recipe_by_category_page/recipe_by_category_page.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_category_card.dart';
import 'package:foodryp/widgets/CustomWidgets/shimmer_custom_category_card.dart'; // Import the shimmer card

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  List<CategoryModel> categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      const int desiredLength = 3;
      final categoryService = CategoryService();
      final fetchedCategories = await categoryService.getFixedCategories(desiredLength);

      setState(() {
        categories = fetchedCategories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SizedBox(
          height: 200,
          width: screenSize.width,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _isLoading ? 3 : categories.length, // Show shimmer cards while loading
              itemBuilder: (context, index) {
                if (_isLoading) {
                  return ShimmerCustomCategoryCard();
                } else {
                  final category = categories[index];
                  if (category.name == 'Uncategorized') {
                    return const SizedBox.shrink();
                  }
                  return InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () async {
                      await Navigator.push(
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
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 25,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
