import 'dart:developer';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/database/database_helper.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/screens/recipe_deletion_confirmation_screen.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

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

    final themeProvider = Provider.of<ThemeProvider>(context);
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
                    widget.recipe.recipeImage ?? Constants.emptyField,
                    fit: BoxFit.cover,
                    width: screenSize.width,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor(widget.recipe.categoryColor ??
                              Constants.emptyField)
                          .withOpacity(0.7),
                    ),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      widget.recipe.categoryName.toUpperCase(),
                      style: GoogleFonts.getFont(
                        widget.recipe.categoryFont ?? Constants.emptyField,
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
                      widget.recipe.username ?? Constants.emptyField,
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context) ? 16 : 12,
                        color: themeProvider.currentTheme == ThemeType.dark
                            ? Colors.white
                            : Colors.black,
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
                            : Colors.black,
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
                              : Colors.black,
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
                        style: GoogleFonts.getFont(
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
                    if (!isDesktop && widget.internalUse != 'MainScreen')
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
                    if (widget.recipe.isForDiet ||
                        widget.recipe.isForVegetarians)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                widget.recipe.isForDiet ? MdiIcons.nutrition:MdiIcons.leaf,
                                color: Colors.green.withOpacity(0.5),
                              ),
                              const SizedBox(width: 8),
                              _dynamicText(
                                  widget.recipe.isForDiet,
                                  widget.recipe.isForVegetarians,
                                  context,
                                  widget.internalUse,
                                  isDesktop),
                            ],
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (isOwner &&
                        isAuthenticated &&
                        widget.internalUse != 'MainScreen' &&
                        widget.internalUse != 'RecipePage' &&
                        widget.internalUse != 'AddWeeklyMenuPage' &&
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
                    Icon(
                      Icons.favorite_border,
                      color: themeProvider.currentTheme == ThemeType.light
                          ? Colors.black
                          : Colors.white,
                    ),
                    Text(
                      widget.recipe.likedBy?.length.toString() ??
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

  _dynamicText(bool isForDiet, bool isForVegetarians, BuildContext context,
      String internalUse, bool isDesktop) {
    if (isForDiet) {
      return widget.internalUse == 'MainScreen' ||
              (widget.internalUse == '' && isDesktop)
          ? Text(
              AppLocalizations.of(context).translate('For Diet'),
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.withOpacity(0.5)),
            )
          : Container();
    } else if (isForVegetarians) {
      return widget.internalUse == 'MainScreen' ||
              (widget.internalUse == '' && isDesktop)
          ? Text(
              AppLocalizations.of(context).translate('For Vegeterians'),
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.withOpacity(0.5)),
            )
          : Container();
    } else {
      widget.internalUse == 'MainScreen' ||
              (widget.internalUse == '' && isDesktop)
          ? Column(
              children: [
                Text(
                  AppLocalizations.of(context).translate('For Diet'),
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.withOpacity(0.5)),
                ),
                Text(
                  AppLocalizations.of(context).translate('For Vegeterians'),
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.withOpacity(0.5)),
                ),
              ],
            )
          : Container();
    }
  }
}
