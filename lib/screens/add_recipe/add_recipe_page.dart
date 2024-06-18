import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/success_add_recipe_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/utils/user_agreement_service.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/calories_row.dart';
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
  TextEditingController caloriesTextController = TextEditingController();
  TextEditingController priceRecipeController = TextEditingController();

  late int tappedCategoryIndex = -1;

  String _selectedDifficulty = 'Easy';

  String selectedCategoryColor = '';
  String selectedCategoryId = '';
  String selectedCategoryFont = '';
  String selectedCategoryName = '';
  double selectedRecipePremiumPrice = 0;

  late String recipeTitleValue;
  late String descriptionValue;
  late String servingValue;
  late String prepDurationValue;
  late String cookDurationValue;
  late String caloriesValue;

  bool imageIsPicked = false;
  late String currentPage;
  bool isTapped = false;
  bool selectedFromCategory = false;
  bool isForDiet = false;
  bool isForVegetarians = false;

  User user = Constants.defaultUser;
  List<bool> isAllChecked = [];
  bool isPremium = false;
  bool agreeToLicense = false;
  final UserAgreementService userAgreementService = UserAgreementService();

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

      caloriesTextController.text =
          widget.recipe!.calories ?? Constants.emptyField;

      priceRecipeController.text =
          double.parse(widget.recipe!.price.toString()).toString();

      _selectedDifficulty = widget.recipe!.difficulty!;

      // Populate ingredients text controllers
      ingredientsControllers.clear();
      for (var ingredient in widget.recipe!.ingredients ?? []) {
        TextEditingController controller =
            TextEditingController(text: ingredient);
        ingredientsControllers.add(controller);
      }

      // Populate instructions text controllers
      instructionControllers.clear();
      for (var instruction in widget.recipe!.instructions ?? []) {
        TextEditingController controller =
            TextEditingController(text: instruction);
        instructionControllers.add(controller);
      }

      // Populate cookingAdvice text controllers
      adviceControllers.clear();
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
              isPremium = widget.recipe!.isPremium;
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

  bool _allItemsValid() {
    bool isValid = tappedCategoryIndex >= 0;

    print('Validation result: $isValid'); // Debugging
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool isDesktop = Responsive.isDesktop(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    Map<String, String> difficultyMapping(BuildContext context) {
      return {
        'Easy': AppLocalizations.of(context).translate('Easy'),
        'Medium': AppLocalizations.of(context).translate('Medium'),
        'Hard': AppLocalizations.of(context).translate('Hard'),
        'Chef': AppLocalizations.of(context).translate('Chef'),
        'Michelin': AppLocalizations.of(context).translate('Michelin'),
      };
    }

    difficultyLevels = [
      AppLocalizations.of(context).translate('Easy'),
      AppLocalizations.of(context).translate('Medium'),
      AppLocalizations.of(context).translate('Hard'),
      AppLocalizations.of(context).translate('Chef'),
      AppLocalizations.of(context).translate('Michelin'),
    ];

    final difficultyMap = difficultyMapping(context);

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
                  const SizedBox(height: 50.0),
                  Row(
                    children: [
                      SectionTitle(
                        title:
                            '${AppLocalizations.of(context).translate('Category')}:',
                        isDesktop: isDesktop,
                      ),
                      const SizedBox(width: 15),
                      selectedCategoryColor.isNotEmpty
                          ? Icon(
                              MdiIcons.checkCircleOutline,
                              color: Colors.green.withOpacity(0.5),
                            )
                          : Container(),
                    ],
                  ),
                  categories.isEmpty
                      ? const Center(child: LinearProgressIndicator())
                      : SizedBox(
                          height: 50,
                          width: screenSize.width,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse
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
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      SectionTitle(
                        title: AppLocalizations.of(context).translate(isAndroid
                            ? 'Special Nutritions\nRecipe (Optional):'
                            : 'Special Nutritions Recipe (Optional):'),
                        isDesktop: isDesktop,
                      ),
                      const SizedBox(width: 15),
                      isForDiet || isForVegetarians
                          ? Expanded(
                              child: Icon(
                                MdiIcons.checkCircleOutline,
                                color: Colors.green.withOpacity(0.5),
                              ),
                            )
                          : Container(),
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
                      const SizedBox(width: 15),
                      imageIsPicked
                          ? Icon(
                              MdiIcons.checkCircleOutline,
                              color: Colors.green.withOpacity(0.5),
                            )
                          : Container(),
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
                  ListView.builder(
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
                              '${AppLocalizations.of(context).translate('Ingredient')} ${index + 1}',
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
                  ListView.builder(
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
                              '${AppLocalizations.of(context).translate('Instruction')} ${index + 1}',
                          borderColor: selectedCategoryColor.isNotEmpty
                              ? HexColor(selectedCategoryColor)
                              : null,
                          suffixIcon: index == 0 ? Icons.add : Icons.delete,
                          onSuffixIconPressed: index == 0
                              ? _addInstruction
                              : () => _removeInstruction(index),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          labelText: '',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CookingAdvicesRow(
                    adviceControllers: adviceControllers,
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: 20.0),
                  ListView.builder(
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
                              '${AppLocalizations.of(context).translate('Cooking Advices')} ${index + 1}',
                          borderColor: selectedCategoryColor.isNotEmpty
                              ? HexColor(selectedCategoryColor)
                              : null,
                          suffixIcon: index == 0 ? Icons.add : Icons.delete,
                          onSuffixIconPressed: index == 0
                              ? _addAdvice
                              : () => _removeAdvice(index),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          labelText: '',
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
                  CaloriesRow(
                    caloriesTextController: caloriesTextController,
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: caloriesTextController,
                    hintText: AppLocalizations.of(context)
                        .translate('Enter the total calories'),
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
                  SizedBox(
                    height: 50,
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
                                      widget.recipe!.difficulty = value;
                                      widget.recipe?.isPremium = isPremium;
                                    } else {
                                      _selectedDifficulty = value;
                                      if (_selectedDifficulty ==
                                              difficultyMap['Chef'] ||
                                          _selectedDifficulty ==
                                              difficultyMap['Michelin']) {
                                        isPremium = true;
                                      } else {
                                        isPremium = false;
                                      }
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
                                          ? Colors.orange
                                          : Colors.grey,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        value,
                                        style: TextStyle(
                                          color: (widget.isForEdit
                                                  ? widget.recipe?.difficulty ==
                                                      value
                                                  : _selectedDifficulty ==
                                                      value)
                                              ? Colors.orange
                                              : themeProvider.currentTheme ==
                                                      ThemeType.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (value == difficultyMap['Chef'] ||
                                          value == difficultyMap['Michelin'])
                                        Icon(
                                          MdiIcons.starOutline,
                                          color: Colors.orange,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepOrange, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: _allItemsValid()
                        ? () {
                            ingredients = getIngredients();
                            instructions = getInstructions();
                            cookingAdvices = getAdvices();
                            recipeTitleValue =
                                recipeTitleTextController.text.trim();
                            descriptionValue =
                                descriptionTextController.text.trim();
                            servingValue = servingTextController.text.trim();
                            prepDurationValue =
                                prepDurationTextController.text.trim();
                            cookDurationValue =
                                cookDurationTextController.text.trim();
                            caloriesValue = caloriesTextController.text.trim();

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  elevation: 0,
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                HexColor(selectedCategoryColor),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth: isDesktop
                                              ? 700
                                              : MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                                          top: Radius.circular(
                                                              16.0),
                                                        ),
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
                                                                fit: BoxFit
                                                                    .cover,
                                                                width:
                                                                    screenSize
                                                                        .width,
                                                                height: screenSize
                                                                        .height /
                                                                    4,
                                                              )
                                                            : Text(AppLocalizations
                                                                    .of(context)
                                                                .translate(
                                                                    'No Image Selected')),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              16.0),
                                                        ),
                                                        child: (imageIsPicked ||
                                                                (widget.isForEdit &&
                                                                    widget.recipe
                                                                            ?.recipeImage !=
                                                                        null))
                                                            ? (kIsWeb
                                                                ? Image.memory(
                                                                    uint8list,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: screenSize
                                                                        .width,
                                                                    height:
                                                                        screenSize.height /
                                                                            4,
                                                                  )
                                                                : Image.file(
                                                                    _imageFile!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: screenSize
                                                                        .width,
                                                                    height:
                                                                        screenSize.height /
                                                                            4,
                                                                  ))
                                                            : Container(
                                                                width:
                                                                    screenSize
                                                                        .width,
                                                                height: screenSize
                                                                        .height /
                                                                    4,
                                                                color: Colors
                                                                    .grey[200],
                                                                child: Center(
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .translate(
                                                                            'No Image Selected'),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'Recipe Title'),
                                                      style: const TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    Text(
                                                      recipeTitleValue
                                                              .isNotEmpty
                                                          ? recipeTitleValue
                                                          : AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'No Title Entered'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                        height: 20.0),
                                                    if (isForDiet ||
                                                        isForVegetarians)
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                'Special Nutritions Recipe:'),
                                                        style: const TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    if (isForDiet &&
                                                        !isForVegetarians)
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                'Diet Ready'),
                                                        style: const TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                    if (isForVegetarians &&
                                                        !isForDiet)
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                'Vegeterians Ready'),
                                                        style: const TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                    if (isForDiet &&
                                                        isForVegetarians)
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                'Diet and Vegeterian Ready'),
                                                        style: const TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                    if (isForDiet ||
                                                        isForVegetarians)
                                                      const SizedBox(
                                                          height: 16.0),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'Category'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      (widget.isForEdit &&
                                                              !isTapped
                                                          ? (widget.recipe?.categoryName ??
                                                                      '')
                                                                  .isNotEmpty
                                                              ? widget.recipe
                                                                      ?.categoryName ??
                                                                  ''
                                                              : AppLocalizations
                                                                      .of(
                                                                          context)
                                                                  .translate(
                                                                      'No Category Selected')
                                                          : selectedCategoryName
                                                                  .isNotEmpty
                                                              ? selectedCategoryName
                                                              : AppLocalizations
                                                                      .of(
                                                                          context)
                                                                  .translate(
                                                                      'No Category Selected')),
                                                      style: const TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'Description'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      descriptionValue
                                                              .isNotEmpty
                                                          ? descriptionValue
                                                          : AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'No Description Entered'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Serving'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      servingValue.isNotEmpty
                                                          ? servingValue
                                                          : AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'No Serving Info Entered'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'Preparation Duration'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      prepDurationValue
                                                              .isNotEmpty
                                                          ? prepDurationValue
                                                          : AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'No Preparation Duration Entered'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'Cooking Duration'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      cookDurationValue
                                                              .isNotEmpty
                                                          ? cookDurationValue
                                                          : AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'No Cooking Duration Entered'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    Text(
                                                      '${AppLocalizations.of(context).translate('Ingredients')}:',
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children:
                                                          ingredients.isNotEmpty
                                                              ? ingredients.map(
                                                                  (ingredient) {
                                                                  return Text(
                                                                    '- $ingredient',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16.0),
                                                                  );
                                                                }).toList()
                                                              : [
                                                                  Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .translate(
                                                                            'No Ingredients Added'),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16.0),
                                                                  ),
                                                                ],
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: instructions
                                                              .isNotEmpty
                                                          ? instructions.map(
                                                              (instruction) {
                                                              return Text(
                                                                '- $instruction',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16.0),
                                                              );
                                                            }).toList()
                                                          : [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        'No Instructions Added'),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16.0),
                                                              ),
                                                            ],
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'Advices:'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: cookingAdvices
                                                              .isNotEmpty
                                                          ? cookingAdvices
                                                              .map((advice) {
                                                              return Text(
                                                                '- $advice',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16.0),
                                                              );
                                                            }).toList()
                                                          : [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        'No Cooking Advices Added'),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16.0),
                                                              ),
                                                            ],
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'Calories'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      caloriesValue.isNotEmpty
                                                          ? caloriesValue
                                                          : AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'No Calories Info Entered'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'Difficulty:'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      _selectedDifficulty
                                                              .isNotEmpty
                                                          ? _selectedDifficulty
                                                          : AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'No Difficulty Selected'),
                                                      style: const TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    if (_selectedDifficulty ==
                                                            difficultyMap[
                                                                'Chef'] ||
                                                        _selectedDifficulty ==
                                                            difficultyMap[
                                                                'Michelin'])
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16.0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.blue[100],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.blue,
                                                              width: 2),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      'Enter Price for Premium Recipe'),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                                height: 8.0),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'Chef Level Recipe: €9.99 - €14.99'),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Colors
                                                                          .black54),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'Please set a price between €9.99 and €14.99 for Chef level recipes.'),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Colors
                                                                          .black54),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'Michelin Level Recipe: €14.99 - €19.99'),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Colors
                                                                          .black54),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'Please set a price between €14.99 and €19.99 for Michelin level recipes.'),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Colors
                                                                          .black54),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 8.0),
                                                            TextFormField(
                                                              controller:
                                                                  priceRecipeController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        'Price (€)'),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  try {
                                                                    selectedRecipePremiumPrice =
                                                                        double.parse(
                                                                            value);
                                                                  } catch (e) {
                                                                    // Handle error (e.g., show a message to the user)
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 16.0),
                                                            Row(
                                                              children: [
                                                                Checkbox(
                                                                  value:
                                                                      agreeToLicense,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      agreeToLicense =
                                                                          value ??
                                                                              false;
                                                                    });
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    _showLicenseAgreement(
                                                                        context);
                                                                  },
                                                                  child: Text(AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'License Agreement')),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      Constants.defaultPadding),
                                                  child: ElevatedButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors
                                                          .deepOrange, // Background color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    onPressed: agreeToLicense
                                                        ? () {
                                                            // Show the processing dialog
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  content: Row(
                                                                    children: [
                                                                      const CircularProgressIndicator(),
                                                                      const SizedBox(
                                                                          width:
                                                                              16),
                                                                      Text(AppLocalizations.of(
                                                                              context)
                                                                          .translate(
                                                                              'Processing...')),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                            Future<
                                                                bool> recipeOperation = widget
                                                                    .isForEdit
                                                                ? RecipeService()
                                                                    .updateRecipe(
                                                                    widget.recipe
                                                                            ?.id ??
                                                                        Constants
                                                                            .emptyField,
                                                                    recipeTitleValue
                                                                            .isEmpty
                                                                        ? widget.recipe?.recipeTitle ??
                                                                            Constants.emptyField
                                                                        : recipeTitleValue,
                                                                    ingredients
                                                                            .isEmpty
                                                                        ? widget.recipe?.ingredients ??
                                                                            []
                                                                        : ingredients,
                                                                    instructions
                                                                            .isEmpty
                                                                        ? widget.recipe?.instructions ??
                                                                            []
                                                                        : instructions,
                                                                    prepDurationValue
                                                                            .isEmpty
                                                                        ? widget.recipe?.prepDuration ??
                                                                            Constants.emptyField
                                                                        : prepDurationValue,
                                                                    cookDurationValue
                                                                            .isEmpty
                                                                        ? widget.recipe?.cookDuration ??
                                                                            Constants.emptyField
                                                                        : cookDurationValue,
                                                                    servingValue
                                                                            .isEmpty
                                                                        ? widget.recipe?.servingNumber ??
                                                                            Constants.emptyField
                                                                        : servingValue,
                                                                    _selectedDifficulty
                                                                            .isEmpty
                                                                        ? widget.recipe?.difficulty ??
                                                                            Constants.emptyField
                                                                        : _selectedDifficulty,
                                                                    user.username
                                                                            .isEmpty
                                                                        ? widget.recipe?.username ??
                                                                            Constants
                                                                                .emptyField
                                                                        : user
                                                                            .username,
                                                                    user.profileImage
                                                                            .isEmpty
                                                                        ? widget.recipe?.useImage ??
                                                                            Constants
                                                                                .emptyField
                                                                        : user
                                                                            .username,
                                                                    user.id,
                                                                    DateTime
                                                                        .now(),
                                                                    descriptionValue
                                                                            .isEmpty
                                                                        ? widget.recipe?.description ??
                                                                            Constants.emptyField
                                                                        : descriptionValue,
                                                                    selectedCategoryId
                                                                            .isEmpty
                                                                        ? widget.recipe?.categoryId ??
                                                                            Constants.emptyField
                                                                        : selectedCategoryId,
                                                                    selectedCategoryColor
                                                                            .isEmpty
                                                                        ? widget.recipe?.categoryColor ??
                                                                            Constants.emptyField
                                                                        : selectedCategoryColor,
                                                                    selectedCategoryFont
                                                                            .isEmpty
                                                                        ? widget.recipe?.categoryFont ??
                                                                            Constants.emptyField
                                                                        : selectedCategoryFont,
                                                                    selectedCategoryName
                                                                            .isEmpty
                                                                        ? widget.recipe?.categoryName ??
                                                                            Constants.emptyField
                                                                        : selectedCategoryName,
                                                                    [].isEmpty
                                                                        ? widget.recipe?.recomendedBy ??
                                                                            []
                                                                        : [],
                                                                    [],
                                                                    [],
                                                                    isForDiet,
                                                                    isForVegetarians,
                                                                    0,
                                                                    0,
                                                                    cookingAdvices
                                                                            .isEmpty
                                                                        ? widget.recipe?.cookingAdvices ??
                                                                            []
                                                                        : cookingAdvices,
                                                                    caloriesValue
                                                                            .isEmpty
                                                                        ? widget.recipe?.calories ??
                                                                            Constants.emptyField
                                                                        : caloriesValue,
                                                                    isPremium,
                                                                    selectedRecipePremiumPrice,
                                                                    [],
                                                                  )
                                                                : RecipeService()
                                                                    .createRecipe(
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
                                                                    DateTime
                                                                        .now(),
                                                                    descriptionValue,
                                                                    selectedCategoryId,
                                                                    selectedCategoryColor,
                                                                    selectedCategoryFont,
                                                                    selectedCategoryName,
                                                                    [],
                                                                    [],
                                                                    [],
                                                                    isForDiet,
                                                                    isForVegetarians,
                                                                    0,
                                                                    0,
                                                                    cookingAdvices,
                                                                    caloriesValue,
                                                                    isPremium,
                                                                    selectedRecipePremiumPrice,
                                                                    [],
                                                                  );

                                                            recipeOperation
                                                                .then((value) {
                                                              Navigator.pop(
                                                                  context);

                                                              if (value) {
                                                                _saveAgreementToBackend();
                                                                if (imageIsPicked) {
                                                                  if (_imageFile !=
                                                                          null ||
                                                                      uint8list
                                                                          .isNotEmpty) {
                                                                    RecipeService().uploadRecipeImage(
                                                                        _imageFile ??
                                                                            File(''),
                                                                        uint8list);
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text('${AppLocalizations.of(context).translate('Failed to ')} ${AppLocalizations.of(context).translate(widget.isForEdit ? 'update' : 'create')} ${AppLocalizations.of(context).translate('recipe')}'),
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator
                                                                    .pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          SuccessAddRecipePage(
                                                                              isForEdit: widget.isForEdit)),
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false,
                                                                );
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
                                                            }).catchError(
                                                                    (error) {
                                                              Navigator.pop(
                                                                  context);

                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      '${AppLocalizations.of(context).translate('Error:')} $error'),
                                                                ),
                                                              );
                                                            });
                                                          }
                                                        : null,
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              widget.isForEdit
                                                                  ? 'Update'
                                                                  : 'Save'),
                                                      style: TextStyle(
                                                          color: agreeToLicense
                                                              ? Colors.white
                                                              : Colors.grey),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        : null,
                    child: Text(
                      AppLocalizations.of(context).translate('Preview Recipe'),
                      style: TextStyle(
                          color: _allItemsValid() ? Colors.white : Colors.grey),
                    ),
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

  void _showLicenseAgreement(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                  AppLocalizations.of(context).translate('License Agreement')),
              content: Text(AppLocalizations.of(context).translate(
                  'By agreeing to the license agreement, you acknowledge that your cut will be 70%, while Foodryp will receive 30%. Do you agree to these terms?')),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context).translate('Close')),
                  onPressed: () {
                    setState(() {
                      agreeToLicense = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveAgreementToBackend() async {
    try {
      await userAgreementService.saveUserAgreement(
        '1.0',
        'By agreeing to the license agreement, you acknowledge that your cut will be 70%, while Foodryp will receive 30%. Do you agree to these terms?',
      );
      print('Agreement saved successfully');
    } catch (e) {
      print('Failed to save agreement: $e');
    }
  }
}
