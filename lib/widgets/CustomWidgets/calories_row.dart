import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CaloriesRow extends StatefulWidget {
  final TextEditingController caloriesTextController;
  final bool isDesktop;

  CaloriesRow({required this.caloriesTextController, required this.isDesktop});

  @override
  _CaloriesRowState createState() => _CaloriesRowState();
}

class _CaloriesRowState extends State<CaloriesRow> {
  @override
  void initState() {
    super.initState();
    widget.caloriesTextController.addListener(_onCaloriesChanged);
  }

  @override
  void dispose() {
    widget.caloriesTextController.removeListener(_onCaloriesChanged);
    super.dispose();
  }

  void _onCaloriesChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    return Row(
      children: [
        SectionTitle(
          title: '${AppLocalizations.of(context).translate('Calories')}:',
          isDesktop: widget.isDesktop,
        ),
        const SizedBox(
          width: 15,
        ),
        widget.caloriesTextController.text.isNotEmpty
            ? Icon(
                MdiIcons.checkCircleOutline,
                color: Colors.green.withOpacity(0.5),
              )
            : Container(),
      ],
    );
  }
}
