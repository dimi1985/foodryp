import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RecipeTitleRow extends StatefulWidget {
  final TextEditingController recipeTitleTextController;
  final bool isDesktop;

  RecipeTitleRow({required this.recipeTitleTextController, required this.isDesktop});

  @override
  _RecipeTitleRowState createState() => _RecipeTitleRowState();
}

class _RecipeTitleRowState extends State<RecipeTitleRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SectionTitle(
          title: '${AppLocalizations.of(context).translate('Recipe Title')}:',
          isDesktop: widget.isDesktop,
        ),
        const SizedBox(
          width: 15,
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.recipeTitleTextController,
          builder: (context, value, child) {
            return value.text.isNotEmpty
                ? Icon(
                    MdiIcons.checkCircleOutline,
                    color: Colors.green.withOpacity(0.5),
                  )
                : Container();
          },
        ),
      ],
    );
  }
}
