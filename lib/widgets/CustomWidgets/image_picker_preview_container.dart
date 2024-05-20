import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
    required this.isFor,
    required this.isForEdit,
  });

  @override
  _ImagePickerPreviewContainerState createState() =>
      _ImagePickerPreviewContainerState();
}

class _ImagePickerPreviewContainerState
    extends State<ImagePickerPreviewContainer> {
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _imageIsPicked = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null && result.files.first.bytes != null) {
          setState(() {
            _imageBytes = result.files.first.bytes;
            _imageIsPicked = true;
          });
          widget.onImageSelected(File(''), _imageBytes!);
          log('Image picked for web: ${result.files.first.name}');
        }
      } else {
        final pickedFile = await ImagePicker().pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
            _imageIsPicked = true;
          });
          widget.onImageSelected(_imageFile!, []);
          log('Image picked for mobile: ${pickedFile.path}');
        }
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    log('Initial image path: ${widget.initialImagePath}');

    Widget buildPlaceholder() {
      if (widget.isFor.contains('Other')) {
        return Center(
          child: Icon(
            Icons.add_photo_alternate,
            size: widget.containerSize / 4,
            color: Colors.grey,
          ),
        );
      } else {
        return Image.asset(
          widget.gender.contains('female')
              ? 'assets/default_avatar_female.jpg'
              : 'assets/default_avatar_male.jpg',
          fit: BoxFit.cover,
        );
      }
    }

    Widget buildImage() {
      if (kIsWeb && _imageBytes != null) {
        return Image.memory(
          _imageBytes!,
          height: screenSize.height,
          width: screenSize.width,
          fit: BoxFit.cover,
        );
      } else if (_imageFile != null) {
        return Image.file(
          _imageFile!,
          height: screenSize.height,
          width: screenSize.width,
          fit: BoxFit.cover,
        );
      } else if (widget.initialImagePath != null &&
          widget.initialImagePath!.isNotEmpty) {
        return Image.network(
          widget.initialImagePath!,
          height: screenSize.height,
          width: screenSize.width,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            log('Error loading network image: $error');
            return buildPlaceholder();
          },
        );
      } else {
        return buildPlaceholder();
      }
    }

    return InkWell(
      onTap: () {
        if (widget.allowSelection) {
          _pickImage(ImageSource.gallery);
        }
      },
      child: Container(
        height: widget.containerSize,
        width: widget.containerSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _imageIsPicked ? buildImage() : buildImage(),
        ),
      ),
    );
  }
}
