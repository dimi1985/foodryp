import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';

class IngredientsAddContainer extends StatefulWidget {
    final Map<String, dynamic>? selectedCategory;
  const IngredientsAddContainer({Key? key, this.selectedCategory}) : super(key: key);

  @override
  _IngredientsAddContainerState createState() =>
      _IngredientsAddContainerState();
}

class _IngredientsAddContainerState extends State<IngredientsAddContainer> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  final ScrollController _scrollController = ScrollController();

  void _addIngredient() {
    setState(() {
      _controllers.add(TextEditingController());
    });

    log(_scrollController.position.maxScrollExtent.toString());

    // Scroll to the newly added ingredient
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _removeIngredient(int index) {
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
            hintText: 'Ingredient ${index + 1}',
            borderColor: widget.selectedCategory != null
                ? widget.selectedCategory!['color']
                : null,
            suffixIcon: index == 0 ? Icons.add : Icons.delete,
            onSuffixIconPressed: index == 0
                ? _addIngredient
                : () => _removeIngredient(index),
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
