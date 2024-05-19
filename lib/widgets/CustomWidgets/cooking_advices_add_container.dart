import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';

class CookingAdvicesAddContainer extends StatefulWidget {
  final Function(String) onAddAdvice;
  final Function(int) onRemoveAdvice;

  const CookingAdvicesAddContainer({
    Key? key,
    required this.onAddAdvice,
    required this.onRemoveAdvice,
  }) : super(key: key);

  @override
  _CookingAdvicesAddContainerState createState() =>
      _CookingAdvicesAddContainerState();
}

class _CookingAdvicesAddContainerState
    extends State<CookingAdvicesAddContainer> {
  final List<TextEditingController> _controllers = [TextEditingController()];

  void _addAdvice() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    widget.onAddAdvice(_controllers.last.text); // Pass current text
  }

  void _removeAdvice(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
    widget.onRemoveAdvice(index); // Pass the removed index
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _controllers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == _controllers.length - 1 ? 16.0 : 8.0,
          ),
          child: CustomTextField(
            controller: _controllers[index],
            hintText:
                '${AppLocalizations.of(context).translate('Advice')}${index + 1}',
            borderColor: Colors.grey,
            suffixIcon: index == 0 ? Icons.add : Icons.delete,
            onSuffixIconPressed: index == 0
                ? _addAdvice
                : () => _removeAdvice(index),
            maxLines: null, // Allow multiple lines for advices
            keyboardType: TextInputType.multiline,
            labelText: '',
          ),
        );
      },
    );
  }
}
