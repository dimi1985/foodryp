import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustomCategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 10,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
