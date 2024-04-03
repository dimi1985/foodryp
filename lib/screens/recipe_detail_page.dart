import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecipeDetailPage extends StatefulWidget {
  final Map<String, dynamic> regularRecipe;
  const RecipeDetailPage({super.key, required this.regularRecipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    bool isANDROID = Theme.of(context).platform == TargetPlatform.android;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Recipe image with optional Neomorphism effect
              Container(
  height: 250.0, // Adjust height as needed
  width: double.infinity, // Take full width
  child: Stack(
    children: [
      // Background image with Neomorphism effect
      DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            // Inner shadow
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 12.0,
              spreadRadius: -5.0,
            ),
            // Outer shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15.0,
              spreadRadius: 2.0,
              offset: const Offset(4.0, 4.0),
            ),
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Image.network(
          widget.regularRecipe['image'],
          width: screenSize.width, // Take full width
          height: 250.0, // Adjust height as needed
          fit: BoxFit.cover,
        ),
      ),
      // Back button positioned on top-left
      if(isANDROID)
      Positioned(
        top: 16.0, // Adjust padding from top
        left: 16.0, // Adjust padding from left
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Handle back button press
        ),
      ),
    ],
  ),
),
              const SizedBox(height: 20.0),
              // Recipe title and description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.regularRecipe['title'],
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      widget.regularRecipe['description'],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // Ingredients section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ingredients',
                      style:
                          TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap:
                          true, // Prevent list view from taking unnecessary space
                      itemCount: widget.regularRecipe['ingredients'].length,
                      itemBuilder: (context, index) =>
                          Text(widget.regularRecipe['ingredients'][index]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // Steps section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Steps',
                      style:
                          TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: steps.length,
                    //   itemBuilder: (context, index) => Text('Step ${index + 1}: ${steps[index]}'),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // Comments section (optional)
              // ... (Implement comments section)
            ],
          ),
        ),
      ),
    );
  }
}
