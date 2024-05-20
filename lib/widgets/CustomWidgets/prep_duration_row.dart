import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PrepDurationRow extends StatefulWidget {
  final TextEditingController prepDurationTextController;
  final bool isDesktop;

  PrepDurationRow({required this.prepDurationTextController, required this.isDesktop});

  @override
  _PrepDurationRowState createState() => _PrepDurationRowState();
}

class _PrepDurationRowState extends State<PrepDurationRow> {
  @override
  void initState() {
    super.initState();
    widget.prepDurationTextController.addListener(_onPrepDurationChanged);
  }

  @override
  void dispose() {
    widget.prepDurationTextController.removeListener(_onPrepDurationChanged);
    super.dispose();
  }

  void _onPrepDurationChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    return Row(
      children: [
        SectionTitle(
          title: AppLocalizations.of(context).translate(isAndroid ?'How long does the\ntotal preparation is ?:':'How long does the total preparation is ?:'),
          isDesktop: widget.isDesktop,
        ),
        const SizedBox(
          width: 15,
        ),
        widget.prepDurationTextController.text.isNotEmpty
            ? Icon(
                MdiIcons.checkCircleOutline,
                color: Colors.green.withOpacity(0.5),
              )
            : Container(),
      ],
    );
  }
}
