import 'package:flutter/material.dart';

class HeadingTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool showSeeALl;
  const HeadingTitleRow({
    super.key,
    required this.title,
    required this.onPressed, required this.showSeeALl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          if(showSeeALl)
          TextButton(
            onPressed: onPressed, // Use the onPressed callback
            child: const Text(
              'See all',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
