// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';

class InstructionsAddContainer extends StatefulWidget {

      final Map<String, dynamic>? selectedCategory;

  const InstructionsAddContainer({super.key, this.selectedCategory});

  @override
  _InstructionsAddContainerState createState() => _InstructionsAddContainerState();
}

class _InstructionsAddContainerState extends State<InstructionsAddContainer> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  final ScrollController _scrollController = ScrollController();

  void _addInstruction() {
    setState(() {
      _controllers.add(TextEditingController());
    });

    // Scroll to the newly added instruction
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _removeInstruction(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: _controllers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == _controllers.length - 1 ? 16.0 : 8.0,
          ),
          child: CustomTextField(
          controller: _controllers[index],
          hintText: 'Instruction ${index + 1}',
           borderColor: widget.selectedCategory != null
                ? widget.selectedCategory!['color']
                : null,
          suffixIcon: index == 0 ? Icons.add : Icons.delete,
          onSuffixIconPressed: index == 0 ? _addInstruction : () => _removeInstruction(index),
          maxLines: null, // Allow multiple lines for instructions
          keyboardType: TextInputType.multiline,
                    ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
