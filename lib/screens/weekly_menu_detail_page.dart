import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

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
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                meal.title,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: isDesktop ? 75 : 20,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: meal.dayOfWeek.length,
                itemBuilder: (context, index) {
                  final dayOfWeek = meal.dayOfWeek[index];
                  final recipeImage =
                      ('${Constants.baseUrl}/${dayOfWeek.recipeImage}')
                          .replaceAll('\\', '/');
                  if (index.isEven) {
                    return _buildRow(dayOfWeek, recipeImage, isDesktop, index);
                  } else {
                    return _buildReversedRow(
                        dayOfWeek, recipeImage, isDesktop, index);
                  }
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
      Recipe recipe, String recipeImage, bool isDesktop, int index) {
    return Row(
      children: [
        Expanded(child: _buildColumnWithData(recipe, isDesktop, index)),
        Expanded(child: _buildImageData(recipeImage, isDesktop, index)),
      ],
    );
  }

  Widget _buildReversedRow(
      Recipe recipe, String recipeImage, bool isDesktop, int index) {
    return Row(
      children: [
        Expanded(child: _buildImageData(recipeImage, isDesktop, index)),
        Expanded(child: _buildColumnWithData(recipe, isDesktop, index)),
      ],
    );
  }

  Widget _buildColumnWithData(Recipe recipe, bool isDesktop, int index) {
    TextStyle textStyle = GoogleFonts.getFont(recipe.categoryFont,
        color: HexColor(
          recipe.categoryColor,
        ).withOpacity(0.7),
        fontSize: isDesktop
            ? Constants.desktopHeadingTitleSize
            : Constants.mobileHeadingTitleSize);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 25,
        ),
        getWeekdayName(index, recipe, isDesktop),
        const SizedBox(
          height: 50,
        ),
        Text(
          recipe.recipeTitle,
          style: textStyle,
        ),
        Divider(
          endIndent: 50,
          indent: 50,
          color: HexColor(
            recipe.categoryColor,
          ),
          thickness: 2,
        ), // Add a Divider
        Text(
          recipe.description,
          style: textStyle,
        ),
        // Add more data as needed
      ],
    );
  }

  Widget _buildImageData(String recipeImage, bool isDesktop, int index) {
    return Container(
      width: 500, // Adjust width as needed
      height: 500, // Adjust height as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
        image: DecorationImage(
          image: NetworkImage(recipeImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget getWeekdayName(int index, Recipe recipe, bool isDesktop) {
    TextStyle textStyle = GoogleFonts.getFont(recipe.categoryFont,
        color: HexColor(
          recipe.categoryColor,
        ).withOpacity(0.7),
        fontSize: isDesktop
            ? Constants.desktopHeadingTitleSize
            : Constants.mobileHeadingTitleSize);

    switch (index) {
      case 0:
        return Text(
          'Monday',
          style: textStyle,
        );
      case 1:
        return Text(
          'Tuesday',
          style: textStyle,
        );
      case 2:
        return Text(
          'Wednesday',
          style: textStyle,
        );
      case 3:
        return Text(
          'Thursday',
          style: textStyle,
        );
      case 4:
        return Text(
          'Friday',
          style: textStyle,
        );
      case 5:
        return Text(
          'Saturday',
          style: textStyle,
        );
      case 6:
        return Text(
          'Sunday',
          style: textStyle,
        );
      default:
        return Container();
    }
  }
}
