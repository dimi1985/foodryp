// ignore_for_file: library_private_types_in_public_api
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
    required this.isFor,
    required this.isForEdit,
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

  @override
  void initState() {
    super.initState();
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
    Size screenSize = MediaQuery.of(context).size;
    bool isAndroid = Constants.checiIfAndroid(context);
    return InkWell(
      onTap: () {
        if (widget.allowSelection) {
          _pickImage(ImageSource.gallery);
        } else {
          return;
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
                        ? Image.memory(
                            uint8list,
                            height: screenSize.height,
                            width: screenSize.width,
                            fit: BoxFit.cover,
                          )
                        : widget.initialImagePath == null ||
                                widget.initialImagePath!.isEmpty
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
                                widget.initialImagePath!,
                                fit: BoxFit.cover,
                              )
                    : isAndroid
                        ? imageIsPicked
                            ? Image.file(
                                _imageFile!,
                                height: screenSize.height,
                                width: screenSize.width,
                                fit: BoxFit.cover,
                              )
                            : widget.initialImagePath == null ||
                                    widget.initialImagePath!.isEmpty
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
                                : Container()
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
}
