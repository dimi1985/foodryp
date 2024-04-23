// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:foodryp/utils/contants.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPreviewContainer extends StatefulWidget {
  final double containerSize;
  final Function(File, List<int>) onImageSelected;
  final String? initialImagePath;
  final bool allowSelection;
  final String gender;
  final String isFor;
  final bool isForEdit;

  const ImagePickerPreviewContainer({
    super.key,
    required this.containerSize,
    required this.onImageSelected,
    this.initialImagePath,
    this.allowSelection = true,
    required this.gender,
    required this.isFor, required this.isForEdit,
  });

  @override
  _ImagePickerPreviewContainerState createState() =>
      _ImagePickerPreviewContainerState();
}

class _ImagePickerPreviewContainerState
    extends State<ImagePickerPreviewContainer> {
  late File? _imageFile = File('');
  late Uint8List uint8list = Uint8List(0);
  bool imageIsPicked = false;
  String finalProfileImageURL = '';

  @override
  void initState() {
    super.initState();

    finalProfileImageURL = ('${Constants.baseUrl}/${widget.initialImagePath}')
        .replaceAll('\\', '/');
  }

  Future<void> _pickImage(ImageSource source) async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;
        List<int> bytes = file.bytes!;
        widget.onImageSelected(File(''), bytes);
        setState(() {
          uint8list = Uint8List.fromList(bytes); // Update uint8list
          imageIsPicked = true;
        });
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          imageIsPicked = true;
        });
        widget.onImageSelected(_imageFile!, []);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return InkWell(
      onTap: () {
        if (widget.allowSelection && widget.onImageSelected != null) {
          _pickImage(ImageSource.gallery);
        } else {
          _showImagePreview(context, _imageFile);
        }
      },
      child: Container(
        height: widget.containerSize,
        width: widget.containerSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[200],
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: kIsWeb
                    ? imageIsPicked
                        ? Image.memory(uint8list)
                        : widget.initialImagePath == null || widget.initialImagePath!.isEmpty

                            ? widget.isFor.contains('Other')
                                ? Center(
                                    child: Icon(
                                      Icons.add_photo_alternate,
                                      size: widget.containerSize / 4,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Image.asset(
                                    widget.gender.contains('female')
                                        ? 'assets/default_avatar_female.jpg'
                                        : 'assets/default_avatar_male.jpg',
                                  )
                            : Image.network(
                                finalProfileImageURL,
                                fit: BoxFit.cover,
                              )
                    : isAndroid
                        ? imageIsPicked
                            ? Image.network(
                                finalProfileImageURL,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                widget.gender.contains('female')
                                    ? 'assets/default_avatar_female.jpg'
                                    : 'assets/default_avatar_male.jpg',
                              )
                        : Container())
            : Center(
                child: Icon(
                  Icons.add_photo_alternate,
                  size: widget.containerSize / 4,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, File? imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Hero(
            tag: 'imageHero',
            child: kIsWeb
                ? imageIsPicked ? Image.memory(
                    uint8list,
                    fit: BoxFit.cover,
                  ) :finalProfileImageURL == Constants.imageURL ? Image.asset(
                                widget.gender.contains('female')
                                    ? 'assets/default_avatar_female.jpg'
                                    : 'assets/default_avatar_male.jpg',
                              ): Image.network(
                                finalProfileImageURL,
                                fit: BoxFit.cover,
                              )
                : Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
