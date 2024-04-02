import 'package:flutter/material.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/recipe_card.dart';
import '../CustomWidgets/top_creators.dart';
import 'components/headingTitle.dart';
import 'components/category_card.dart';

class DesktopMiddleSide extends StatelessWidget {
  const DesktopMiddleSide({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: const [
            HeadingTitle(title: 'Categories',),
            CategoryCard(),
              HeadingTitle(title: 'Recipes',),
              RecipeCard(),
               HeadingTitle(title: 'Top Creators',),
              TopCreators()

          ],
        ),
      ),
    );
  }
}
