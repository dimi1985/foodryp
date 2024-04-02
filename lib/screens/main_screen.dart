import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/responsive.dart';

import '../widgets/desktopLeftSide/desktopLeftSide.dart';
import '../widgets/DesktopMiddleSide/desktopMiddleSide.dart';
import '../widgets/desktopRightSide/desktopRightSide.dart';
import '../widgets/Header/header.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      body: Column(
        children: [
        SizedBox(
          height:Responsive.isDesktop(context)  ? 400: 250,
          child:  Header()),
          Expanded(
            flex: 5,
            child: Row(children: [
              if (Responsive.isDesktop(context))
              Expanded(
                flex:Responsive.isDesktop(context) ? 1 :1,
                child: const DesktopLeftSide(),),
              Expanded(
                flex:Responsive.isDesktop(context) ? 4 :3,
                child: const DesktopMiddleSide(),),
                  if (Responsive.isDesktop(context))
              Expanded(
                flex: Responsive.isDesktop(context) ? 1 :1,
                child:const DesktopRightSide(),),
            ],),
          )
        ],
      ),
    ));
  }
}