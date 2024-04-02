import 'package:flutter/material.dart';
import 'package:foodryp/widgets/Header/components/top_three_recipe_card.dart';
import 'package:foodryp/widgets/header/components/logo_widget.dart';
import 'package:foodryp/widgets/header/components/menuWebItems.dart';

class Header extends StatefulWidget {
  Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool openMenu = false;

  void showContextMenu() {
    setState(() => openMenu = !openMenu);
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      endDrawer: screenSize.width <= 1100 ? const MenuWebItems() : null,
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LogoWidget(),
            Text('Foodryp'),
          ],
        ),
        actions: const [],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: AnimatedContainer(
              duration: const Duration(microseconds: 300),
              child: screenSize.width <= 1100
                  ? Container()
                  : const MenuWebItems(),
            ),
          ),
          Expanded(
            flex: screenSize.width <= 1100 ?  10 : 3,
            child: const TopThreeRecipeCard(),
          )
        ],
      ),
    );
  }

  
}
