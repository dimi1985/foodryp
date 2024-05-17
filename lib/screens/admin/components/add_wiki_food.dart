// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:foodryp/models/wikifood.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/wiki_food_service.dart';

class AddUpdateDeleteWikiFoodPage extends StatefulWidget {
  final Wikifood? wikifood;

  const AddUpdateDeleteWikiFoodPage({
    super.key,
    required this.wikifood,
  });

  @override
  _AddUpdateDeleteWikiFoodPageState createState() =>
      _AddUpdateDeleteWikiFoodPageState();
}

class _AddUpdateDeleteWikiFoodPageState
    extends State<AddUpdateDeleteWikiFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _textController = TextEditingController();
  final _sourceController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.wikifood?.title ?? Constants.emptyField;
    _textController.text = widget.wikifood?.text ?? Constants.emptyField;
    _sourceController.text = widget.wikifood?.source ?? Constants.emptyField;
  }

  Future<void> _createWikiFood() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await WikiFoodService().createWikiFood(
            _nameController.text, _textController.text, _sourceController.text);
        Navigator.pop(context, true);
      } catch (e) {
        print('Error creating wikifood: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateWikiFood() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await WikiFoodService().updateWikiFood(widget.wikifood?.id ?? '',
            _nameController.text, _textController.text, _sourceController.text);
        Navigator.pop(context, true); // Pass true to indicate success
      } catch (e) {
        print('Error updating wikifood: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteWikiFood() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await WikiFoodService().deleteWikiFood(widget.wikifood?.id ?? '');
      Navigator.pop(context, true); // Pass true to indicate success
    } catch (e) {
      print('Error deleting wikifood: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wikifood == null
            ? 'Add WikiFood'
            : 'Update/Delete WikiFood'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Text'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(labelText: 'Source'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a source';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      children: [
                        if (widget.wikifood == null)
                          ElevatedButton(
                            onPressed: _createWikiFood,
                            child: const Text('Add'),
                          ),
                        if (widget.wikifood != null) ...[
                          ElevatedButton(
                            onPressed: _updateWikiFood,
                            child: const Text('Update'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _deleteWikiFood,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Set the background color to red
                            ),
                            child: const Text('Delete'),
                          ),
                        ]
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
