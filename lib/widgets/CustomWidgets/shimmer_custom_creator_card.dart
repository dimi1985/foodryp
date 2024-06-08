import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustomCreatorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: Container(
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          title: Container(
            width: double.infinity,
            height: 10,
            color: Colors.white,
          ),
          subtitle: Container(
            width: double.infinity,
            height: 10,
            color: Colors.white,
          ),
          trailing: Container(
            width: 100,
            height: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
