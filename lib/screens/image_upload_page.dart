import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  String? _selectedFilename;
  late SharedPreferences _prefs; // SharedPreferences instance

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      List<int> bytes = file.bytes!;
      String filename = file.name;
      setState(() {
        _selectedFilename = filename;
      });
      _uploadImage(bytes, filename);
    }
  }

  Future<void> _uploadImage(List<int> bytes, String filename) async {
  _prefs = await SharedPreferences.getInstance();

  const baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://192.168.106.229:3000';
  String userId = _prefs.getString('userId') ?? '';

  String url = '$baseUrl/api/uploadProfilePic';
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.fields['userId'] = userId;
  request.files.add(http.MultipartFile.fromBytes('profilePicture', bytes, filename: filename));

  try {
    var streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200) {
      print('Successfully uploaded file');
    } else {
      print('Failed to upload file: ${streamedResponse.statusCode}');
    }
  } catch (e) {
    print('Error uploading file: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image (Web Only)'),
            ),
            SizedBox(height: 20),
            Text('Selected filename: $_selectedFilename'),
           
        
          ],
        ),
      ),
    );
  }
}
