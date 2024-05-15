import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HeadingTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool showSeeALl;
  final bool isForDiet;
  const HeadingTitleRow({
    super.key,
    required this.title,
    required this.onPressed,
    required this.showSeeALl, required this.isForDiet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if(isForDiet)
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10,),
              Icon(MdiIcons.leaf,color: Colors.green,)
            ],
          ),
           if(!isForDiet)
          Text(
            title,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showSeeALl)
            TextButton(
              onPressed: onPressed,
              child: Text(
                AppLocalizations.of(context).translate('See all'),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
