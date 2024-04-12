// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/category_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminCategoryPage extends StatefulWidget {
  const AdminCategoryPage({Key? key}) : super(key: key);

  @override
  State<AdminCategoryPage> createState() => _AdminCategoryPageState();
}

class _AdminCategoryPageState extends State<AdminCategoryPage> {
  late TextEditingController _nameController;
  List<String> _fontNames = [];
  List<String> uniqueFontNames = [];
  String? _selectedFont;
  String? _selectedTextFieldName;
  String _selectedLanguage = 'english';
  late Color _selectedColor = Colors.blue; // Default color
  late File? _imageFile = File('');
  late Uint8List uint8list = Uint8List(0);
  String? _getCategoryID;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _fetchGoogleFonts();
  }

  Future<void> _fetchGoogleFonts() async {
    String language = _selectedLanguage == 'english' ? 'english' : 'greek';
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/webfonts/v1/webfonts?sort=popularity&key=AIzaSyCbSLWZgc_vzpIMNATNWbj1VrbL4vNEnLs&subset=$language'));
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
        title: const Text('Add Category'),
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
                              const Text(
                                'Category:',
                                style: TextStyle(fontSize: 16),
                              ),
                              CustomTextField(
                                controller: _nameController,
                                hintText: 'Enter category name',
                                labelText: '',
                                onChanged: (value) {
                                  // Handle text changes here
                                  _nameController.text = value;
                                },
                              ),
                              const SizedBox(height: 20),
                              DropdownButton<String>(
                                value: _selectedLanguage,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedLanguage = newValue!;
                                    _fetchGoogleFonts();
                                  });
                                },
                                items: <String>[
                                  'english',
                                  'greek'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
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
                                'Selected font: ${_selectedFont ?? 'None'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              if (_selectedFont != null)
                                const Text(
                                  'Font Preview:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              if (_selectedFont != null)
                                Text(
                                  _nameController.text,
                                  style: GoogleFonts.getFont(
                                    _selectedFont!,
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
            const Text('Category Color:'),
            ColorPicker(
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Category Image:'),
            SizedBox(
              height: 300,
              child: ImagePickerPreviewContainer(
                containerSize: screenSize.width,
                onImageSelected: (file, bytes) {
                  // Handle image selection
                  setState(() {
                    _imageFile = file;
                    uint8list = Uint8List.fromList(bytes);
                  });
                },
                gender: '', isFor: 'Other', // Add your gender here
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add category logic
                _showCategoryPreview(context, _nameController.text,
                    _selectedColor, _selectedFont);
                log(_nameController.text);
                log(_selectedColor.hex);
                log(_selectedFont ?? '');
              },
              child: const Text('Preview Category'),
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
                child: kIsWeb
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
                // Show SnackBar indicating category creation process
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        CircularProgressIndicator(), // Add a circular progress indicator
                        SizedBox(width: 16),
                        Text(AppLocalizations.of(context).translate(
                            'Creating category...')), // Text indicating category creation
                      ],
                    ),
                  ),
                );

// Call the createCategory method to create the category
                bool success = await CategoryService().createCategory(
                    categoryName, selectedFont!, selectedColor.hex, '', []);

                if (success) {
                  // Once the category creation process is complete, hide the SnackBar
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  // Show a SnackBar indicating category creation success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).translate(
                          'Category created successfully')), // Show category creation success message
                    ),
                  );

                  // Upload the category image
                  CategoryService().uploadCategoryImage(_imageFile!, uint8list);
                  CategoryService().removeCategoryIDLocally();
                  Navigator.pop(context); // Close the dialog
                } else {
                  // If there's an error during category creation, hide the SnackBar
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  // Show a SnackBar indicating category creation failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).translate(
                          'Failed to create category')), // Show category creation failure message
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
              child: const Text(
                'Save Category to server',
                style: TextStyle(color: Colors.white),
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
