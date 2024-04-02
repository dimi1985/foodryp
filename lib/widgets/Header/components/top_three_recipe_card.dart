

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_card.dart';

class TopThreeRecipeCard extends StatefulWidget {
  const TopThreeRecipeCard({super.key});

  @override
  State<TopThreeRecipeCard> createState() => _TopThreeRecipeCardState();
}

class _TopThreeRecipeCardState extends State<TopThreeRecipeCard> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SizedBox(
          height: screenSize.height,
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
              itemCount: 3,
              itemBuilder: (context, index) {
                final regularRecipe = DemoData.regularRecipes[index];
                return SizedBox(
                  width:Responsive.isMobile(context) ? 150 : screenSize.width / 8,
                  height: screenSize.height,
                  child: CustomCard(
                    title: regularRecipe['title'],
                    imageUrl: regularRecipe['image'],
                    color: regularRecipe['color'],
                    itemList: regularRecipe.length.toString(),
                    internalUse: 'recipes', 
                    onTap: () {
                      // Handle card tap here (optional)
                    }, username: regularRecipe['username'], userImageURL:  'https://picsum.photos/200/300', date: regularRecipe['date'],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return  SizedBox(
                  width: Responsive.isMobile(context) ? 10 : 50,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}