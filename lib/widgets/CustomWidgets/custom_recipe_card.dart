import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class CustomRecipeCard extends StatelessWidget {
  final String internalUse;
  final Function() onTap;
  final Recipe recipe;

  const CustomRecipeCard({
    super.key,
    required this.internalUse,
    required this.onTap,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final recipeImage = '${Constants.imageURL}/${recipe.recipeImage}';
    return InkWell(
      onTap: onTap,
      child: Container(
      
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.defaultPadding),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(isAndroid ? 0.2 : 0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Constants.defaultPadding),
                  topRight: Radius.circular(Constants.defaultPadding),
                ),
                child: Image.network(
                  recipeImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: isAndroid ? 3 : 2,
              child: Container(
                padding: const EdgeInsets.all(Constants.defaultPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Constants.defaultPadding),
                    bottomRight: Radius.circular(Constants.defaultPadding),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ImagePickerPreviewContainer(
                          containerSize: 10,
                          onImageSelected: (file, list) {},
                          gender: '',
                          isFor: '',
                          initialImagePath: recipe.useImage!,
                          isForEdit: false,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          recipe.username,
                          style: TextStyle(
                            fontSize: Responsive.isDesktop(context)
                                ? Constants.desktopFontSize
                                : Constants.mobileFontSize,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                            width: 5), // Adjust the spacing as needed
                        Text(
                          '•',
                          style: TextStyle(
                            fontSize: Responsive.isDesktop(context)
                                ? Constants.desktopFontSize
                                : Constants.mobileFontSize,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                            width: 5), // Adjust the spacing as needed

                        Text(
                          DateFormat('dd MMM yyyy')
                              .format(recipe.date), // Format the date
                          style: TextStyle(
                            fontSize: Responsive.isDesktop(context)
                                ? Constants.desktopFontSize
                                : Constants.mobileFontSize,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    Text(
                      recipe.difficulty,
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context)
                            ? Constants.desktopFontSize
                            : Constants.mobileFontSize,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      
                          Text(
                            recipe.recipeTitle.toUpperCase(),
                            style: GoogleFonts.getFont(
                              recipe.categoryFont,
                              fontSize: Responsive.isDesktop(context)
                                  ? Constants.desktopFontSize
                                  : Constants.mobileFontSize,
                              fontWeight: FontWeight.bold,
                              color:
                                  HexColor(recipe.categoryColor).withOpacity(0.7),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.favorite_border),
                              Text(
                                recipe.likedBy.length.toString(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // You can add more widgets here if needed
                  ],
                ),
              ),
            ),
            if (isAndroid)
              const SizedBox(
                height: 20,
              )
          ],
        ),
      ),
    );
  }
}
