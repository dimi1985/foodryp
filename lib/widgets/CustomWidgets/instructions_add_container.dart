// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_textField.dart';

class InstructionsAddContainer extends StatefulWidget {
final Function(String) onAddInstruction;
  final Function(int) onRemoveInstruction;


  const InstructionsAddContainer({super.key, required this.onAddInstruction, required this.onRemoveInstruction,});

  @override
  _InstructionsAddContainerState createState() => _InstructionsAddContainerState();
}

class _InstructionsAddContainerState extends State<InstructionsAddContainer> {
  final List<TextEditingController> _controllers = [TextEditingController()];
  // final ScrollController _scrollController = ScrollController();

   void _addInstruction() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    widget.onAddInstruction(_controllers.last.text); // Pass current text
  }

  void _removeInstruction(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
    widget.onRemoveInstruction(index); // Pass the removed index
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
                                  .translate('Instruction')}${index + 1}',
           borderColor: Colors.grey,
          suffixIcon: index == 0 ? Icons.add : Icons.delete,
          onSuffixIconPressed: index == 0 ? _addInstruction : () => _removeInstruction(index),
          maxLines: null, // Allow multiple lines for instructions
          keyboardType: TextInputType.multiline, labelText: '',
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
