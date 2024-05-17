import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InstructionsRow extends StatefulWidget {
  final List<TextEditingController> instructionControllers;
  final bool isDesktop;

  InstructionsRow(
      {required this.instructionControllers, required this.isDesktop});

  @override
  _InstructionsRowState createState() => _InstructionsRowState();
}

class _InstructionsRowState extends State<InstructionsRow> {
  @override
  void initState() {
    super.initState();
    for (var controller in widget.instructionControllers) {
      controller.addListener(_onInstructionsChanged);
    }
  }

  @override
  void dispose() {
    for (var controller in widget.instructionControllers) {
      controller.removeListener(_onInstructionsChanged);
    }
    super.dispose();
  }

  void _onInstructionsChanged() {
    setState(() {});
  }

  bool _hasNonEmptyInstruction() {
    for (var controller in widget.instructionControllers) {
      if (controller.text.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SectionTitle(
          title:
              '${AppLocalizations.of(context).translate('Add Instructions')}:',
          isDesktop: widget.isDesktop,
        ),
        const SizedBox(
          width: 15,
        ),
        _hasNonEmptyInstruction()
            ? Icon(
                MdiIcons.checkCircleOutline,
                color: Colors.green.withOpacity(0.5),
              )
            : Container(),
      ],
    );
  }
}
