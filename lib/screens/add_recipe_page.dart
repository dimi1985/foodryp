import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/responsive.dart';
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
  final List<TextEditingController> ingredientsControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> instructionControllers = [
    TextEditingController()
  ];

  TextEditingController recipeTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController servingTextController = TextEditingController();
  TextEditingController prepDurationTextController = TextEditingController();
  TextEditingController cookDurationTextController = TextEditingController();

  late int tappedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
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
                    title: 'Recipe Title:',
                    isDesktop: isDesktop,
                  ),

                  CustomTextField(
                    controller: recipeTextController,
                    hintText: 'Recipe Title',
                    labelText: '',
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'Description:',
                    isDesktop: isDesktop,
                  ),

                  CustomTextField(
                    controller: descriptionTextController =
                        TextEditingController(),
                    hintText: 'Description',
                    labelText: '',
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'Image Selection:',
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
                    title: 'Add Ingredients:',
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
                          hintText: 'Ingredient ${index + 1}',
                          borderColor: Colors.grey,
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
                    title: 'Add Instructions:',
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
                          hintText: 'Instruction ${index + 1}',
                          borderColor: Colors.grey,
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
                    title: 'How many people is this food for ?:',
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: servingTextController = TextEditingController(),
                    hintText: 'Serves  2-4 ',
                    labelText: '',
                  ),

                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'How long does it take to cook ?:',
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: cookDurationTextController =
                        TextEditingController(),
                    hintText: '45 minutes or 1h and 25 minutes e.t.c ',
                    labelText: '',
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'How long does the total preparation is ?:',
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: prepDurationTextController =
                        TextEditingController(),
                    hintText: '45 minutes or 1h and 25 minutes e.t.c ',
                    labelText: '',
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20.0),

                  ElevatedButton(
                    onPressed: () {
                      //  previewIngredientsAndInstructions();
                      List<String> ingredients = getIngredients();
                      List<String> instructions = getInstructions();
                      String recipeValue = recipeTextController.text;
                      String descriptionValue = descriptionTextController.text;
                      String servingValue = servingTextController.text;
                      String prepDurationValue =
                          prepDurationTextController.text;
                      String cookDurationValue =
                          cookDurationTextController.text;
                      // Use the values as needed
                      print('Ingredients: $ingredients');
                      print('Instructions: $instructions');
                      print('recipeValue: $recipeValue');
                      print('descriptionValue: $descriptionValue');
                      print('servingValue: $servingValue');
                      print('prepDurationValue: $prepDurationValue');
                      print('cookDurationValue: $cookDurationValue');
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
}
