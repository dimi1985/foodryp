import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/recipe_deletion_confirmation_screen.dart';
import 'package:foodryp/utils/connectivity_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/widgets/shimmer_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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
    if (mounted) {
      setState(() {
        isAuthenticated = getCurrentUserId.isNotEmpty;
        isOwner = isAuthenticated &&
            (widget.recipe.userId?.contains(getCurrentUserId) ?? false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SizedBox(
      height: screenSize.height * 0.35,
      child: Column(
        children: [
          SizedBox(
            height: Constants.checiIfAndroid(context) ? 100 : 120,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Constants.defaultPadding),
                    topRight: Radius.circular(Constants.defaultPadding),
                  ),
                  child: ShimmerNetworkImage(
                    imageUrl: widget.recipe.recipeImage ?? Constants.emptyField,
                    fit: BoxFit.cover,
                    width: screenSize.width,
                    height: screenSize.height,
                    memCacheHeight: screenSize.height,
                    memCacheWidth: screenSize.width,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    children: [
                      Icon(
                        widget.recipe.isForDiet
                            ? MdiIcons.nutrition
                            : widget.recipe.isForVegetarians
                                ? MdiIcons.leaf
                                : null,
                        color: widget.recipe.isForDiet
                            ? Colors.blue
                            : widget.recipe.isForVegetarians
                                ? Colors.green
                                : null,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: HexColor(widget.recipe.categoryColor ??
                                  Constants.emptyField)
                              .withOpacity(0.7),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            widget.recipe.categoryName.toUpperCase(),
                            style: GoogleFonts.getFont(
                              widget.recipe.categoryFont ??
                                  Constants.emptyField,
                              fontSize: Responsive.isDesktop(context)
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
                      color: const Color.fromARGB(255, 221, 221, 221)
                          .withOpacity(0.5),
                      borderRadius:
                          BorderRadius.circular(10), // Add rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        widget.recipe.difficulty ?? Constants.emptyField,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //White Card
          SizedBox(
            height: screenSize.height * 0.20,
            child: Container(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              decoration: BoxDecoration(
                color: themeProvider.currentTheme == ThemeType.dark
                    ? const Color.fromARGB(255, 37, 36, 37)
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Constants.defaultPadding),
                  bottomRight: Radius.circular(Constants.defaultPadding),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ImagePickerPreviewContainer(
                        containerSize: 20,
                        onImageSelected: (file, list) {},
                        gender: Constants.emptyField,
                        isFor: Constants.emptyField,
                        initialImagePath: widget.recipe.useImage!,
                        isForEdit: false,
                        allowSelection: false,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.recipe.username ?? Constants.emptyField,
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
                        widget.recipe.recipeTitle?.toUpperCase() ??
                            Constants.emptyField,
                        style: GoogleFonts.getFont(
                          widget.recipe.categoryFont ?? Constants.emptyField,
                          fontSize: Responsive.isDesktop(context)
                              ? Constants.desktopFontSize
                              : Constants.mobileFontSize,
                          fontWeight: FontWeight.bold,
                          color: HexColor(widget.recipe.categoryColor ??
                                  Constants.emptyField)
                              .withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        widget.recipe.categoryName.toUpperCase(),
                        style: GoogleFonts.getFont(
                          widget.recipe.categoryFont ?? Constants.emptyField,
                          fontSize: Responsive.isDesktop(context)
                              ? Constants.desktopFontSize
                              : Constants.mobileFontSize,
                          fontWeight: FontWeight.bold,
                          color: HexColor(widget.recipe.categoryColor ??
                                  Constants.emptyField)
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  RatingBarIndicator(
                    rating: widget.recipe.rating,
                    itemBuilder: (context, index) => Icon(
                      MdiIcons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20,
                    direction: Axis.horizontal,
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
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
