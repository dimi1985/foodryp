import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DescriptionRow extends StatefulWidget {
  final TextEditingController descriptionTextController;
  final bool isDesktop;

  DescriptionRow({required this.descriptionTextController, required this.isDesktop});

  @override
  _DescriptionRowState createState() => _DescriptionRowState();
}

class _DescriptionRowState extends State<DescriptionRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SectionTitle(
          title: '${AppLocalizations.of(context).translate('Description')}:',
          isDesktop: widget.isDesktop,
        ),
        const SizedBox(
          width: 15,
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.descriptionTextController,
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
