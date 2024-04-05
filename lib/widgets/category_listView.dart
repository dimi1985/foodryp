import 'dart:ui';

import 'package:flutter/material.dart';

class CategoryListView extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final Function(Map<String, dynamic>) onTap;

  CategoryListView({
    Key? key,
    required this.categories,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  late int tappedIndex; // Variable to hold the tapped index

  @override
  void initState() {
    super.initState();
    tappedIndex = 0; // Initialize tapped index to 0 (first category)
  }

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
          final isTapped = index == tappedIndex; // Check if current index is tapped

          return InkWell(
            onTap: () {
              setState(() {
                tappedIndex = index; // Update tapped index
              });
              widget.onTap(category); // Notify parent widget about the tapped category
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
                      color: isTapped ? category['color'].withOpacity(0.2) : Colors.grey, // Change color if tapped
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
