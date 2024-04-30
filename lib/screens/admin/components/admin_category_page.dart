import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/screens/admin/components/admin_add_category_page.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_category_card.dart';

class AdminCategoryPage extends StatefulWidget {
  const AdminCategoryPage({Key? key});

  @override
  State<AdminCategoryPage> createState() => _AdminCategoryPageState();
}

class _AdminCategoryPageState extends State<AdminCategoryPage> {
  late final List<CategoryModel> _categories = [];
  late int _page = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final List<CategoryModel> categories =
          await CategoryService().getCategoriesByPage(_page, _pageSize);
      setState(() {
        _categories.addAll(categories);
        _page++; // Increment page for next fetch
      });
    } catch (e) {
      // Handle error
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Category Page'),
      ),
      body: _categories.isEmpty
          ? Column(
            children: [
              const Center(
                  child: Text('No categories'),
                ),
                 Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdminAddCategoryPage(category: null),
                        ),
                      );
                    },
                    child: const Text('Add Category'),
                  ),
                ),
            ],
          )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AdminAddCategoryPage(category: category),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: CustomCategoryCard(category: category)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdminAddCategoryPage(category: null),
                        ),
                      );
                    },
                    child: const Text('Add Category'),
                  ),
                ),
              ],
            ),
    );
  }
}
