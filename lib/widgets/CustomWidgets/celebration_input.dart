// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodryp/database/database_helper.dart';
import 'package:foodryp/models/celebration_day.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:intl/intl.dart';

class CelebrationInput extends StatefulWidget {
  const CelebrationInput({super.key});

  @override
  _CelebrationInputState createState() => _CelebrationInputState();
}

class _CelebrationInputState extends State<CelebrationInput> {
  final TextEditingController _textController = TextEditingController();
  DateTime? _selectedDate;
  final List<CelebrationDay> _celebrations = [];
  int? _currentlyEditingIndex;
  var db = getDatabase();

  @override
  void initState() {
    _loadCelebrations();
    super.initState();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _saveCelebration() async {
    final String enteredText = _textController.text;
    final DateTime? selectedDate = _selectedDate;

    if (enteredText.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter a description and select a date!')));
      return;
    }

    CelebrationDay newCelebration = CelebrationDay(
      description: enteredText,
      dueDate: selectedDate,
    );

    if (_currentlyEditingIndex != null) {
      // Update existing celebration
      _celebrations[_currentlyEditingIndex!] = newCelebration;
      await db.updateCelebration(newCelebration); // Update in the database
    } else {
      // Add new celebration
      _celebrations.add(newCelebration);
      await db.insertCelebration(newCelebration).then((value) {
        if (value != -1) {
          print('Celebration saved successfully: $newCelebration');
        } else {
         print('Failed to save celebration: $newCelebration');
        }
      }); // Insert into the database
    }

    _resetForm();
  }

  void _editCelebration(int index) {
    setState(() {
      _currentlyEditingIndex = index;
      _textController.text = _celebrations[index].description;
      _selectedDate = _celebrations[index].dueDate;
    });
  }

  void _resetForm() {
    setState(() {
      _textController.clear();
      _selectedDate = null;
      _currentlyEditingIndex = null;
    });
  }

  void _loadCelebrations() async {
    List<CelebrationDay> celebrations = await db.queryAllCelebrations();
    setState(() {
      _celebrations.clear(); // Clear existing celebrations
      _celebrations.addAll(celebrations); // Add celebrations from the database
    });
  }

  void _deleteCelebration(int index) async {
    if (index < 0 || index >= _celebrations.length) {
      // Index is out of range
      return;
    }

    final CelebrationDay celebrationToDelete = _celebrations[index];
    if (celebrationToDelete.id == null) {
      // Celebration ID is null, cannot delete
      print('Celebration ID is null, cannot delete.');
      return;
    }

    final int deletedCount =
        await db.deleteCelebration(celebrationToDelete.id!);
    if (deletedCount > 0) {
      // Celebration successfully deleted from the database
      print('Celebration deleted successfully');
      setState(() {
        _celebrations.removeAt(index); // Remove celebration from UI list
      });
    } else {
      // Failed to delete celebration from the database
      print('Failed to delete celebration');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.yellow[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.black),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Note: Your celebrations will be saved offline. Uninstalling the app will result in data loss.',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _celebrations.length,
            itemBuilder: (ctx, index) {
              var celebration = _celebrations[index];
              return ListTile(
                title: Text(celebration.description),
                subtitle: Text(DateFormat.yMd().format(celebration.dueDate)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editCelebration(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCelebration(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Text(
                _selectedDate == null
                    ? 'No Date Chosen!'
                    : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: _presentDatePicker,
              child: const Text('Choose Date',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Constants.backgroundColor)),
            )
          ],
        ),
        TextField(
          controller: _textController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: _saveCelebration,
          child: const Text('Save Celebration'),
        ),
        if (_currentlyEditingIndex != null)
          TextButton(
            onPressed: _resetForm,
            child: const Text('Cancel Edit'),
          ),
      ],
    );
  }
}
