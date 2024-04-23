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
                        borderRadius: BorderRadius.circular(2),
                        child: Image.network(
                          categoryImage,
                          fit: BoxFit.cover,
                            filterQuality: FilterQuality.none,
                        ),
                      )
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(width: 10,),
                  Text(
                    ('(${category.recipes!.length.toString()})'),
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
