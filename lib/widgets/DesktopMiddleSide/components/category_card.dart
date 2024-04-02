import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_card.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
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
              itemCount: DemoData.categories.length,
              itemBuilder: (context, index) {
                final category = DemoData.categories[index];
                return CustomCard(
                  title: category['title'],
                  imageUrl: category['image'],
                  color: category['color'],
                  itemList: category.length.toString(),
                  internalUse:
                      'categories', // Example usage
                  onTap: () {
                    // Handle card tap here (optional)
                  }, username: '', userImageURL: '', date: DateTime.now(),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 10,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
