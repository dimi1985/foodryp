import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: DemoData.imageUrls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // Adjust corner radius
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          setState(() {});
        },
      ),
    );
  }
}
