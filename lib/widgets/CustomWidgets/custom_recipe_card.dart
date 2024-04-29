import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/recipe_deletion_confirmation_screen.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomRecipeCard extends StatefulWidget {
  final String internalUse;
  final Recipe recipe;
  final List<String>? missingIngredients;

  const CustomRecipeCard({
    super.key,
    required this.internalUse,
    required this.recipe,
    this.missingIngredients,
  });

  @override
  State<CustomRecipeCard> createState() => _CustomRecipeCardState();
}

class _CustomRecipeCardState extends State<CustomRecipeCard> {
  bool isOwner = false;
  List<String>? uniqueIngredients = [];
  @override
  void initState() {
    checkAuthenticationStatus();
    uniqueIngredients = widget.missingIngredients?.toSet().toList();
    super.initState();
  }

  Future<void> checkAuthenticationStatus() async {
    String getCurrentUserId = await UserService().getCurrentUserId();

    setState(() {
      isOwner = widget.recipe.userId.contains(getCurrentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final recipeImage = '${Constants.imageURL}/${widget.recipe.recipeImage}';
    return Container(
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
                      const SizedBox(width: 5), // Adjust the spacing as needed
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

                      Text(
                        Constants.calculateMembershipDuration(
                            context, widget.recipe.date), // Format the date
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
                    widget.recipe.difficulty,
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
                        Expanded(
                          child: Text(
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
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.favorite_border),
                            Text(
                              widget.recipe.likedBy.length.toString(),
                            ),
                            if (isOwner &&
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
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                  // You can add more widgets here if needed
                  if (widget.missingIngredients != null &&
                      widget.missingIngredients!.isNotEmpty)
                    TextButton(
                      onPressed: () => _showMissingIngredientsDialog(
                          context, uniqueIngredients!),
                      child: Text(
                        '${AppLocalizations.of(context).translate('Missing Ingredients')}: ${uniqueIngredients?.length}',
                        style: TextStyle(color: Colors.red.withOpacity(0.7)),
                      ),
                    ),
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
    );
  }

  void _showMissingIngredientsDialog(
      BuildContext context, List<String> missingIngredients) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context).translate('Missing Ingredients')),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: missingIngredients
                  .map((ingredient) => ListTile(
                          title: Text(
                        ingredient,
                        style: TextStyle(color: Colors.red.withOpacity(0.7)),
                      )))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
