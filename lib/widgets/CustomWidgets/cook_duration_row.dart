import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CookDurationRow extends StatefulWidget {
  final TextEditingController cookDurationTextController;
  final bool isDesktop;

  CookDurationRow(
      {required this.cookDurationTextController, required this.isDesktop});

  @override
  _CookDurationRowState createState() => _CookDurationRowState();
}

class _CookDurationRowState extends State<CookDurationRow> {
  @override
  void initState() {
    super.initState();
    widget.cookDurationTextController.addListener(_onCookDurationChanged);
  }

  @override
  void dispose() {
    widget.cookDurationTextController.removeListener(_onCookDurationChanged);
    super.dispose();
  }

  void _onCookDurationChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        SectionTitle(
          title:
              AppLocalizations.of(context).translate('How long does it take to cook ?:'),
          isDesktop: widget.isDesktop,
        ),
        const SizedBox(
          width: 15,
        ),
        widget.cookDurationTextController.text.isNotEmpty
            ? Expanded(
              child: Icon(
                  MdiIcons.checkCircleOutline,
                  color: Colors.green.withOpacity(0.5),
                ),
            )
            : Container(),
      ],
    );
  }
}
