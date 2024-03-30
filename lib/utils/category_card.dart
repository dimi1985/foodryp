import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';

import '../screens/recipe_page.dart';

class CategoryCard extends StatefulWidget {
  final Size screenSize;
  const CategoryCard({super.key, required this.screenSize});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: widget.screenSize.height / 3.5,
          maxWidth: widget.screenSize.width,
        ),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: Constants.categories.length,
              itemBuilder: (context, index) {
                final category = Constants.categories[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipePage(recipeData: category),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: widget.screenSize.height * 0.3,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          Expanded(
                            flex: widget.screenSize.width > 800 ? 2 : 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(
                                        5)), // Set desired corner radius
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://picsum.photos/200/300'),
                                  fit: BoxFit
                                      .cover, // Maintain aspect ratio and cover container
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: widget.screenSize.width > 800 ? 2 : 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        5.0), // Adjust corner radius
                                    child: Container(
                                      color: category[
                                          'color'], // Set background color
                                      padding: widget.screenSize.width < 800
                                          ? const EdgeInsets.all(2)
                                          : const EdgeInsets.all(
                                              10.0), // Adjust padding as needed
                                      child: Text(
                                        category['title'],
                                        style: TextStyle(
                                          color: calculateContrastingColor(category[
                                              'color']), // Determine contrasting color
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.menu,
                                        color: Colors.black,
                                      ),
                                      Text(
                                          '${category.length.toString()} Recipes')
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ), //BoxConstraints
      ),
    );
  }

  Color calculateContrastingColor(Color backgroundColor) {
    double luminance = calculateLuminance(backgroundColor);
    return luminance < 0.5 ? Colors.white : Colors.black;
  }

  double calculateLuminance(Color color) {
    // Convert the color to HSV format
    HSLColor hslColor = HSLColor.fromColor(color);

    // Luminance is directly represented by the lightness component in HSL
    return hslColor.lightness;
  }
}
