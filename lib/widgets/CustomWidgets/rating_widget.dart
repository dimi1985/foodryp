import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingWidget extends StatefulWidget {
  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 3;  // Initial rating

  void _updateRating(double rating) {
    setState(() {
      _currentRating = rating;
    });
    print("Rating updated to: $rating");
    // TODO: Add your API call here to update the rating on the server
    // updateRatingOnServer(rating);
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: _currentRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 20, // Adjust the size as needed
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, index) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () => _updateRating(index + 1.0),
          child: Icon(
            Icons.star,
            color: index < _currentRating ? Colors.amber : Colors.grey,
          ),
        ),
      ),
      onRatingUpdate: (rating) {
        // This is triggered on drag; you might not need this if you handle updates via onTap
      },
    );
  }
}
