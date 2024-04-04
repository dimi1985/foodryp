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
      bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            surfaceTintColor : Colors.white,
            toolbarHeight: 80,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const LogoWidget(),
                const Text('Foodryp'),
                const Spacer(),
                if(Responsive.isDesktop(context))
                Expanded(
                  child: SizedBox(
                    width: screenSize.width,
                    height: 100,
                    child: MenuWebItems()),
                )
                // //FOR NOW LEAVE IT  FOR DEBIG, REMEMBER TO DELETE AFTER PRODUCTION
                // if(!isAndroid)
                // Text(screenSize.toString()),
              ],
            ),
            actions: const [],
          ),
          endDrawer: screenSize.width <= 1100 ? const MenuWebItems() : null,
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
