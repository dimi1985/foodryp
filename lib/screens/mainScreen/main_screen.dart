import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/screens/mainScreen/components/logo_widget.dart';
import 'package:foodryp/widgets/desktopLeftSide/components/menuWebItems.dart';

import '../../widgets/desktopLeftSide/desktopLeftSide.dart';
import '../../widgets/DesktopMiddleSide/desktopMiddleSide.dart';
import '../../widgets/desktopRightSide/desktopRightSide.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          endDrawer: screenSize.width <= 1100 ? const MenuWebItems() : null,
          appBar: AppBar(
            toolbarHeight: 80,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const LogoWidget(),
                const Text('Foodryp'),
                Text(screenSize.toString()),
              ],
            ),
            actions: const [],
          ),
          body: Row(
            children: [
              if (Responsive.isDesktop(context))
                Expanded(
                  flex: Responsive.isDesktop(context) ? 1 : 1,
                  child: const DesktopLeftSide(),
                ),
              Expanded(
                flex: Responsive.isDesktop(context) ? 4 : 3,
                child: const DesktopMiddleSide(),
              ),
              if (Responsive.isDesktop(context))
                Expanded(
                  flex: Responsive.isDesktop(context) ? 1 : 1,
                  child: const DesktopRightSide(),
                ),
            ],
          )),
    );
  }
}
