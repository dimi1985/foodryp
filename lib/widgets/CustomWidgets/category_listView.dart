import 'dart:ui';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';

class CategoryListView extends StatefulWidget {
  final List<CategoryModel> categories; // Change to CategoryModel type
  final Function(CategoryModel) onTap; // Change callback parameter type

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
          final isTapped = index == tappedIndex; 

          return InkWell(
            onTap: () {
              setState(() {
                tappedIndex = index; 
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
                    category.name,
                    style: TextStyle(
                      color: isTapped ? HexColor(category.color) : Colors.grey,
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

  Color hexToColor(String hexString) {
  final int colorInt = int.parse(hexString.substring(1), radix: 16);
  return Color(colorInt);
}
}
