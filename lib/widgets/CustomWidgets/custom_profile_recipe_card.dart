import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/recipe_deletion_confirmation_screen.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomProfileRecipeCard extends StatefulWidget {
  final String internalUse;
  final Recipe recipe;
  final List<String>? missingIngredients;
  const CustomProfileRecipeCard({
    super.key,
    required this.internalUse,
    required this.recipe,
    this.missingIngredients,
  });

  @override
  State<CustomProfileRecipeCard> createState() =>
      _CustomProfileRecipeCardState();
}

class _CustomProfileRecipeCardState extends State<CustomProfileRecipeCard> {
  bool isOwner = false;
  bool isAuthenticated = false;
  List<String>? uniqueIngredients = [];
  @override
  void initState() {
    checkAuthenticationAndOwnershipStatus();
    uniqueIngredients = widget.missingIngredients?.toSet().toList();
    super.initState();
  }

  Future<void> checkAuthenticationAndOwnershipStatus() async {
    String getCurrentUserId = await UserService().getCurrentUserId();
    setState(() {
      isAuthenticated = getCurrentUserId.isNotEmpty;
      isOwner =
          isAuthenticated && widget.recipe.userId.contains(getCurrentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final recipeImage = '${Constants.imageURL}/${widget.recipe.recipeImage}';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.defaultPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: SizedBox(
        height: screenSize.height * 0.50,
        child: Column(
          children: [
            SizedBox(
              height: screenSize.height * 0.15,
              width: screenSize.width,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Constants.defaultPadding),
                  topRight: Radius.circular(Constants.defaultPadding),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Define an appropriate aspect ratio
                  child: Image.network(
                    recipeImage,
                    fit: BoxFit.cover,
                    width: screenSize.width,
                  ),
                ),
              ),
            ),
            //White Card
            SizedBox(
              height: screenSize.height * 0.20,
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
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ImagePickerPreviewContainer(
                          containerSize: 20,
                          onImageSelected: (file, list) {},
                          gender: '',
                          isFor: '',
                          initialImagePath: widget.recipe.useImage!,
                          isForEdit: false,
                          allowSelection: false,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.recipe.username,
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
                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            Constants.calculateMembershipDuration(context,
                                widget.recipe.dateCreated), // Format the date
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context)
                                  ? Constants.desktopFontSize
                                  : Constants.mobileFontSize,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          widget.recipe.recipeTitle.toUpperCase(),
                          style: GoogleFonts.getFont(
                            widget.recipe.categoryFont,
                            fontSize: Responsive.isDesktop(context)
                                ? Constants.desktopFontSize
                                : Constants.mobileFontSize,
                            fontWeight: FontWeight.bold,
                            color: HexColor(widget.recipe.categoryColor)
                                .withOpacity(0.7),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          widget.recipe.categoryName.toUpperCase(),
                          style: GoogleFonts.getFont(
                            widget.recipe.categoryFont,
                            fontSize: Responsive.isDesktop(context)
                                ? Constants.desktopFontSize
                                : Constants.mobileFontSize,
                            fontWeight: FontWeight.bold,
                            color: HexColor(widget.recipe.categoryColor)
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        if (isOwner &&
                            isAuthenticated &&
                            widget.internalUse != 'MainScreen' &&
                            widget.internalUse != 'RecipePage')
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddRecipePage(
                                    recipe: widget.recipe,
                                    isForEdit: isOwner,
                                    user: null,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        if (isOwner &&
                            isAuthenticated &&
                            widget.internalUse != 'MainScreen' &&
                            widget.internalUse != 'RecipePage')
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDeletionConfirmationScreen(
                                  recipe: widget.recipe,
                                ),
                              ));
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        const Icon(Icons.favorite_border),
                        Text(
                          widget.recipe.likedBy.length.toString(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
