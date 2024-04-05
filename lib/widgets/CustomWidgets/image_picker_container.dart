// ignore_for_file: avoid_init_to_null, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ImagePickerContainer extends StatefulWidget {
  final double containerSize;

  const ImagePickerContainer({
    Key? key,
    required this.containerSize,
  }) : super(key: key);

  @override
  _ImagePickerContainerState createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  late File? _imageFile = null;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
