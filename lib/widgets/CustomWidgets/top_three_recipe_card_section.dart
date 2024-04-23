import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/topthree_mobile_card.dart';

class TopThreeRecipeCardSection extends StatefulWidget {
  const TopThreeRecipeCardSection({super.key});

  @override
  State<TopThreeRecipeCardSection> createState() =>
      _TopThreeRecipeCardSectionState();
}

class _TopThreeRecipeCardSectionState extends State<TopThreeRecipeCardSection> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
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
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)
                    .translate('Top\n Three Recipes \n Of\n The Week'),
                style: TextStyle(
                  fontSize: screenSize.width <= 1500 ? 30 : 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
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
                        width: screenSize.width <= 1100
                            ? 260
                            : screenSize.width <= 1400
                                ? screenSize.width / 7
                                : screenSize.width / 8,
                        height: screenSize.height,
                        child: CustomCategoryTopThreeMobileCard(
                          title: regularRecipe['title'],
                          imageUrl: regularRecipe['image'],
                          color: regularRecipe['color'],
                          itemList: regularRecipe.length.toString(),
                          internalUse: 'top_three',
                          onTap: () {
                            // Handle card tap here (optional)
                          },
                          username: regularRecipe['username'],
                          userImageURL: 'https://picsum.photos/200/300',
                          date: regularRecipe['date'],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: Responsive.isMobile(context) ? 10 : 50,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
