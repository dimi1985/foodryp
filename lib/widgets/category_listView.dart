import 'dart:ui';

import 'package:flutter/material.dart';

class CategoryListView extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final Function(Map<String, dynamic>) onTap;
  int defaultTappedIndex;

   CategoryListView({
    super.key,
    required this.categories,
    required this.onTap,
    this.defaultTappedIndex = 0, // Default tapped index is set to 0
  });

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          isTapped = index == widget.defaultTappedIndex; 

          return InkWell(
            onTap: () {

              setState(() {
                widget.defaultTappedIndex = index; // Update tapped index

                 
              });

              widget.onTap(category); 
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    category['title'],
                    style: TextStyle(
                      color: isTapped ? Colors.blue : category['color'].withOpacity(0.2), // Change color if tapped
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}