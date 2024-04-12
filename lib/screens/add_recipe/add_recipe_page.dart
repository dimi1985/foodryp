import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:hexcolor/hexcolor.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final categoryService = CategoryService();
  List<CategoryModel> categories = [];
  late File? _imageFile = File('');
  late Uint8List uint8list = Uint8List(0);
  List<String> ingredients = [];
  List<String> instructions = [];
  Map<String, Color> difficultyColors = {};
  final List<TextEditingController> ingredientsControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> instructionControllers = [
    TextEditingController()
  ];

  TextEditingController recipeTitleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController servingTextController = TextEditingController();
  TextEditingController prepDurationTextController = TextEditingController();
  TextEditingController cookDurationTextController = TextEditingController();

  late int tappedCategoryIndex = 0;

  String _selectedDifficulty = 'Easy'; // Initial value

  String selectedCategoryColor = '';
  String selectedCategoryId = '';
  String selectedCategoryFont = '';
  late String recipeTitleValue;
  late String descriptionValue;
  late String servingValue;
  late String prepDurationValue;
  late String cookDurationValue;
  late User user;

  Future<void> fetchUserProfile() async {
    final userService = UserService();
    final userProfile = await userService.getUserProfile();
    setState(() {
      user = userProfile ??
          User(
            id: '',
            username: '',
            email: '',
            profileImage: '',
            gender: '',
            memberSince: null,
            role: '',
            recipes: [],
          );
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    fetchUserProfile();
  }

  Future<void> _fetchCategories() async {
    try {
      final categoriesGET = await categoryService.getAllCategories();
      setState(() {
        categories = categoriesGET;
      });
    } catch (error) {
      // Handle errors gracefully, e.g., show an error message
    }
  }

  void _addIngredient() {
    setState(() {
      ingredientsControllers.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredientsControllers.removeAt(index);
    });
  }

  void _addInstruction() {
    setState(() {
      instructionControllers.add(TextEditingController());
    });
  }

  void _removeInstruction(int index) {
    setState(() {
      instructionControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool isDesktop = Responsive.isDesktop(context);
    difficultyColors = {
      AppLocalizations.of(context).translate('Easy'): Colors.green,
      AppLocalizations.of(context).translate('Medium'): Colors.yellow,
      AppLocalizations.of(context).translate('Hard'): Colors.orange,
      AppLocalizations.of(context).translate('Chef'): Colors.red,
      AppLocalizations.of(context).translate('Michelin'): Colors.blue,
    };
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: Responsive.isDesktop(context) ? 600 : screenSize.width,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Form fields for recipe details
                  const SizedBox(height: 50.0),
                  //Get Categories
                  categories.isEmpty
                      ? const Center(
                          child: LinearProgressIndicator(),
                        )
                      : SizedBox(
                          height: 50,
                          width: screenSize.width,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                              },
                            ),
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                final isTapped = index == tappedCategoryIndex;

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      tappedCategoryIndex = index;
                                      if (isTapped ||
                                          tappedCategoryIndex == 0) {
                                        selectedCategoryColor = category.color;

                                        selectedCategoryId = category.id!;
                                        selectedCategoryFont = category.font;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          category.name,
                                          style: TextStyle(
                                            color: isTapped
                                                ? HexColor(category.color)
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),

                  const SizedBox(height: 50.0),
                  SectionTitle(
                    title:
                        '${AppLocalizations.of(context).translate('Recipe Title')}'
                        ':',
                    isDesktop: isDesktop,
                  ),

                  CustomTextField(
                    controller: recipeTitleTextController,
                    hintText:
                        AppLocalizations.of(context).translate('Recipe Title'),
                    labelText: '',
                    borderColor: selectedCategoryColor.isNotEmpty
                        ? HexColor(selectedCategoryColor)
                        : null,
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title:
                        '${AppLocalizations.of(context).translate('Description')}'
                        ':',
                    isDesktop: isDesktop,
                  ),

                  CustomTextField(
                    controller: descriptionTextController,
                    hintText:
                        AppLocalizations.of(context).translate('Description'),
                    labelText: '',
                    borderColor: selectedCategoryColor.isNotEmpty
                        ? HexColor(selectedCategoryColor)
                        : null,
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: AppLocalizations.of(context)
                        .translate('Image Selection:'),
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: Responsive.isDesktop(context) ? 350 : 200,
                    child: ImagePickerPreviewContainer(
                        initialImagePath: '',
                        allowSelection: true,
                        containerSize: Responsive.isDesktop(context)
                            ? 600
                            : screenSize.width,
                        onImageSelected: (file, bytes) {
                          // Handle image selection
                          setState(() {
                            _imageFile = file;
                            uint8list = Uint8List.fromList(bytes);
                          });
                        },
                        gender: '',
                        isFor: 'Other'),
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: AppLocalizations.of(context)
                        .translate('Add Ingredients:'),
                    isDesktop: isDesktop,
                  ),

                  //Ingredient Section
                  ListView.builder(
                    // controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: ingredientsControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == ingredientsControllers.length - 1
                              ? 16.0
                              : 8.0,
                        ),
                        child: CustomTextField(
                          controller: ingredientsControllers[index],
                          hintText:
                              '${AppLocalizations.of(context).translate('Ingredient')}'
                              ' ${index + 1}',
                          borderColor: selectedCategoryColor.isNotEmpty
                              ? HexColor(selectedCategoryColor)
                              : null,
                          suffixIcon: index == 0 ? Icons.add : Icons.delete,
                          onSuffixIconPressed: index == 0
                              ? _addIngredient
                              : () => _removeIngredient(index),
                          labelText: '',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: AppLocalizations.of(context)
                        .translate('Add Instructions:'),
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  //Instruction section
                  ListView.builder(
                    // controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: instructionControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == instructionControllers.length - 1
                              ? 16.0
                              : 8.0,
                        ),
                        child: CustomTextField(
                          controller: instructionControllers[index],

                          hintText:
                              '${AppLocalizations.of(context).translate('Instruction')}'
                              ' ${index + 1}',
                          borderColor: selectedCategoryColor.isNotEmpty
                              ? HexColor(selectedCategoryColor)
                              : null,
                          suffixIcon: index == 0 ? Icons.add : Icons.delete,
                          onSuffixIconPressed: index == 0
                              ? _addInstruction
                              : () => _removeInstruction(index),
                          maxLines:
                              null, // Allow multiple lines for instructions
                          keyboardType: TextInputType.multiline, labelText: '',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: AppLocalizations.of(context)
                        .translate('How many people is this food for ?:'),
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: servingTextController,
                    hintText:
                        AppLocalizations.of(context).translate('Serves  2-4'),
                    labelText: '',
                    borderColor: selectedCategoryColor.isNotEmpty
                        ? HexColor(selectedCategoryColor)
                        : null,
                  ),
                  const SizedBox(height: 20.0),
                  SectionTitle(
                    title: AppLocalizations.of(context)
                        .translate('How long does it take to cook ?:'),
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: cookDurationTextController,
                    hintText: AppLocalizations.of(context)
                        .translate('45 minutes or 1h and 25 minutes e.t.c'),
                    labelText: '',
                    borderColor: selectedCategoryColor.isNotEmpty
                        ? HexColor(selectedCategoryColor)
                        : null,
                  ),

                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: AppLocalizations.of(context)
                        .translate('How long does the total preparation is ?:'),
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: prepDurationTextController,
                    hintText: AppLocalizations.of(context)
                        .translate('45 minutes or 1h and 25 minutes e.t.c'),
                    labelText: '',
                    borderColor: selectedCategoryColor.isNotEmpty
                        ? HexColor(selectedCategoryColor)
                        : null,
                  ),
                  const SizedBox(height: 20.0),
                  SectionTitle(
                    title: AppLocalizations.of(context).translate('Difficulty'),
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        for (String value in [
                          AppLocalizations.of(context).translate('Easy'),
                          AppLocalizations.of(context).translate('Medium'),
                          AppLocalizations.of(context).translate('Hard'),
                          AppLocalizations.of(context).translate('Chef'),
                          AppLocalizations.of(context).translate('Michelin')
                        ])
                          Row(
                            children: [
                              ChoiceChip(
                                label: Text(value),
                                selected: _selectedDifficulty == value,
                                backgroundColor: difficultyColors[
                                    value], // Set background color based on difficulty
                                selectedColor: Colors
                                    .white, // Optional: Set selected color
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedDifficulty =
                                        (selected ? value : null)!;
                                  });
                                },
                              ),
                              const SizedBox(
                                  width: 8), // Add space between the chips
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      //  previewIngredientsAndInstructions();
                      ingredients = getIngredients();
                      instructions = getInstructions();
                      recipeTitleValue = recipeTitleTextController.text;
                      descriptionValue = descriptionTextController.text;
                      servingValue = servingTextController.text;
                      prepDurationValue = prepDurationTextController.text;
                      cookDurationValue = cookDurationTextController.text;
                      // Use the values as needed

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            content: Container(
                              constraints: BoxConstraints(
                                maxWidth: Responsive.isDesktop(context)
                                    ? 700
                                    : MediaQuery.of(context).size.width,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(16.0)),
                                      child: kIsWeb
                                          ? Image.memory(uint8list)
                                          : Image.file(
                                              _imageFile!, // Replace with your image path
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 200.0,
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)
                                                    .translate('Recipe Title'),
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 32.0),
                                              Text(
                                                _selectedDifficulty,
                                                style: const TextStyle(
                                                    fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            recipeTitleValue,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            _selectedDifficulty,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('Description'),
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            descriptionValue,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('Serving'),
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            servingValue,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                                    'Preparation Duration'),
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            prepDurationValue,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('Cooking Duration'),
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            cookDurationValue,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Text(
                                            '${AppLocalizations.of(context).translate('Ingredients')}'
                                            ':',
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children:
                                                ingredients.map((ingredient) {
                                              return Text('- $ingredient',
                                                  style: const TextStyle(
                                                      fontSize: 16.0));
                                            }).toList(),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('Instructions:'),
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children:
                                                instructions.map((instruction) {
                                              return Text('- $instruction',
                                                  style: const TextStyle(
                                                      fontSize: 16.0));
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  // Show SnackBar indicating recipe creation process
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          CircularProgressIndicator(), // Add a circular progress indicator
                                          SizedBox(width: 16),
                                          Text(AppLocalizations.of(context)
                                              .translate(
                                                  'Creating recipe...')), // Text indicating recipe creation
                                        ],
                                      ),
                                    ),
                                  );

// Call the createRecipe method to create the recipe
                                  RecipeService()
                                      .createRecipe(
                                    recipeTitleValue,
                                    ingredients,
                                    instructions,
                                    prepDurationValue,
                                    cookDurationValue,
                                    _selectedDifficulty,
                                    servingValue,
                                    user.username,
                                    user.profileImage,
                                    user.id,
                                    DateTime.now(),
                                    descriptionValue,
                                    selectedCategoryId,
                                    selectedCategoryColor,
                                    selectedCategoryFont,
                                  )
                                      .then((value) {
                                    // Once the recipe creation process is complete, hide the SnackBar
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    if (value) {
                                      // Show a SnackBar indicating recipe creation success
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(AppLocalizations.of(
                                                  context)
                                              .translate(
                                                  'Recipe created successfully')), // Show recipe creation success message
                                        ),
                                      );

                                      // Upload the recipe image
                                      RecipeService().uploadRecipeImage(
                                          _imageFile!, uint8list);

                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    } else {
                                      // Show a SnackBar indicating recipe creation failure
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(AppLocalizations.of(
                                                  context)
                                              .translate(
                                                  'Failed to create recipe')), // Show recipe creation failure message
                                        ),
                                      );
                                    }
                                  }).catchError((error) {
                                    // If there's an error during recipe creation, hide the SnackBar
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    // Show a SnackBar indicating recipe creation failure due to error
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${AppLocalizations.of(context).translate('Error creating recipe:')} $error'), // Show recipe creation error message
                                      ),
                                    );
                                  });
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Preview Recipe'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> getIngredients() {
    return ingredientsControllers.map((controller) => controller.text).toList();
  }

  List<String> getInstructions() {
    return instructionControllers.map((controller) => controller.text).toList();
  }

  Widget _buildIconForDifficulty(String difficulty) {
    IconData iconData;
    switch (difficulty) {
      case 'Easy':
        iconData = Icons.thumb_up;
        break;
      case 'Medium':
        iconData = Icons.check_circle_outline;
        break;
      case 'Hard':
        iconData = Icons.warning;
        break;
      case 'Chef':
        iconData = Icons.restaurant;
        break;
      case 'Michelin':
        iconData = Icons.star;
        break;
      default:
        iconData = Icons.error;
    }
    return Icon(iconData);
  }
}
