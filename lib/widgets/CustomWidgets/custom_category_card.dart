import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomCategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CustomCategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: HexColor(category.color ?? Constants.emptyField).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category, // Replace with appropriate icons based on category
            size: 40,
            color: HexColor(category.color ?? Constants.emptyField).withOpacity(0.7),
          ),
          const SizedBox(height: 10),
          Text(
            category.name ?? Constants.emptyField,
            style: GoogleFonts.getFont(
              category.font ?? Constants.emptyField,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HexColor(category.color ?? Constants.emptyField).withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            '(${category.recipes?.length.toString() ?? '0'})',
            style: GoogleFonts.getFont(
              category.font ?? Constants.emptyField,
              fontSize: Responsive.isDesktop(context)
                  ? Constants.desktopFontSize
                  : Constants.mobileFontSize,
              fontWeight: FontWeight.bold,
              color: HexColor(category.color ?? Constants.emptyField).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
