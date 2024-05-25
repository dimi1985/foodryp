import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class WeeklyMenuDetailPage extends StatelessWidget {
  final WeeklyMenu meal;

  const WeeklyMenuDetailPage({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.title,
              style: GoogleFonts.lobster(
                color: Colors.white,
                fontSize: isDesktop ? 24 : 20,
              ),
            ),
            Row(
              children: [
                Text(
                  'Posted by ${meal.username} on ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isDesktop ? 14 : 12,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(meal.dateCreated),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: meal.dayOfWeek.length,
                    itemBuilder: (context, index) {
                      final dayOfWeek = meal.dayOfWeek[index];

                      if (index.isEven) {
                        return _buildRow(
                            dayOfWeek,
                            dayOfWeek.recipeImage ?? Constants.emptyField,
                            isDesktop,
                            index,
                            context);
                      } else {
                        return _buildReversedRow(
                            dayOfWeek,
                            dayOfWeek.recipeImage ?? Constants.emptyField,
                            isDesktop,
                            index,
                            context);
                      }
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(Recipe recipe, String recipeImage, bool isDesktop, int index,
      BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 8,
            color: HexColor(recipe.categoryColor ?? Constants.emptyField),
          ),
          Expanded(
            child: _buildColumnWithData(
                recipe, recipeImage, isDesktop, index, context),
          ),
          Expanded(
            child: _buildImageData(recipeImage, isDesktop, index, context),
          ),
        ],
      ),
    );
  }

  Widget _buildReversedRow(Recipe recipe, String recipeImage, bool isDesktop,
      int index, BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _buildImageData(recipeImage, isDesktop, index, context),
          ),
          Expanded(
            child: _buildColumnWithData(
                recipe, recipeImage, isDesktop, index, context),
          ),
          Container(
            width: 8,
            color: HexColor(recipe.categoryColor ?? Constants.emptyField),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnWithData(Recipe recipe, String recipeImage, bool isDesktop,
      int index, BuildContext context) {
    TextStyle textStyle = GoogleFonts.getFont(
      recipe.categoryFont ?? Constants.emptyField,
      color: HexColor(
        recipe.categoryColor ?? Constants.emptyField,
      ).withOpacity(0.7),
      fontSize: isDesktop
          ? Constants.desktopHeadingTitleSize
          : Constants.mobileHeadingTitleSize,
    );

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  getWeekdayName(index, context),
                  style: textStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  recipe.recipeTitle ?? Constants.emptyField,
                  style: textStyle.copyWith(fontSize: isDesktop ? 24 : 20),
                ),
              ],
            ),
          ),
          Divider(
            color: HexColor(
              recipe.categoryColor ?? Constants.emptyField,
            ),
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              recipe.description ?? Constants.emptyField,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageData(
      String recipeImage, bool isDesktop, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: recipeImage,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              filterQuality: FilterQuality.none,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                Icon(
                  meal.dayOfWeek[index].isForDiet
                      ? MdiIcons.nutrition
                      : meal.dayOfWeek[index].isForVegetarians
                          ? MdiIcons.leaf
                          : null,
                  color: meal.dayOfWeek[index].isForDiet
                      ? Colors.blue
                      : meal.dayOfWeek[index].isForVegetarians
                          ? Colors.green
                          : null,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: HexColor(meal.dayOfWeek[index].categoryColor ??
                            Constants.emptyField)
                        .withOpacity(0.7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      meal.dayOfWeek[index].categoryName.toUpperCase(),
                      style: GoogleFonts.getFont(
                        meal.dayOfWeek[index].categoryFont ??
                            Constants.emptyField,
                        fontSize: isDesktop
                            ? Constants.desktopFontSize
                            : Constants.mobileFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 221, 221, 221).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  meal.dayOfWeek[index].difficulty ?? Constants.emptyField,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getWeekdayName(int index, BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context).translate('Monday');
      case 1:
        return AppLocalizations.of(context).translate('Tuesday');
      case 2:
        return AppLocalizations.of(context).translate('Wednesday');
      case 3:
        return AppLocalizations.of(context).translate('Thursday');
      case 4:
        return AppLocalizations.of(context).translate('Friday');
      case 5:
        return AppLocalizations.of(context).translate('Saturday');
      case 6:
        return AppLocalizations.of(context).translate('Sunday');
      default:
        return '';
    }
  }
}
