import 'package:flutter/material.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/recipe_card_desktop.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/recipe_card_mobile.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/top_three_recipe_card.dart';
import '../CustomWidgets/top_creators.dart';
import 'components/headingTitle.dart';
import 'components/category_card.dart';

class DesktopMiddleSide extends StatelessWidget {
  const DesktopMiddleSide({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        body:Responsive.isMobile(context)? ListView(
          children:  const [
            SizedBox(
              height: 400,
              child: TopThreeRecipeCard()),
          HeadingTitle(title: 'Categories',),
          CategoryCard(),
          HeadingTitle(title: 'Recipes',),
          RecipeCardMobile(),
          HeadingTitle(title: 'Top Creators',),
          TopCreators()

          ],
        ):const RecipeCardDesktop() ,
      ),
    );
  }
}
