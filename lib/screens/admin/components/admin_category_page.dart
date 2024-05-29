import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/admin/components/admin_add_category_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_category_card.dart';

class AdminCategoryPage extends StatefulWidget {
  final User user;
  const AdminCategoryPage({super.key, required this.user,});

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
        title:  Text(AppLocalizations.of(context).translate('Admin Category Page')),
      ),
      body: _categories.isEmpty
          ? Column(
            children: [
               Center(
                  child: Text(AppLocalizations.of(context).translate('No categories')),
                ),
                 Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                               AdminAddCategoryPage(category: null,userRole:widget.user.role),
                        ),
                      );
                    },
                    child:  Text(AppLocalizations.of(context).translate('Add Category')),
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
                                    AdminAddCategoryPage(category: category, userRole: widget.user.role,),
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
                               AdminAddCategoryPage(category: null, userRole: widget.user.role,),
                        ),
                      );
                    },
                    
                    child:  Text(AppLocalizations.of(context).translate('Add Category')),
                  ),
                ),
              ],
            ),
    );
  }
}
