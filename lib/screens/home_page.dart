import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/category_card.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showMenu = false;
  bool isHovering = false;

  late List<bool> _isHovering;
  @override
  void initState() {
    super.initState();
    _isHovering = List.generate(Constants.categories.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    log(screenSize.toString());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenSize.width <= 825 ? 100 : 200.0,
        centerTitle: true,
        title: _logo(screenSize.width),
        actions: [
          if (screenSize.width <= 841)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => setState(() => showMenu = !showMenu),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            if (screenSize.width > 825) _navigationMenuWeb(screenSize.width),
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                _topSection(screenSize.width),
                if (showMenu && screenSize.width <= 825)
                  _smallScreenButonMenu(screenSize.width)
              ],
            ),
            SizedBox(
              height: screenSize.width <= 825 ? null : 50,
            ),
            CategoryCard(screenSize: screenSize),
            RecipeCard(screenSize: screenSize),
            // CustomCard(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String item, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        onPressed: () {
          // Handle menu item tap (e.g., navigate to a different screen)

          setState(() => showMenu = false); // Close menu after tapping
        },
        child: Text(
          item,
          style: TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth <= 825 ? 12 : 16),
        ),
      ),
    );
  }

  Widget _topSection(double screenWidth) {
    return Container(
      height: screenWidth < 600 ? screenWidth * 0.50 : screenWidth * 0.30,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://picsum.photos/200/300', // Replace with your actual image URL
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Optional search bar
            Container(
              width:
                  screenWidth < 600 ? screenWidth * 0.50 : screenWidth * 0.30,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.8), // Semi-transparent white background
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search recipes...',
                        border: InputBorder.none, // Remove default border
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _smallScreenButonMenu(double screenWidth) {
    return Positioned(
      right: 0.0,
      top: .1,
      child: Material(
        elevation: 5.0,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: Constants.menuItems
                .map((item) => _buildMenuItem(item, screenWidth))
                .toList(),
          ),
        ),
      ),
    );
  }

  _navigationMenuWeb(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: Constants.menuItems
          .map(
            (item) => _buildMenuItem(item, screenWidth),
          )
          .toList(),
    );
  }

  _logo(double screenWidth) {
    return Image.asset(
      'assets/logo.png',
      width: screenWidth < 825 ? 150 : 300,
      height: screenWidth < 825 ? 150 : 300,
      fit: BoxFit.cover,
    );
  }
}
