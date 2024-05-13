import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:hexcolor/hexcolor.dart';

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

  User user = Constants.defaultUser;

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
              selectedCategoryColor =
                  categories[categoryIndex].color ?? Constants.emptyField;
              selectedCategoryId = categories[categoryIndex].id!;
              selectedCategoryFont =
                  categories[categoryIndex].font ?? Constants.emptyField;
              selectedCategoryName =
                  categories[categoryIndex].name ?? Constants.emptyField;
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
              maxWidth: isDesktop ? 600 : screenSize.width,
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
                                isTapped = index == tappedCategoryIndex;
                                if (category.name == 'Uncategorized') {
                                  return const SizedBox.shrink();
                                }
                                return InkWell(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        tappedCategoryIndex = index;
                                        selectedCategoryColor =
                                            category.color ??
                                                Constants.emptyField;
                                        selectedCategoryId = category.id!;
                                        selectedCategoryFont = category.font ??
                                            Constants.emptyField;
                                        selectedCategoryName = category.name ??
                                            Constants.emptyField;
                                      });
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
                                          category.name ?? Constants.emptyField,
                                          style: TextStyle(
                                            color: isTapped
                                                ? HexColor(category.color ??
                                                    Constants.emptyField)
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
                    child: SizedBox(
                      height: 50, // Adjust height as needed
                      child: ListView(
                        scrollDirection: Axis.horizontal,
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
                                  selected: widget.isForEdit
                                      ? widget.recipe!.difficulty == value
                                      : _selectedDifficulty == value,
                                  backgroundColor: difficultyColors[
                                      value], // Set background color based on difficulty
                                  selectedColor: Colors
                                      .white, // Optional: Set selected color
                                  onSelected: (selected) {
                                    if (selected) {
                                      if (mounted) {
                                        setState(() {
                                          if (widget.isForEdit) {
                                            widget.recipe!.difficulty =
                                                value; // Update the model
                                          } else {
                                            _selectedDifficulty =
                                                value; // Update local state
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),
                                const SizedBox(
                                    width: 8), // Add space between the chips
                              ],
                            ),
                        ],
                      ),
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
                          log('selectedCategoryName in showDialog:  $selectedCategoryName');
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.isForEdit && !imageIsPicked
                                        ? Center(
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius
                                                  .vertical(
                                                  top: Radius.circular(16.0)),
                                              child: widget.recipe?.recipeImage
                                                      ?.isNotEmpty  ?? Constants.defaultBoolValue
                                                  ? Image.network(
                                                      widget.recipe?.recipeImage ?? Constants.emptyField,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(),
                                            ),
                                          )
                                        : Center(
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius
                                                  .vertical(
                                                  top: Radius.circular(16.0)),
                                              child: kIsWeb
                                                  ? Image.memory(uint8list)
                                                  : Image.file(
                                                      _imageFile!,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: 200.0,
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
                                                .translate('Recipe Title'),
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Text(
                                            recipeTitleValue,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('Category'),
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            widget.isForEdit && !isTapped
                                                ? widget.recipe?.categoryName ??
                                                    ''
                                                : selectedCategoryName,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                          const SizedBox(height: 8.0),
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
                                          const SizedBox(height: 8.0),
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
                                          const SizedBox(height: 8.0),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('Difficulty:'),
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            _selectedDifficulty,
                                            style:
                                                const TextStyle(fontSize: 16.0),
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
                                                    const SizedBox(width: 16),
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
                                                ? RecipeService().updateRecipe(
                                                    widget.recipe?.id ?? '',
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
                                                    []);

                                            // Handle the completion of the recipe operation
                                            recipeOperation.then((value) {
                                              // Hide the SnackBar
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();

                                              if (value) {
                                                // Show success SnackBar
                                                ScaffoldMessenger.of(context)
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
                                                  if (_imageFile != null || uint8list.isNotEmpty) {
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
                                                Navigator.of(context).pop();
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>

                                                          const EntryWebNavigationPage()),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              } else {
                                                // Show failure SnackBar
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        '${AppLocalizations.of(context).translate('Failed to ')} ${AppLocalizations.of(context).translate(widget.isForEdit ? 'update' : 'create')} ${AppLocalizations.of(context).translate('recipe')}'),
                                                  ),
                                                );
                                              }
                                            }).catchError((error) {
                                              // Hide the SnackBar
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();

                                              // Show error SnackBar
                                              ScaffoldMessenger.of(context)
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
                                                  .translate(widget.isForEdit
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
                    },
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
}
