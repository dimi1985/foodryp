import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/screens/recipe_by_category_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:foodryp/models/category.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_category_card.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/api/categories'));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List<dynamic>;
        final List<CategoryModel> fetchedCategories =
            decodedData.map((categoryJson) => CategoryModel.fromJson(categoryJson)).toList();
        setState(() {
          categories = fetchedCategories;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
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
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  RecipeByCategoryPage(category:category,)),
              );
                  },
                  child: CustomCategoryCard(
                    category:category
                  ),
                );
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
