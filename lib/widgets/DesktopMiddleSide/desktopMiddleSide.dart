import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/creators.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/category_section.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/recipe_section.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/top_three_recipe_card.dart';

class DesktopMiddleSide extends StatelessWidget {
  const DesktopMiddleSide({Key? key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
        bool isLargeScreen = constraints.maxWidth > 600;

        return SafeArea(
          child: Scaffold(
            body: ListView(
              children: [
                const SizedBox(
                  height: 400,
                  child: TopThreeRecipeCard(),
                ),
                SizedBox(height: isLargeScreen ? 100 : isAndroid ? 10 : 50),
                HeadingTitleRow(
                  title: AppLocalizations.of(context).translate('Recipes'),
                ),
                const RecipeSection(),
                if (isLargeScreen || isAndroid) const SizedBox(height: 25),
                HeadingTitleRow(
                  title: AppLocalizations.of(context).translate('Categories'),
                ),
                const CategorySection(),
                const SizedBox(height: 15.0),
                HeadingTitleRow(
                  title: AppLocalizations.of(context).translate('Creators'),
                ),
                const Creators(
                  showAllUsers: true,
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
