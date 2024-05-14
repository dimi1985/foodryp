import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class AnimatedCustomCategoryCard extends StatelessWidget {
  final CategoryModel category;

  const AnimatedCustomCategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      frontWidget: _buildFrontWidget(context),
      backWidget: _buildBackWidget(),
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildFrontWidget(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color:
            HexColor(category.color ?? Constants.emptyField).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
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
         
          const SizedBox(height: 10),
          Text(
            category.name ?? Constants.emptyField,
            style: GoogleFonts.getFont(
              category.font ?? Constants.emptyField,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HexColor(category.color ?? Constants.emptyField)
                  .withOpacity(0.7),
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
              color: HexColor(category.color ?? Constants.emptyField)
                  .withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildBackWidget() {
  return Container(
    height: 150,
    width: 150,
    margin: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4.0,
          spreadRadius: 1.0,
          offset: Offset(2.0, 2.0),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          // Left images
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Column(
              children: [
                Image.network(
                  'https://picsum.photos/id/237/200/100',
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,
                ),
                Image.network(
                  'https://picsum.photos/id/18/200/100',
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          // Divider
          Positioned(
            top: 0,
            bottom: 0,
            left: 75,
            child: Container(
              width: 1,
              color: Colors.white,
            ),
          ),
          // Right image
          Positioned(
            top: 0,
            left: 76, // Account for divider width
            bottom: 0,
            child: Image.network(
              'https://picsum.photos/id/21/100/150',
              width: 74, // Account for divider width
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ),
  );
}


}
