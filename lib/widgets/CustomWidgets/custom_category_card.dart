import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final Color color;
  final String font;

  const CustomCategoryCard({
    super.key,
    required this.title,
    required this.image,
    required this.color,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final categoryImage = '${Constants.imageURL}/$image';
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
              Text(
                title,
                style: GoogleFonts.getFont(
                  font,
                  fontSize: Responsive.isDesktop(context)
                      ? Constants.desktopFontSize
                      : Constants.mobileFontSize,
                  fontWeight: FontWeight.bold,
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
