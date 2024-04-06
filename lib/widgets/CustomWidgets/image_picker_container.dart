// ignore_for_file: avoid_init_to_null, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ImagePickerContainer extends StatefulWidget {
  final double containerSize;
  final Function(File) onImageSelected;
  final String? initialImagePath; // Optional initial image path

  const ImagePickerContainer({
    super.key,
    required this.containerSize,
    required this.onImageSelected,
    this.initialImagePath,
  });

  @override
  _ImagePickerContainerState createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  late File? _imageFile = null;
  bool imageIsPicked = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null) {
      _imageFile = File(widget.initialImagePath!);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        imageIsPicked = true;
      });
      widget.onImageSelected(
          _imageFile!); // Pass selected image file to callback function
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return InkWell(
      onTap: () {
        _pickImage(
            ImageSource.gallery); // You can change to camera if you prefer
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
                    ? Image.network(
                        _imageFile!.path,
                        fit: BoxFit.cover,
                      )
                    : isAndroid
                        ? imageIsPicked
                            ? Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(_imageFile!.path)
                        : Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
              )
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
}
