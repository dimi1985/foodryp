import 'package:flutter/material.dart';

class ChangeFieldDialog extends StatefulWidget {
  final BuildContext context;
  final String title;
  final String hintText;
  final String newHintText;
  final void Function(String, String) onSave;
  final bool isForPassword;

  const ChangeFieldDialog({
    super.key,
    required this.context,
    required this.title,
    required this.hintText,
    required this.newHintText,
    required this.onSave,
    required this.isForPassword,
  });

  @override
  _ChangeFieldDialogState createState() => _ChangeFieldDialogState();
}

class _ChangeFieldDialogState extends State<ChangeFieldDialog> {
  late TextEditingController _controller;
  late TextEditingController _newController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _newController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: widget.isForPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : null,
            ),
            controller: _controller,
            obscureText: widget.isForPassword && _obscurePassword,
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.isForPassword)
            TextField(
              decoration: InputDecoration(
                hintText: widget.newHintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              controller: _newController,
              obscureText: widget.isForPassword && _obscurePassword,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Get the new field value from the text field
            String oldValue = _controller.text;
            String newValue = _newController.text;
            // Call the onSave callback
            widget.onSave(oldValue, newValue);
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _newController.dispose();
    super.dispose();
  }
}
