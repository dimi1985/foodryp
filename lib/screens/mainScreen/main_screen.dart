import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/responsive.dart';
import '../../widgets/desktopLeftSide/desktopLeftSide.dart';
import '../../widgets/DesktopMiddleSide/desktopMiddleSide.dart';
import '../../widgets/desktopRightSide/desktopRightSide.dart';

class MainScreen extends StatefulWidget {
  final User? user;
  const MainScreen({super.key, this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: isDesktop ? 1 : 1,
                child: const DesktopLeftSide(),
              ),
            Expanded(
              flex: isDesktop ? 4 : 2,
              child:  const DesktopMiddleSide(),
            ),
            if (isDesktop)
              Expanded(
                flex: isDesktop ? 1 : 1,
                child: const DesktopRightSide(),
              ),
          ],
        ),
      ),
    );
  }
}
