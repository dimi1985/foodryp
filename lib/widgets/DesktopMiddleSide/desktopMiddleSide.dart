import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/recipe_section.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/top_three_recipe_card.dart';
import 'components/category_section.dart';

class DesktopMiddleSide extends StatelessWidget {
  const DesktopMiddleSide({super.key});

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return SafeArea(
      child: Scaffold(
          body: ListView(
        children: [
          const SizedBox(
            height: 400,
            child: TopThreeRecipeCard(),
          ),
          SizedBox(
            height: isAndroid ? 10 : 100,
          ),
           HeadingTitleRow(
            title: AppLocalizations.of(context)
                                  .translate('Recipes'),
          ),
          const RecipeSection(),
          if (isAndroid) const SizedBox(height: 25),
           HeadingTitleRow(
            title: AppLocalizations.of(context)
                                  .translate('Categories'),
          ),
          const CategorySection(),
        ],
      )),
    );
  }
}
