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
    final screenSize = MediaQuery.of(context).size;
    final categoryImage = '${Constants.imageURL}/${category.categoryImage}';
    return SizedBox(
      height: 150,
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Constants.defaultPadding),
                topRight: Radius.circular(Constants.defaultPadding),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(categoryImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    category.name,
                    style: GoogleFonts.getFont(
                      category.font,
                      fontSize: Responsive.isDesktop(context)
                          ? Constants.desktopFontSize
                          : Constants.mobileFontSize,
                      fontWeight: FontWeight.bold,
                      color:HexColor(category.color).withOpacity(0.7),
                    ),
                  ),
                  Text(
                    (category.recipes!.length.toString()),
                    style: GoogleFonts.getFont(
                      category.font,
                      fontSize: Responsive.isDesktop(context)
                          ? Constants.desktopFontSize
                          : Constants.mobileFontSize,
                      fontWeight: FontWeight.bold,
                      color: HexColor(category.color).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
