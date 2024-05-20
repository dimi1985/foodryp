import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/widgets/CustomWidgets/section_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CookingAdvicesRow extends StatefulWidget {
  final List<TextEditingController> adviceControllers;
  final bool isDesktop;

  const CookingAdvicesRow({
    super.key,
    required this.adviceControllers,
    required this.isDesktop,
  });

  @override
  _CookingAdvicesRowState createState() => _CookingAdvicesRowState();
}

class _CookingAdvicesRowState extends State<CookingAdvicesRow> {
  @override
  void initState() {
    super.initState();
    for (var controller in widget.adviceControllers) {
      controller.addListener(_onAdvicesChanged);
    }
  }

  @override
  void dispose() {
    for (var controller in widget.adviceControllers) {
      controller.removeListener(_onAdvicesChanged);
    }
    super.dispose();
  }

  void _onAdvicesChanged() {
    setState(() {});
  }

  bool _hasNonEmptyAdvice() {
    for (var controller in widget.adviceControllers) {
      if (controller.text.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    return Row(
      children: [
        SectionTitle(
          title:
              '${AppLocalizations.of(context).translate(isAndroid ? 'Add Cooking\nAdvices' : 'Add Cooking Advices')}:',
          isDesktop: widget.isDesktop,
        ),
        const SizedBox(
          width: 15,
        ),
        _hasNonEmptyAdvice()
            ? Icon(
                MdiIcons.checkCircleOutline,
                color: Colors.green.withOpacity(0.5),
              )
            : Container(),
      ],
    );
  }
}
