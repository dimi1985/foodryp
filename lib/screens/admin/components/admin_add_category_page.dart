// ignore_for_file: unused_field, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminAddCategoryPage extends StatefulWidget {
  final CategoryModel? category;
  final String? userRole;
  const AdminAddCategoryPage(
      {super.key, required this.category, required this.userRole});

  @override
  State<AdminAddCategoryPage> createState() => _AdminAddCategoryPageState();
}

class _AdminAddCategoryPageState extends State<AdminAddCategoryPage> {
  late TextEditingController _nameController;
  List<String> _fontNames = [];
  List<String> uniqueFontNames = [];
  String? _selectedFont;
  late Color _selectedColor = Colors.blue; // Default color
  late File? _imageFile = File('');
  late Uint8List uint8list = Uint8List(0);
  String? _getCategoryID;

  bool imageIsSelected = false;
  bool isForDiet = false;
  bool isForVegetarians = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _fetchGoogleFonts();

    // Check if the category is not empty
    if (widget.category != null) {
      // Populate the fields with existing category data
      _nameController.text = widget.category?.name ?? '';
    }
  }

  Future<void> _fetchGoogleFonts() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/webfonts/v1/webfonts?sort=popularity&key=AIzaSyCbSLWZgc_vzpIMNATNWbj1VrbL4vNEnLs'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _fontNames =
            List<String>.from(data['items'].map((item) => item['family']));
        uniqueFontNames = _fontNames.toSet().toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('Add Category Page')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 500,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('Category:'),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),

                              CustomTextField(
                                controller: _nameController,
                                hintText: AppLocalizations.of(context)
                                    .translate('Enter category name'),
                                labelText: '',
                                onChanged: (value) {
                                  // Handle text changes here
                                  _nameController.text = value;
                                },
                              ),
                              const SizedBox(height: 20),
                              // Add Chips for "Is for Diet" and "Is for Vegetarians"

                              Text(
                                AppLocalizations.of(context).translate(
                                    'Commit it as special category:'),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ChoiceChip(
                                    label: Text(AppLocalizations.of(context)
                                        .translate('Is for Diet')),
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
                                          .translate('Is for Vegetarians')),
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
                              const SizedBox(height: 20),
                              Expanded(
                                child: SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    itemCount: uniqueFontNames.length,
                                    itemBuilder: (context, index) {
                                      final fontName = uniqueFontNames[index];
                                      return ListTile(
                                        title: Text(
                                          fontName,
                                          style: TextStyle(
                                            color: fontName == _selectedFont
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _selectedFont = fontName;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${AppLocalizations.of(context).translate('Selected font:')} ${_selectedFont ?? AppLocalizations.of(context).translate('None')}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              if (_selectedFont != null)
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('Font Preview:'),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              if (_selectedFont != null)
                                Text(
                                  _nameController.text,
                                  style: GoogleFonts.getFont(
                                    _selectedFont ?? '',
                                    fontSize: 24,
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context).translate('Category Color:')),
            ColorPicker(
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context).translate('Category Image:')),
            SizedBox(
              height: 300,
              child: ImagePickerPreviewContainer(
                initialImagePath: widget.category != null
                    ? widget.category?.categoryImage
                    : '',
                containerSize: screenSize.width,
                allowSelection: true,
                onImageSelected: (file, bytes) {
                  // Handle image selection
                  setState(() {
                    _imageFile = file;
                    uint8list = Uint8List.fromList(bytes);
                    imageIsSelected = true;
                  });
                },
                gender: '',
                isFor: 'Other',
                isForEdit: false,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add category logic
                _showCategoryPreview(context, _nameController.text,
                    _selectedColor, _selectedFont);
              },
              child: Text(
                  AppLocalizations.of(context).translate('Preview Category')),
            ),
            const SizedBox(
              height: 20,
            ),
            if (widget.category != null)
              ElevatedButton(
                onPressed: () {
                  // Add category logic
                  CategoryService()
                      .deleteCategory(widget.category?.id ?? '')
                      .then((value) {
                    if (value) {}
                  });
                },
                child: Text(
                    AppLocalizations.of(context).translate('Delete Category')),
              ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPreview(
    BuildContext context,
    String categoryName,
    Color selectedColor,
    String? selectedFont,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            children: [
              Hero(
                tag: 'imageHero',
                child: widget.category != null && !imageIsSelected
                    ? Image.network(
                        widget.category?.categoryImage ?? Constants.emptyField,
                        fit: BoxFit.cover,
                      )
                    : kIsWeb
                        ? Image.memory(
                            uint8list,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  maxLines: 2,
                  categoryName.toUpperCase(),
                  style: GoogleFonts.getFont(
                    selectedFont ?? 'Roboto',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: selectedColor,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final bool isUpdating = widget.category != null;

                // Show SnackBar indicating category creation or update process
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const CircularProgressIndicator(), // Add a circular progress indicator
                        const SizedBox(width: 16),
                        Text(AppLocalizations.of(context).translate(
                          isUpdating
                              ? AppLocalizations.of(context)
                                  .translate('Updating category...')
                              : AppLocalizations.of(context)
                                  .translate('Creating category...'),
                        )), // Text indicating category creation or update
                      ],
                    ),
                  ),
                );

                // Perform category update if category exists, otherwise create category

                bool success = isUpdating
                    ? await CategoryService().updateCategory(
                        widget.category?.id ?? '',
                        categoryName,
                        selectedFont ?? widget.category?.font ?? '',
                        selectedColor.hex,
                        '',
                        [],
                        isForDiet,
                        isForVegetarians,
                        widget.userRole,
                      )
                    : await CategoryService().createCategory(
                        categoryName,
                        selectedFont ?? '',
                        selectedColor.hex,
                        '',
                        [],
                        isForDiet,
                        isForVegetarians,
                        widget.userRole,
                      );

                // Handle success or failure
                if (success) {
                  // Once the category creation or update process is complete, hide the SnackBar

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  // Show a SnackBar indicating success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).translate(
                        isUpdating
                            ? AppLocalizations.of(context)
                                .translate('Category updated successfully')
                            : AppLocalizations.of(context)
                                .translate('Category created successfully'),
                      )), // Show success message
                    ),
                  );
                  if ((!isUpdating && imageIsSelected ||
                          isUpdating && imageIsSelected) &&
                      success) {
                    // Upload the category image if creating a new category or image is selected during an update
                    CategoryService()
                        .uploadCategoryImage(_imageFile!, uint8list);
                  }

                  // Remove category ID locally

                  CategoryService().removeCategoryIDLocally();

                  // Close the dialog
                  Navigator.pop(context);
                } else {
                  // If there's an error during category creation or update, hide the SnackBar
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  // Show a SnackBar indicating failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).translate(
                        isUpdating
                            ? AppLocalizations.of(context)
                                .translate('Failed to update category')
                            : AppLocalizations.of(context)
                                .translate('Failed to create category'),
                      )), // Show failure message
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Adjust the value as needed
                ),
                backgroundColor: const Color.fromARGB(255, 84, 27, 218),
              ),
              child: Text(
                widget.category != null
                    ? AppLocalizations.of(context)
                        .translate('Update Category to server')
                    : AppLocalizations.of(context)
                        .translate('Save Category to server'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  getId(String? id) {
    setState(() {
      _getCategoryID = id;
    });
  }
}
