// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/comment_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_provider.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
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


class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late bool isLiked = false;
  late List<Comment> comments = [];
  late List<String> commentUI = [];
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
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
        isLiked = widget.recipe.likedBy?.contains(getCurrentUserId) ?? false;
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = Responsive.isDesktop(context);
    final isAndroid = Constants.checiIfAndroid(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                fit: BoxFit
                                    .cover, // Fill the box while preserving the aspect ratio
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
                                child:
                                    _buildRecipeDetails(context, themeProvider),
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
                      // Back button positioned on top-left
                      if (isAndroid)
                        Positioned(
                          top: 16.0, // Adjust padding from top
                          left: 16.0, // Adjust padding from left
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(
                                context), // Handle back button press
                          ),
                        ),
                    ],
                  ),
                ),
                // Recipe details
                const SizedBox(height: 20),
                _buildRecipeDetails(context, themeProvider),
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
    );
  }

  Widget _buildRecipeDetails(
      BuildContext context, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.recipe.recipeTitle ?? Constants.emptyField,
            style: GoogleFonts.getFont(
              widget.recipe.categoryFont ?? Constants.emptyField,
              fontSize: Responsive.isDesktop(context)
                  ? Constants.desktopHeadingTitleSize
                  : Constants.mobileHeadingTitleSize,
              fontWeight: FontWeight.bold,
              color:
                  HexColor(widget.recipe.categoryColor ?? Constants.emptyField)
                      .withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            widget.recipe.description ?? Constants.emptyField,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 20.0),
          // Ingredients section

          Text(
            AppLocalizations.of(context).translate('Ingredients'),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ListView.builder(
              shrinkWrap:
                  true, // Prevent list view from taking unnecessary space
              itemCount: widget.recipe.ingredients?.length,
              itemBuilder: (context, index) {
                bool isMissing = widget.missingIngredients
                    .contains(widget.recipe.ingredients?[index]);
                return Text(
                  widget.recipe.ingredients?[index] ?? Constants.emptyField,
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
              }),
          const SizedBox(height: 20.0),
          // Like and save buttons
          if (isAuthenticated)
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Call the likeRecipe method when the favorite icon is pressed
                    if (isLiked) {
                      // If already liked, call dislikeRecipe to unlike
                      RecipeService()
                          .dislikeRecipe(widget.recipe.id ?? '')
                          .then((_) => setState(() {
                                // Update the UI state after the recipe is disliked
                                isLiked = false;
                              }))
                          .catchError((error) {
                        // Handle any errors that occur during the disliking process
                      });
                    } else {
                      // If not liked, call likeRecipe to like
                      RecipeService()
                          .likeRecipe(widget.recipe.id ?? '')
                          .then((_) => setState(() {
                                // Update the UI state after the recipe is liked
                                isLiked = true;
                              }))
                          .catchError((error) {
                        // Handle any errors that occur during the liking process
                      });
                    }
                  },
                  // Use conditional rendering to change the icon based on whether the recipe is liked
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                ),
                const SizedBox(width: 10.0),
                if (isAuthenticated)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.save),
                  ),
              ],
            ),
          const SizedBox(height: 20.0),
          // Steps section
          Text(
            AppLocalizations.of(context).translate('Steps'),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.recipe.instructions?.length,
            itemBuilder: (context, index) =>
                Text('${AppLocalizations.of(context).translate('Step')}'
                    '${index + 1}: ${widget.recipe.instructions?[index]}'),
          ),
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
                        style: const TextStyle(
                            color: Colors
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
                    log(text);
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
