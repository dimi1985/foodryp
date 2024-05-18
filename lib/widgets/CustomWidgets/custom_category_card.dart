import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class CustomCategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CustomCategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              color: themeProvider.currentTheme == ThemeType.dark
                  ? const Color.fromARGB(255, 37, 36, 37)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.currentTheme == ThemeType.dark
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SizedBox(
              height: 200,
              width: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Day and recipe details
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // Recipe details
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              category.name,
                              style: GoogleFonts.getFont(
                                category.font,
                                color:
                                    HexColor(category.color).withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Recipe details
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              '${AppLocalizations.of(context).translate('Recipes:')} ${category.recipes?.length.toString()}',
                              style: GoogleFonts.getFont(
                                category.font,
                                color:
                                    HexColor(category.color).withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Add more recipe details here
                        ],
                      ),
                    ),
                  ),
                  // Right side - Recipe image
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Image.network(
                              category.categoryImage ?? Constants.emptyField,
                                  loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // image fully loaded, return the image widget
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null, // This will show a determinate progress indicator if size is known, otherwise indeterminate
                          ),
                        );
                      }},
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              filterQuality: FilterQuality.none,
                            ),
                            category.isForDiet || category.isForVegetarians
                                ? Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: category.isForDiet
                                            ? Colors.blue
                                            : category.isForVegetarians
                                                ? Colors.green
                                                : null,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              category.isForDiet
                                                  ? MdiIcons.nutrition
                                                  : MdiIcons.leaf,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            _dynamicText(
                                                category.isForDiet,
                                                category.isForVegetarians,
                                                context),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _dynamicText(bool isForDiet, bool isForVegetarians, BuildContext context) {
    if (isForDiet) {
      return Container(
        color: Colors.blue,
        child: Text(
          AppLocalizations.of(context).translate('For Diet'),
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    } else if (isForVegetarians) {
      return Container(
        color: Colors.green,
        child: Text(
          AppLocalizations.of(context).translate('For Vegeterians'),
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    } else if (isForVegetarians && isForDiet) {
      return Column(
        children: [
          Container(
            color: Colors.blue,
            child: Text(
              AppLocalizations.of(context).translate('For Diet'),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
          Container(
            color: Colors.green,
            child: Text(
              AppLocalizations.of(context).translate('For Vegeterians'),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
