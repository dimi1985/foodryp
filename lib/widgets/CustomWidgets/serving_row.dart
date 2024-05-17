import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ServingRow extends StatefulWidget {
  final TextEditingController servingTextController;
  final bool isDesktop;

  ServingRow({required this.servingTextController, required this.isDesktop});

  @override
  _ServingRowState createState() => _ServingRowState();
}

class _ServingRowState extends State<ServingRow> {
  @override
  void initState() {
    super.initState();
    widget.servingTextController.addListener(_onServingChanged);
  }

  @override
  void dispose() {
    widget.servingTextController.removeListener(_onServingChanged);
    super.dispose();
  }

  void _onServingChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SectionTitle(
          title: AppLocalizations.of(context).translate('How many people is this food for ?:'),
          isDesktop: widget.isDesktop,
        ),
        const SizedBox(
          width: 15,
        ),
        widget.servingTextController.text.isNotEmpty
            ? Icon(
                MdiIcons.checkCircleOutline,
                color: Colors.green.withOpacity(0.5),
              )
            : Container(),
      ],
    );
  }
}
