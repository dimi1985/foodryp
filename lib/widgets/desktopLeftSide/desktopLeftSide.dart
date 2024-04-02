import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/contants.dart';

class DesktopLeftSide extends StatelessWidget {
  const DesktopLeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.leftSideColor,
      ),
    );
  }
}