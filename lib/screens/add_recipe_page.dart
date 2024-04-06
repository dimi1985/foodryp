import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_container.dart';
import 'package:foodryp/widgets/CustomWidgets/ingredients_add_container.dart';
import 'package:foodryp/widgets/CustomWidgets/instructions_add_container.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:foodryp/widgets/category_listView.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  Map<String, dynamic>? _selectedCategory; // Currently selected category

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

                  SizedBox(
                    height: 50,
                    width: screenSize.width,
                    child: CategoryListView(
                      categories: DemoData.categories,
                      onTap: (category) {
                        setState(() {
                          _selectedCategory =
                              category; // Update the selected category
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
                    borderColor: _selectedCategory != null
                        ? _selectedCategory!['color']
                        : null,
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'Description:',
                    isDesktop: isDesktop,
                  ),

                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'Description',
                    borderColor: _selectedCategory != null
                        ? _selectedCategory!['color']
                        : null,
                  ),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'Image Selection:',
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: Responsive.isDesktop(context) ? 350 : 200,
                    child: ImagePickerContainer(
                      containerSize: Responsive.isDesktop(context)
                          ? 600
                          : screenSize.width, onImageSelected: (File ) {  },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SectionTitle(
                    title: 'Add Ingredients:',
                    isDesktop: isDesktop,
                  ),

                  IngredientsAddContainer(selectedCategory: _selectedCategory),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'Add Instructions:',
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                   InstructionsAddContainer(selectedCategory: _selectedCategory),
                  const SizedBox(height: 20.0),

                  SectionTitle(
                    title: 'How many people is this food for ?:',
                    isDesktop: isDesktop,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextField(
                    controller: TextEditingController(),
                    hintText: 'Serves  2-4 ',
                    borderColor: _selectedCategory != null
                        ? _selectedCategory!['color']
                        : null,
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
                    borderColor: _selectedCategory != null
                        ? _selectedCategory!['color']
                        : null,
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
                    borderColor: _selectedCategory != null
                        ? _selectedCategory!['color']
                        : null,
                  ),
                  const SizedBox(height: 20.0),

                  ElevatedButton(
                    onPressed: () {},
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
