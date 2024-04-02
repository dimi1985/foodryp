import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'components/logo_widget.dart';
import 'components/menuWebItems.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.headerColor,
        child: const Column(
          children: [
            // Centered Logo
            Flexible(
              fit: FlexFit.loose,
              flex: 3,
              child: LogoWidget(),
            ),

            // Centered Menu Items
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: MenuWebItems(),
            ),
          ],
        ),
      ),
    );
  }
}
