import 'dart:developer';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> menuItems = [
    'Home',
    'Categories',
    'Creators',
    'Recipes',
    'My Fridge',
    'Login/Register'
  ]; // Add more items as needed

  // Improved category data with unique titles and colors
  // Improved category data with unique titles, colors, and 10 items
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Italian',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.red, // Red color for Italian category
    },
    {
      'title': 'Vegetarian',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.green, // Green color for Vegetarian category
    },
    {
      'title': 'Asian',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.yellow, // Yellow color for Asian category
    },
    {
      'title': 'Mexican',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.orange, // Orange color for Mexican category
    },
    {
      'title': 'American',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.blue, // Blue color for American category
    },
    {
      'title': 'Seafood',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.teal, // Teal color for Seafood category
    },
    {
      'title': 'Breakfast',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.pink, // Pink color for Breakfast category
    },
    {
      'title': 'Desserts',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.purple, // Purple color for Desserts category
    },
    {
      'title': 'Soups & Salads',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color':
          Colors.lightGreen, // Light green color for Soups & Salads category
    },
    {
      'title': 'Drinks',
      'image':
          'https://picsum.photos/200/300', // Replace with your actual image URL
      'color': Colors.lightBlue, // Light blue color for Drinks category
    },
  ];

  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logo.jpg',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
                const Text('Recipe App'),
              ],
            ),
            const SizedBox(
              width: 50,
            ),
            if (MediaQuery.of(context).size.width > 825)
              Row(
                children:
                    menuItems.map((item) => _buildMenuItem(item)).toList(),
              ),
          ],
        ),
        actions: [
          if (MediaQuery.of(context).size.width <= 825)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => setState(() => showMenu = !showMenu),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                _buildHeroSection(),
                if (showMenu && MediaQuery.of(context).size.width <= 600)
                  Positioned(
                    right: 0.0,
                    top: .1, // Adjust positioning as needed
                    child: Material(
                      elevation: 5.0,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: menuItems
                              .map((item) => _buildMenuItem(item))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            _buildRecipeCategories(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextButton(
        onPressed: () {
          // Handle menu item tap (e.g., navigate to a different screen)

          setState(() => showMenu = false); // Close menu after tapping
        },
        child: Text(item),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 300.0, // Adjust height as needed
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://picsum.photos/200/300', // Replace with your actual image URL
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add spacing
            const SizedBox(height: 50.0), // Adjust spacing as needed

            const Text(
              'Discover Delicious Recipes',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Add search bar code here (optional)
            const SizedBox(height: 20.0), // Add spacing after title

            // Optional search bar
            Container(
              width: MediaQuery.of(context).size.width *
                  0.7, // Adjust width as needed
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.8), // Semi-transparent white background
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10.0),
                  Expanded(
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

  Widget _buildRecipeCategories() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Wrap(
        // Adjust layout as needed (GridView or ListView)
        spacing: 10.0, // Adjust spacing between categories
        runSpacing: 10.0,
        children:
            categories.map((category) => _buildCategoryCard(category)).toList(),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Stack(
      children: [
        ClipRRect(
          // Apply rounded corners to the image
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)), // Adjust the radius as desired
          child: Image(
            image: NetworkImage(category['image']),
            fit: BoxFit.cover, // Adjust as needed
          ),
        ),
        Positioned(
          // Center the content horizontally and vertically
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Container(
            decoration: BoxDecoration(
              // Apply a gradient with transparent top and category color at the bottom
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent, // Transparent top
                  category['color']
                      .withOpacity(0.7), // Category color with opacity
                ],
              ),
            ),
            child: Center(
              // Maintain centered content
              child: Column(
                mainAxisSize: MainAxisSize.min, // Content fits within the image
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.7), // Semi-transparent white
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      category['title'],
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 5.0), // Add spacing between text and recipe count
                  Text(
                    category['title'],
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
