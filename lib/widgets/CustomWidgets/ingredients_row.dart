import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IngredientsRow extends StatefulWidget {
  final List<TextEditingController> ingredientsControllers;
  final bool isDesktop;

  IngredientsRow({required this.ingredientsControllers, required this.isDesktop});

  @override
  _IngredientsRowState createState() => _IngredientsRowState();
}

class _IngredientsRowState extends State<IngredientsRow> {
  @override
  void initState() {
    super.initState();
    for (var controller in widget.ingredientsControllers) {
      controller.addListener(_onIngredientsChanged);
    }
  }

  @override
  void dispose() {
    for (var controller in widget.ingredientsControllers) {
      controller.removeListener(_onIngredientsChanged);
    }
    super.dispose();
  }

  void _onIngredientsChanged() {
    setState(() {});
  }

  bool _hasNonEmptyIngredient() {
    for (var controller in widget.ingredientsControllers) {
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
          title: '${AppLocalizations.of(context).translate('Add Ingredients')}:',
          isDesktop: widget.isDesktop,
        ),
        const SizedBox(
          width: 15,
        ),
        _hasNonEmptyIngredient()
            ? Icon(
                MdiIcons.checkCircleOutline,
                color: Colors.green.withOpacity(0.5),
              )
            : Container(),
      ],
    );
  }
}
