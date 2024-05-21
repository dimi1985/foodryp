import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/bottom_nav_screen.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/cooking_advices_row.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:foodryp/widgets/CustomWidgets/cook_duration_row.dart';
import 'package:foodryp/widgets/CustomWidgets/description_row.dart';
import 'package:foodryp/widgets/CustomWidgets/ingredients_row.dart';
import 'package:foodryp/widgets/CustomWidgets/instructions_row.dart';
import 'package:foodryp/widgets/CustomWidgets/prep_duration_row.dart';
import 'package:foodryp/widgets/CustomWidgets/recipe_title_row.dart';
import 'package:foodryp/widgets/CustomWidgets/serving_row.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AddRecipePage extends StatefulWidget {
  final Recipe? recipe;
  final bool isForEdit;
  final User? user;
  const AddRecipePage(
      {super.key, this.recipe, required this.isForEdit, this.user});

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
  List<String> cookingAdvices = [];
  late List<String> difficultyLevels = [];
  final List<TextEditingController> ingredientsControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> instructionControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> adviceControllers = [
    TextEditingController()
  ];

  TextEditingController recipeTitleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController servingTextController = TextEditingController();
  TextEditingController prepDurationTextController = TextEditingController();
  TextEditingController cookDurationTextController = TextEditingController();

  late int tappedCategoryIndex = -1;

  String _selectedDifficulty = 'Easy';

  String selectedCategoryColor = '';
  String selectedCategoryId = '';
  String selectedCategoryFont = '';
  String selectedCategoryName = '';

  late String recipeTitleValue;
  late String descriptionValue;
  late String servingValue;
  late String prepDurationValue;
  late String cookDurationValue;

  bool imageIsPicked = false;
  late String currentPage;
  bool isTapped = false;
  bool selectedFromCategory = false;
  bool isForDiet = false;
  bool isForVegetarians = false;

  User user = Constants.defaultUser;
  List<bool> isAllChecked = [];

  Future<void> fetchUserProfile() async {
    final userService = UserService();
    final userProfile = await userService.getUserProfile();
    if (mounted) {
      setState(() {
        user = userProfile ?? Constants.defaultUser;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    fetchUserProfile();

    currentPage = 'Add Recipe';

    if (widget.recipe != null) {
      // Populate text controllers with recipe data for editing
      recipeTitleTextController.text =
          widget.recipe!.recipeTitle ?? Constants.emptyField;
      descriptionTextController.text =
          widget.recipe!.description ?? Constants.emptyField;
      servingTextController.text =
          widget.recipe!.servingNumber ?? Constants.emptyField;
      prepDurationTextController.text =
          widget.recipe!.prepDuration ?? Constants.emptyField;
      cookDurationTextController.text =
          widget.recipe!.cookDuration ?? Constants.emptyField;

      _selectedDifficulty = widget.recipe!.difficulty!;

      // Populate ingredients text controllers
      ingredientsControllers.clear(); // Clear existing controllers
      for (var ingredient in widget.recipe!.ingredients ?? []) {
        TextEditingController controller =
            TextEditingController(text: ingredient);
        ingredientsControllers.add(controller);
      }

      // Populate instructions text controllers
      instructionControllers.clear(); // Clear existing controllers
      for (var instruction in widget.recipe!.instructions ?? []) {
        TextEditingController controller =
            TextEditingController(text: instruction);
        instructionControllers.add(controller);
      }

      // Populate cookingAdvice text controllers
      adviceControllers.clear(); // Clear existing controllers
      for (var cookingAdvice in widget.recipe!.cookingAdvices ?? []) {
        TextEditingController controller =
            TextEditingController(text: cookingAdvice);
        adviceControllers.add(controller);
      }
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final categoriesGET = await categoryService.getAllCategories();
      if (mounted) {
        setState(() {
          categories = categoriesGET;
        });
      }
      if (widget.isForEdit) {
        int categoryIndex = categories.indexWhere(
            (category) => category.name == widget.recipe!.categoryName);

        if (categoryIndex != -1) {
          if (mounted) {
            setState(() {
              tappedCategoryIndex = categoryIndex;
              selectedCategoryColor = categories[categoryIndex].color;
              selectedCategoryId = categories[categoryIndex].id!;
              selectedCategoryFont = categories[categoryIndex].font;
              selectedCategoryName = categories[categoryIndex].name;

              // Set booleans for the chips
              isForDiet = widget.recipe!.isForDiet;
              isForVegetarians = widget.recipe!.isForVegetarians;
            });
          }
        }
      }
    } catch (error) {
      // Handle errors gracefully, e.g., show an error message
    }
  }

  void _addIngredient() {
    if (mounted) {
      setState(() {
        ingredientsControllers.add(TextEditingController());
      });
    }
  }

  void _removeIngredient(int index) {
    if (mounted) {
      setState(() {
        ingredientsControllers.removeAt(index);
      });
    }
  }

  void _addInstruction() {
    if (mounted) {
      setState(() {
        instructionControllers.add(TextEditingController());
      });
    }
  }

  void _removeInstruction(int index) {
    if (mounted) {
      setState(() {
        instructionControllers.removeAt(index);
      });
    }
  }

  void _addAdvice() {
    if (mounted) {
      setState(() {
        adviceControllers.add(TextEditingController());
      });
    }
  }

  void _removeAdvice(int index) {
    if (mounted) {
      setState(() {
        adviceControllers.removeAt(index);
      });
    }
  }

  bool _isRecipeTitleValid() {
    return recipeTitleTextController.text.isNotEmpty;
  }

  bool _isDescriptionValid() {
    return descriptionTextController.text.isNotEmpty;
  }

  bool _isImageSelected() {
    return imageIsPicked || widget.recipe?.recipeImage != '';
  }

  bool _areAllIngredientsValid() {
    for (var controller in ingredientsControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool _areAllInstructionsValid() {
    for (var controller in instructionControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool _isServingValid() {
    return servingTextController.text.isNotEmpty;
  }

  bool _isCookDurationValid() {
    return cookDurationTextController.text.isNotEmpty;
  }

  bool _isPrepDurationValid() {
    return prepDurationTextController.text.isNotEmpty;
  }

  bool _isDifficultySelected() {
    // ignore: unnecessary_null_comparison
    return _selectedDifficulty != null;
  }

  bool _allItemsValid() {
    return tappedCategoryIndex >= 0 &&
        _isRecipeTitleValid() &&
        _isDescriptionValid() &&
        _isImageSelected() &&
        _areAllIngredientsValid() &&
        _areAllInstructionsValid() &&
        _isServingValid() &&
        _isCookDurationValid() &&
        _isPrepDurationValid() &&
        _isDifficultySelected();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool isDesktop = Responsive.isDesktop(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    difficultyLevels = [
      AppLocalizations.of(context).translate('Easy'),
      AppLocalizations.of(context).translate('Medium'),
      AppLocalizations.of(context).translate('Hard'),
      AppLocalizations.of(context).translate('Chef'),
      AppLocalizations.of(context).translate('Michelin'),
    ];

    return Scaffold(
      appBar: widget.isForEdit
          ? AppBar(
              surfaceTintColor: themeProvider.currentTheme == ThemeType.dark
                  ? const Color.fromARGB(255, 37, 36, 37)
                  : Colors.white,
              title: Text(
                AppLocalizations.of(context).translate('Edit'),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 600 : screenSize.width,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Form fields for recipe details
                  const SizedBox(height: 50.0),
                  Row(
                    children: [
                      SectionTitle(
                        title:
                            '${AppLocalizations.of(context).translate('Category')}:',
                        isDesktop: isDesktop,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      selectedCategoryColor.isNotEmpty
                          ? Icon(
                              MdiIcons.checkCircleOutline,
                              color: Colors.green.withOpacity(0.5),
                            )
                          : Container()
                    ],
                  ),
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
                                isTapped = index == tappedCategoryIndex;
                                if (category.name == 'Uncategorized') {
                                  return const SizedBox.shrink();
                                }
                                return InkWell(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        tappedCategoryIndex = index;
                                        selectedCategoryColor = category.color;
                                        selectedCategoryId = category.id!;
                                        selectedCategoryFont = category.font;
                                        selectedCategoryName = category.name;
                                      });
                                      if (category.isForVegetarians) {
                                        isForVegetarians = true;
                                        isForDiet = false;
                                      } else if (category.isForDiet) {
                                        isForVegetarians = false;
                                        isForDiet = true;
                                      } else {
                                        isForVegetarians = false;
                                        isForDiet = false;
                                      }
                                    }
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
                  const SizedBox(height: 20.0),

                  Row(
                    children: [
                      SectionTitle(
                        title: AppLocalizations.of(context).translate(isAndroid
                            ? 'Special Nutritions\nRecipe (Optional):'
                            : 'Special Nutritions Recipe (Optional):'),
                        isDesktop: isDesktop,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      isForDiet || isForVegetarians
                          ? Expanded(
                              child: Icon(
                                MdiIcons.checkCircleOutline,
                                color: Colors.green.withOpacity(0.5),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ChoiceChip(
                        label: Text(
                            AppLocalizations.of(context).translate('For Diet')),
                        selected: isForDiet,
                        onSelected: (selected) {
                          setState(() {
                            isForDiet = selected;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ChoiceChip(
                          label: Text(AppLocalizations.of(context)
                              .translate('For Vegeterians')),
                          selected: isForVegetarians,
                          onSelected: (selected) {
                            setState(() {
                              isForVegetarians = selected;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  RecipeTitleRow(
                    recipeTitleTextController: recipeTitleTextController,
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: 20.0),
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

                  DescriptionRow(
                    descriptionTextController: descriptionTextController,
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: 20.0),
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

                  Row(
                    children: [
                      SectionTitle(
                        title: AppLocalizations.of(context)
                            .translate('Image Selection:'),
                        isDesktop: isDesktop,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      imageIsPicked
                          ? Icon(
                              MdiIcons.checkCircleOutline,
                              color: Colors.green.withOpacity(0.5),
                            )
                          : Container()
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: isDesktop ? 350 : 200,
                    child: ImagePickerPreviewContainer(
                      initialImagePath:
                          widget.isForEdit ? widget.recipe!.recipeImage : '',
                      allowSelection: true,
                      containerSize: isDesktop ? 600 : screenSize.width,
                      onImageSelected: (file, bytes) {
                        // Handle image selection
                        if (mounted) {
                          setState(() {
                            _imageFile = file;
                            uint8list = Uint8List.fromList(bytes);
                            imageIsPicked = true;
                          });
                        }
                      },
                      gender: '',
                      isFor: 'Other',
                      isForEdit: widget.isForEdit,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  IngredientsRow(
                    ingredientsControllers: ingredientsControllers,
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: 20.0),
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

                  InstructionsRow(
                    instructionControllers: instructionControllers,
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

                  const SizedBox(height: 20.0),

                  CookingAdvicesRow(
                    adviceControllers: adviceControllers,
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: 20.0),
                  //Instruction section
                  ListView.builder(
                    // controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: adviceControllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == adviceControllers.length - 1
                              ? 16.0
                              : 8.0,
                        ),
                        child: CustomTextField(
                          controller: adviceControllers[index],

                          hintText:
                              '${AppLocalizations.of(context).translate('Cooking Advices')}'
                              ' ${index + 1}',
                          borderColor: selectedCategoryColor.isNotEmpty
                              ? HexColor(selectedCategoryColor)
                              : null,
                          suffixIcon: index == 0 ? Icons.add : Icons.delete,
                          onSuffixIconPressed: index == 0
                              ? _addAdvice
                              : () => _removeAdvice(index),
                          maxLines:
                              null, // Allow multiple lines for instructions
                          keyboardType: TextInputType.multiline, labelText: '',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),

                  ServingRow(
                    servingTextController: servingTextController,
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
                  CookDurationRow(
                    cookDurationTextController: cookDurationTextController,
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

                  PrepDurationRow(
                    prepDurationTextController: prepDurationTextController,
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
                    title:
                        AppLocalizations.of(context).translate('Difficulty:'),
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 50, // Adjust height as needed
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (String value in difficultyLevels)
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (widget.isForEdit) {
                                        widget.recipe!.difficulty =
                                            value; // Update the model
                                      } else {
                                        _selectedDifficulty =
                                            value; // Update local state
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: (widget.isForEdit
                                                ? widget.recipe?.difficulty ==
                                                    value
                                                : _selectedDifficulty == value)
                                            ? Colors
                                                .blue // Change color if selected
                                            : Colors
                                                .grey, // Default color if not selected
                                      ),
                                    ),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: (widget.isForEdit
                                                ? widget.recipe?.difficulty ==
                                                    value
                                                : _selectedDifficulty == value)
                                            ? Colors
                                                .blue // Change color if selected
                                            : Colors
                                                .black, // Default color if not selected
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ), // Add space between the text items
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),
                  TextButton(
                    onPressed: _allItemsValid()
                        ? () {
                            //  previewIngredientsAndInstructions();
                            ingredients = getIngredients();
                            instructions = getInstructions();
                            cookingAdvices = getAdvices();
                            recipeTitleValue = recipeTitleTextController.text;
                            descriptionValue = descriptionTextController.text;
                            servingValue = servingTextController.text;
                            prepDurationValue = prepDurationTextController.text;
                            cookDurationValue = cookDurationTextController.text;
                            // Use the values as needed

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  elevation: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: HexColor(selectedCategoryColor),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth: isDesktop
                                          ? 700
                                          : MediaQuery.of(context).size.width,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          widget.isForEdit && !imageIsPicked
                                              ? Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    16.0)),
                                                    child: widget
                                                                .recipe
                                                                ?.recipeImage
                                                                ?.isNotEmpty ??
                                                            Constants
                                                                .defaultBoolValue
                                                        ? Image.network(
                                                            widget.recipe
                                                                    ?.recipeImage ??
                                                                Constants
                                                                    .emptyField,
                                                            fit: BoxFit.cover,
                                                            width: screenSize
                                                                .width,
                                                            height: screenSize
                                                                    .height /
                                                                4,
                                                          )
                                                        : Container(
                                                            child: Text(
                                                                'No Image'),
                                                          ),
                                                  ),
                                                )
                                              : Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    16.0)),
                                                    child: kIsWeb
                                                        ? Image.memory(
                                                            uint8list,
                                                            fit: BoxFit.cover,
                                                            width: screenSize
                                                                .width,
                                                            height: screenSize
                                                                    .height /
                                                                4)
                                                        : Image.file(
                                                            _imageFile!,
                                                            fit: BoxFit.cover,
                                                            width: screenSize
                                                                .width,
                                                            height: screenSize
                                                                    .height /
                                                                4,
                                                          ),
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Recipe Title'),
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 16.0),
                                                Text(
                                                  recipeTitleValue,
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                                const SizedBox(height: 20.0),
                                                if (isForDiet ||
                                                    isForVegetarians)
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Special Nutritions Recipe:'),
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                const SizedBox(height: 16.0),
                                                if (isForDiet &&
                                                    !isForVegetarians)
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Diet Ready'),
                                                    style: const TextStyle(
                                                        fontSize: 16.0),
                                                  ),
                                                if (isForVegetarians &&
                                                    !isForDiet)
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Vegeterians Ready'),
                                                    style: const TextStyle(
                                                        fontSize: 16.0),
                                                  ),
                                                if (isForDiet &&
                                                    isForVegetarians)
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Diet and Vegeterian Ready'),
                                                    style: const TextStyle(
                                                        fontSize: 16.0),
                                                  ),
                                                if (isForDiet ||
                                                    isForVegetarians)
                                                  const SizedBox(height: 16.0),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Category'),
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  widget.isForEdit && !isTapped
                                                      ? widget.recipe
                                                              ?.categoryName ??
                                                          ''
                                                      : selectedCategoryName,
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Description'),
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  descriptionValue,
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                                const SizedBox(height: 16.0),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Serving'),
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  servingValue,
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                                const SizedBox(height: 16.0),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Preparation Duration'),
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  prepDurationValue,
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                                const SizedBox(height: 16.0),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Cooking Duration'),
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  cookDurationValue,
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                                const SizedBox(height: 16.0),
                                                Text(
                                                  '${AppLocalizations.of(context).translate('Ingredients')}'
                                                  ':',
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: ingredients
                                                      .map((ingredient) {
                                                    return Text('- $ingredient',
                                                        style: const TextStyle(
                                                            fontSize: 16.0));
                                                  }).toList(),
                                                ),
                                                const SizedBox(height: 16.0),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Instructions:'),
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: instructions
                                                      .map((instruction) {
                                                    return Text(
                                                        '- $instruction',
                                                        style: const TextStyle(
                                                            fontSize: 16.0));
                                                  }).toList(),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Advices:'),
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: cookingAdvices
                                                      .map((advice) {
                                                    return Text('- $advice',
                                                        style: const TextStyle(
                                                            fontSize: 16.0));
                                                  }).toList(),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Difficulty:'),
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  _selectedDifficulty,
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                )
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  Constants.defaultPadding),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Show SnackBar indicating recipe creation or update process
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Row(
                                                        children: [
                                                          const CircularProgressIndicator(),
                                                          const SizedBox(
                                                              width: 16),
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(widget
                                                                        .isForEdit
                                                                    ? 'Updating recipe...'
                                                                    : 'Creating recipe...'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );

                                                  // Call the appropriate recipe service method based on whether it's for creation or update

                                                  Future<
                                                      bool> recipeOperation = widget
                                                          .isForEdit
                                                      ? RecipeService()
                                                          .updateRecipe(
                                                          widget.recipe?.id ??
                                                              '',
                                                          recipeTitleValue,
                                                          ingredients,
                                                          instructions,
                                                          prepDurationValue,
                                                          cookDurationValue,
                                                          servingValue,
                                                          _selectedDifficulty,
                                                          user.username,
                                                          user.profileImage,
                                                          user.id,
                                                          DateTime.now(),
                                                          descriptionValue,
                                                          selectedCategoryId,
                                                          selectedCategoryColor,
                                                          selectedCategoryFont,
                                                          selectedCategoryName,
                                                          [],
                                                          isForDiet,
                                                          isForVegetarians,
                                                          cookingAdvices,
                                                        )
                                                      : RecipeService().createRecipe(
                                                          recipeTitleValue,
                                                          ingredients,
                                                          instructions,
                                                          prepDurationValue,
                                                          cookDurationValue,
                                                          servingValue,
                                                          _selectedDifficulty,
                                                          user.username,
                                                          user.profileImage,
                                                          user.id,
                                                          DateTime.now(),
                                                          descriptionValue,
                                                          selectedCategoryId,
                                                          selectedCategoryColor,
                                                          selectedCategoryFont,
                                                          selectedCategoryName,
                                                          [],
                                                          [],
                                                          isForDiet,
                                                          isForVegetarians,
                                                          cookingAdvices);

                                                  // Handle the completion of the recipe operation
                                                  recipeOperation.then((value) {
                                                    // Hide the SnackBar
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();

                                                    if (value) {
                                                      // Show success SnackBar
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(AppLocalizations
                                                                  .of(context)
                                                              .translate(widget
                                                                      .isForEdit
                                                                  ? 'Recipe updated successfully'
                                                                  : 'Recipe created successfully')),
                                                        ),
                                                      );
                                                      if (imageIsPicked) {
                                                        if (_imageFile !=
                                                                null ||
                                                            uint8list
                                                                .isNotEmpty) {
                                                          RecipeService()
                                                              .uploadRecipeImage(
                                                                  _imageFile!,
                                                                  uint8list);
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  '${AppLocalizations.of(context).translate('Failed to ')} ${AppLocalizations.of(context).translate(widget.isForEdit ? 'update' : 'create')} ${AppLocalizations.of(context).translate('recipe')}'),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                      // Upload the recipe image if applicable

                                                      // Pop the current screen
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                isAndroid
                                                                    ? const BottomNavScreen()
                                                                    : const EntryWebNavigationPage()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false,
                                                      );
                                                    } else {
                                                      // Show failure SnackBar
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              '${AppLocalizations.of(context).translate('Failed to ')} ${AppLocalizations.of(context).translate(widget.isForEdit ? 'update' : 'create')} ${AppLocalizations.of(context).translate('recipe')}'),
                                                        ),
                                                      );
                                                    }
                                                  }).catchError((error) {
                                                    // Hide the SnackBar
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();

                                                    // Show error SnackBar
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            '${AppLocalizations.of(context).translate('Error:')} $error'),
                                                      ),
                                                    );
                                                  });
                                                },
                                                child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            widget.isForEdit
                                                                ? 'Update'
                                                                : 'Save')),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        : null,
                    child: Text(AppLocalizations.of(context)
                        .translate('Preview Recipe')),
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

  List<String> getAdvices() {
    return adviceControllers.map((controller) => controller.text).toList();
  }
}
