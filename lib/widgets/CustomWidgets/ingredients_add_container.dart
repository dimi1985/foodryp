// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';

class IngredientsAddContainer extends StatefulWidget {
   final Function(String) onAddIngredient;
  final Function(int) onRemoveIngredient;

  const IngredientsAddContainer({super.key, required this.onAddIngredient, required this.onRemoveIngredient,});

  @override
  _IngredientsAddContainerState createState() =>
      _IngredientsAddContainerState();
}

class _IngredientsAddContainerState extends State<IngredientsAddContainer> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  // final ScrollController _scrollController = ScrollController();

  void _addIngredient() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    widget.onAddIngredient(_controllers.last.text); // Pass current text
  }

  void _removeIngredient(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
    widget.onRemoveIngredient(index); // Pass the removed index
  }
  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // controller: _scrollController,
      shrinkWrap: true,
      itemCount: _controllers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == _controllers.length - 1 ? 16.0 : 8.0,
          ),
          child: CustomTextField(
            controller: _controllers[index],
            hintText: '${AppLocalizations.of(context)
                                  .translate('Ingredient')}${index + 1}',
            borderColor: Colors.grey,
            suffixIcon: index == 0 ? Icons.add : Icons.delete,
            onSuffixIconPressed: index == 0
                ? _addIngredient
                : () => _removeIngredient(index), labelText: '',
          ),
        );
      },
    );
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   for (var controller in _controllers) {
  //     controller.dispose();
  //   }
  //   super.dispose();
  // }
}
