import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:intl/intl.dart';

import '../screens/recipe_page.dart';

class RecipeCard extends StatefulWidget {
  final Size screenSize;
  const RecipeCard({super.key, required this.screenSize});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: widget.screenSize.width < 400
              ? widget.screenSize.height / 2
              : widget.screenSize.height / 3.5,
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
              itemCount: Constants.regularRecipes.length,
              itemBuilder: (context, index) {
                final regularRecipe = Constants.regularRecipes[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipePage(recipeData: regularRecipe),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: widget.screenSize.height * 0.3,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          'https://picsum.photos/200', // Replace with your image URL
                                        ),
                                        radius: 10,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(regularRecipe['username']),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        regularRecipe['title'],
                                        style: TextStyle(
                                            color: regularRecipe['color']),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.date_range),
                                          const SizedBox(width: 5),
                                          Flexible(
                                            // Use Flexible instead of Expanded
                                            flex:
                                                2, // Adjust flex value for desired space distribution
                                            child: Text(
                                              DateFormat('MMMM d, y').format(
                                                  regularRecipe['date']),
                                            ),
                                          ),
                                        ],
                                      ),
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
}
