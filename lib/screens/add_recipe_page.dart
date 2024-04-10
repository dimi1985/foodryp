import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/ingredients_state.dart';
import 'package:foodryp/utils/instructions_state.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:foodryp/widgets/CustomWidgets/ingredients_add_container.dart';
import 'package:foodryp/widgets/CustomWidgets/instructions_add_container.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:foodryp/widgets/CustomWidgets/category_listView.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  CategoryModel? _selectedCategory; // Use CategoryModel type

  final categoryService = CategoryService();
  List<CategoryModel> _categories = [];
  late File? _imageFile = File('');
  late Uint8List uint8list = Uint8List(0);

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await categoryService.getAllCategories();
      setState(() {
        _categories = categories;
      });
    } catch (error) {
      print('Error fetching categories: $error');
      // Handle errors gracefully, e.g., show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool isDesktop = Responsive.isDesktop(context);
    final ingredientsState = Provider.of<IngredientsState>(context);
    final instructionsState = Provider.of<InstructionsState>(context);

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

                  _categories.isEmpty
                      ? const Center(
                          child: LinearProgressIndicator(),
                        )
                      : SizedBox(
                          height: 50,
                          width: screenSize.width,
                          child: CategoryListView(
                            categories: _categories,
                            onTap: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                        ),

                  const SizedBox(height: 50.0),

                  SectionTitle(
                    title: 'Recipe Title:',
                    isDesktop: isDesktop,
                  ),

                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'Recipe Title',
                    labelText: '',
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'Description:',
                    isDesktop: isDesktop,
                  ),

                  CustomTextField(
                    controller: TextEditingController(),
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

                  IngredientsAddContainer(
                      onAddIngredient: ingredientsState.addIngredient,
                      onRemoveIngredient: ingredientsState.removeIngredient),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'Add Instructions:',
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  InstructionsAddContainer(
                      onAddInstruction: instructionsState.addInstruction,
                      onRemoveInstruction: instructionsState.removeInstruction),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'How many people is this food for ?:',
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'Serves  2-4 ',
                    labelText: '',
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'How long does it take to cook ?:',
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: TextEditingController(),
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
                    controller: TextEditingController(),
                    hintText: '45 minutes or 1h and 25 minutes e.t.c ',
                    labelText: '',
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20.0),

                  ElevatedButton(
                    onPressed: () {
                      final ingredients = ingredientsState.ingredients;
                      final instructions = instructionsState.instructions;
                      // Process ingredients and instructions (e.g., save to database)

                      log(ingredients.toList().toString());
                      log(instructions.toList().toString());
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
}
