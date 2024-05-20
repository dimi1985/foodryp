import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/recipe_deletion_confirmation_screen.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/connectivity_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';


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
  bool isAuthenticated = false;
  List<String> uniqueIngredients = [];

  @override
  void initState() {
    checkAuthenticationAndOwnershipStatus();
    if (mounted) {
      setState(() {
        updateUniqueIngredients();

      });
    }

    super.initState();
  }

  @override
  void didUpdateWidget(CustomRecipeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.missingIngredients != oldWidget.missingIngredients) {
      updateUniqueIngredients();
    }
  }

  void updateUniqueIngredients() {
    if (mounted) {
      setState(() {
        uniqueIngredients = widget.missingIngredients?.toSet().toList() ?? [];
      });
    }
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
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    bool isDesktop = Responsive.isDesktop(context);
 final connectionService = Provider.of<ConnectivityService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
log(widget.recipe.recipeImage ?? '');
    return Card(
      surfaceTintColor: Colors.white70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Constants.defaultPadding),
                    topRight: Radius.circular(Constants.defaultPadding),
                  ),
                  child: Image.network(
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
                      }
                    },
                    widget.recipe.recipeImage ?? Constants.emptyField,
                    fit: BoxFit.cover,
                    width: screenSize.width,
                    filterQuality: FilterQuality.none,
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
                            style:connectionService.connectionStatus.contains(ConnectivityResult.none) ? const TextStyle(
                              fontFamily: 'Comfortaa'
                            ): GoogleFonts.getFont(
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
          Container(
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

                  widget.recipe.useImage?.isEmpty ?? false ? Container():  ImagePickerPreviewContainer(
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
                      widget.recipe.username ?? Constants.emptyField,
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context) ? 16 : 12,
                        color: themeProvider.currentTheme == ThemeType.dark
                            ? Colors.white
                            : const Color.fromARGB(255, 70, 70, 70),
                      ),
                    ),
                    const SizedBox(width: 5), // Adjust the spacing as needed
                    Text(
                      '•',
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context)
                            ? Constants.desktopFontSize
                            : Constants.mobileFontSize,
                        color: themeProvider.currentTheme == ThemeType.dark
                            ? Colors.white
                            : const Color.fromARGB(255, 70, 70, 70),
                      ),
                    ),
                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        Constants.calculateMembershipDuration(context,
                            widget.recipe.dateCreated), // Format the date
                        style: TextStyle(
                          fontSize: Responsive.isDesktop(context)
                              ? Constants.desktopFontSize
                              : Constants.mobileFontSize,
                          color: themeProvider.currentTheme == ThemeType.dark
                              ? Colors.white
                              : const Color.fromARGB(255, 70, 70, 70),
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
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        widget.recipe.recipeTitle?.toUpperCase() ??
                            Constants.emptyField,
                        style:connectionService.connectionStatus.contains(ConnectivityResult.none) ? const TextStyle(
                              fontFamily: 'Comfortaa'
                            ): GoogleFonts.getFont(
                          widget.recipe.categoryFont ?? Constants.emptyField,
                          fontSize: Responsive.isDesktop(context)
                              ? Constants.desktopFontSize
                              : Constants.mobileFontSize,
                          fontWeight: FontWeight.bold,
                          color: HexColor(widget.recipe.categoryColor ??
                              Constants.emptyField),
                        ),
                      ),
                    ),
                    if (!isDesktop && widget.internalUse != 'MainScreen'&& widget.internalUse != 'RecipePage')
                      PopupMenuButton<String>(
                        onSelected: (String result) {
                          if (result == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddRecipePage(
                                  recipe: widget.recipe,
                                  isForEdit: true,
                                  user: null,
                                ),
                              ),
                            );
                          } else if (result == 'delete') {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDeletionConfirmationScreen(
                                recipe: widget.recipe,
                              ),
                            ));
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
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
                    if (isOwner &&
                        isAuthenticated &&
                        widget.internalUse != 'MainScreen' &&
                        widget.internalUse != 'RecipePage' &&
                        widget.internalUse != 'AddWeeklyMenuPage' &&
                        widget.internalUse != 'RecipePageByCategory' &&
                        isDesktop)
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
                        widget.internalUse != 'RecipePage' &&
                        widget.internalUse != 'RecipePageByCategory' &&
                        isDesktop)
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
                    Icon(
                      Icons.comment,
                      color: themeProvider.currentTheme == ThemeType.light
                          ? Colors.black
                          : Colors.white,
                    ),
                    Text(
                      widget.recipe.commentId?.length.toString() ??
                          Constants.emptyField,
                    ),
                  ],
                ),
                if (widget.internalUse == 'RecipePage' &&
                    (uniqueIngredients.isNotEmpty))
                  Text(
                      '${AppLocalizations.of(context).translate('There Are Missing Ingredients:')} ${uniqueIngredients.length}',
                      style: TextStyle(color: Colors.red.withOpacity(0.7))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
