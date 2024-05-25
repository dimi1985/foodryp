// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/wikifood.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/comment_service.dart';
import 'package:foodryp/utils/connectivity_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/utils/wiki_food_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/comment.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  final String internalUse;
  final List<String> missingIngredients;
  const RecipeDetailPage(
      {super.key,
      required this.recipe,
      required this.internalUse,
      required this.missingIngredients});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with SingleTickerProviderStateMixin {
  late bool isLiked = false;
  late List<Comment> comments = [];
  late List<String> commentUI = [];
  bool isAuthenticated = false;
  bool isLoading = false;
  int currentIndex = 0;
  double _currentRating = 0; // Initial rating
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.recipe.rating; // Set initial rating
    initLikeAndAuthStatus();
    fetchComments();
  }

  @override
  void didUpdateWidget(RecipeDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.recipe.id != oldWidget.recipe.id) {
      // If the recipe changes, update like status and comments
      initLikeAndAuthStatus();
      fetchComments();
    }
  }

  void initLikeAndAuthStatus() async {
    String getCurrentUserId = await UserService().getCurrentUserId();
    if (getCurrentUserId.isNotEmpty) {
      setState(() {
        isLiked =
            widget.recipe.recomendedBy?.contains(getCurrentUserId) ?? false;
        isAuthenticated = true;
      });
    }
  }

  void fetchComments() async {
    try {
      comments =
          await CommentService().getCommsentsByRecipeId(widget.recipe.id ?? '');
      setState(() {});
    } catch (error) {
      print('Failed to load comments: $error');
    }
  }

  void _updateRating(double rating) async {
    setState(() {
      _currentRating = rating;
    });
    await RecipeService()
        .rateRecipe(widget.recipe.id ?? Constants.emptyField, rating);
    // Set state to reflect that a rating has been made
    setState(() {
      _hasRated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = Responsive.isDesktop(context);
    final isAndroid = Constants.checiIfAndroid(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final connectionService = Provider.of<ConnectivityService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Details')),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            // Prevent default pop if needed, based on internal logic
            Navigator.pop(context, _hasRated);
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isDesktop)
                  Column(
                    children: [
                      const SizedBox(
                        height: 200,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Recipe image with optional Neomorphism effect
                          Expanded(
                            // Adjust the flex factor to control the width ratio between the image and the details
                            flex: 3, // for more space to image
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 10.0), // Add padding as needed
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Rounded corners
                                child: Image.network(
                                  widget.recipe.recipeImage ??
                                      Constants.emptyField,
                                  fit: BoxFit.cover,
                                  width: screenSize.width, // Take full width
                                  height: screenSize.height /
                                      2, // Adjust height as needed
                                ),
                              ),
                            ),
                          ),
                          if (isDesktop) const Spacer(),
                          // Recipe details
                          if (isDesktop)
                            Expanded(
                              flex:
                                  2, // for more space to details, adjust as necessary
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Align(
                                  alignment: Alignment
                                      .centerRight, // Align the details to the right
                                  child: _buildRecipeDetails(
                                    context,
                                    themeProvider,
                                    isDesktop,
                                    connectionService,
                                    isAndroid,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _displayCommentsSection(themeProvider),
                      const SizedBox(height: 20),
                      _buildCommentInput()
                    ],
                  ),

                // For non-desktop layouts, show the original layout
                if (!isDesktop) ...[
                  // Recipe image with optional Neomorphism effect
                  SizedBox(
                    height: 250.0, // Adjust height as needed
                    width: double.infinity, // Take full width
                    child: Stack(
                      children: [
                        // Background image with Neomorphism effect
                        DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: [
                              // Inner shadow
                              BoxShadow(
                                color: Colors.white.withOpacity(0.6),
                                blurRadius: 12.0,
                                spreadRadius: -5.0,
                              ),
                              // Outer shadow
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15.0,
                                spreadRadius: 2.0,
                                offset: const Offset(4.0, 4.0),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Image.network(
                            widget.recipe.recipeImage ?? Constants.emptyField,
                            width: screenSize.width, // Take full width
                            height: 250.0, // Adjust height as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Recipe details
                  const SizedBox(height: 20),
                  _buildRecipeDetails(context, themeProvider, isDesktop,
                      connectionService, isAndroid),
                  const SizedBox(height: 20),
                  _displayCommentsSection(themeProvider),
                  const SizedBox(height: 20),

                  _buildCommentInput(),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeDetails(BuildContext context, ThemeProvider themeProvider,
      bool isDesktop, ConnectivityService connectionService, bool isAndroid) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.recipe.recipeTitle ?? Constants.emptyField,
            style: connectionService.connectionStatus
                    .contains(ConnectivityResult.none)
                ? const TextStyle(fontFamily: 'Comfortaa')
                : GoogleFonts.getFont(
                    widget.recipe.categoryFont ?? Constants.emptyField,
                    fontSize: Responsive.isDesktop(context)
                        ? Constants.desktopHeadingTitleSize
                        : Constants.mobileHeadingTitleSize,
                    fontWeight: FontWeight.bold,
                    color: HexColor(
                            widget.recipe.categoryColor ?? Constants.emptyField)
                        .withOpacity(0.7),
                  ),
          ),
          const SizedBox(height: 10.0),

          Row(
            children: [
              isAuthenticated && kIsWeb && widget.internalUse != 'top_three' ||
                      isAndroid
                  ? RatingBar.builder(
                      initialRating: _currentRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, index) => MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () {
                            //method
                            _updateRating(index + 1.0);
                          },
                          child: Icon(
                            Icons.star,
                            color: index < _currentRating
                                ? Colors.amber
                                : Colors.grey,
                          ),
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        // This is triggered on drag; you might not need this if you handle updates via onTap
                      },
                    )
                  : RatingBarIndicator(
                      rating: widget.recipe.rating,
                      itemBuilder: (context, index) => Icon(
                        MdiIcons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                      direction: Axis.horizontal,
                    ),
              const SizedBox(
                width: 15,
              ),
              if (isAuthenticated)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                ),
            ],
          ),

          const SizedBox(height: 10.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: themeProvider.currentTheme == ThemeType.dark
                  ? const Color.fromARGB(255, 58, 57, 58)
                  : const Color.fromARGB(255, 224, 224, 224),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.recipe.description ?? Constants.emptyField,
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // Ingredients section
          Row(
            children: [
              Column(
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    AppLocalizations.of(context).translate('Servings'),
                    style: Constants.staticStyle,
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    widget.recipe.servingNumber.toString(),
                    style: TextStyle(
                      fontSize: isAndroid ? 14 : 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.currentTheme == ThemeType.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: isDesktop ? 40 : 20,
              ),
              Column(
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    AppLocalizations.of(context).translate('Prep Time'),
                    style: Constants.staticStyle,
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    widget.recipe.prepDuration.toString(),
                    style: TextStyle(
                      fontSize: isAndroid ? 14 : 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.currentTheme == ThemeType.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: isDesktop ? 40 : 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('Cook Time'),
                      style: Constants.staticStyle,
                    ),
                    Text(
                      widget.recipe.cookDuration.toString(),
                      style: TextStyle(
                        fontSize: isAndroid ? 14 : 20,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.currentTheme == ThemeType.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Text(
            AppLocalizations.of(context).translate('Ingredients'),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ListView.separated(
            shrinkWrap: true, // Prevent list view from taking unnecessary space
            itemCount: widget.recipe.ingredients?.length ?? 0,
            itemBuilder: (context, index) {
              bool isMissing = widget.missingIngredients
                  .contains(widget.recipe.ingredients?[index]);
              return Text(
                '- ${widget.recipe.ingredients?[index] ?? Constants.emptyField}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: isMissing
                      ? Colors.red
                      : themeProvider.currentTheme == ThemeType.dark
                          ? Colors.white
                          : Colors.black, // Red if missing, black otherwise
                  fontWeight: isMissing ? FontWeight.bold : FontWeight.normal,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
          const SizedBox(height: 20.0),

          // Steps section
          Text(
            AppLocalizations.of(context).translate('Steps'),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.recipe.instructions?.length ?? 0,
            itemBuilder: (context, index) =>
                Text('${AppLocalizations.of(context).translate('Step')}'
                    ' ${index + 1}: ${widget.recipe.instructions?[index]}'),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
          const SizedBox(height: 20.0),

          Text(
            AppLocalizations.of(context).translate('Cooking Advices'),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.recipe.cookingAdvices?.length ?? 0,
            itemBuilder: (context, index) =>
                Text('${AppLocalizations.of(context).translate('Advice')}'
                    '${index + 1}: ${widget.recipe.cookingAdvices?[index]}'),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
          const SizedBox(height: 10.0),
          Text(
            AppLocalizations.of(context).translate('Calories'),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(
            widget.recipe.calories ?? Constants.emptyField,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _displayCommentsSection(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).translate('Comments'),
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
          const SizedBox(height: 10.0),
          ListView.builder(
            physics:
                const NeverScrollableScrollPhysics(), // To disable scrolling within the ListView
            shrinkWrap:
                true, // Necessary to integrate ListView within another scrolling view
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Card(
                elevation: 0, // Adds a subtle shadow for depth
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0), // Adds space between cards
                child: ListTile(
                  leading: ImagePickerPreviewContainer(
                    initialImagePath: comment.useImage,
                    containerSize: 30,
                    onImageSelected: (image, bytes) {},
                    gender: Constants.emptyField,
                    isFor: Constants.emptyField,
                    isForEdit: false,
                    allowSelection: false,
                  ),
                  title: Row(
                    children: [
                      Text(
                        comment.username,
                        style: TextStyle(
                            color: themeProvider.currentTheme == ThemeType.dark
                                ? Colors.grey
                                : Colors
                                    .black54), // Lighter color for less emphasis
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '•', // Dot separator
                        style:
                            TextStyle(color: Colors.grey), // Color of the dot
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        Constants.calculateMembershipDuration(
                            context, comment.dateCreated), // Dot separator
                        style: const TextStyle(
                            color: Colors.grey), // Color of the dot
                      ),
                    ],
                  ),
                  subtitle: Text(
                    comments[index].text,
                    style: TextStyle(
                        color: themeProvider.currentTheme == ThemeType.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    final TextEditingController _commentController = TextEditingController();

    final bool isEnabled =
        isAuthenticated; // Input is enabled only if the user is authenticated

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isDesktop(context) ? 30 : 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              enabled: isEnabled,
              decoration: InputDecoration(
                labelText: isEnabled
                    ? AppLocalizations.of(context)
                        .translate('Write a comment...')
                    : AppLocalizations.of(context)
                        .translate('Only logged users can comment'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isEnabled
                ? () async {
                    String text = _commentController.text.trim();

                    await CommentService().createComment(
                        widget.recipe.id ?? '',
                        text,
                        widget.recipe.username ?? Constants.emptyField,
                        widget.recipe.useImage ?? '', []);
                    _commentController.clear();
                    setState(() {
                      fetchComments();
                    });
                  }
                : null, // Disable onPressed if the user is not authenticated
          ),
        ],
      ),
    );
  }
}
