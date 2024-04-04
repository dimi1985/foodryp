import 'package:flutter/material.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/recipe_section.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/top_three_recipe_card.dart';
import 'components/category_section.dart';

class DesktopMiddleSide extends StatelessWidget {
  const DesktopMiddleSide({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  ListView(
                children: const [
                  SizedBox(
                    height: 400,
                    child: TopThreeRecipeCard(),
                  ),
                  SizedBox(height: 100,),
                  HeadingTitleRow(
                    title: 'Recipes',
                  ),
                  RecipeSection(),
                  HeadingTitleRow(
                    title: 'Categories',
                  ),
                  CategorySection(),
                ],
              )
           
      ),
    );
  }
}
