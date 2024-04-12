import 'package:flutter/material.dart';

class HeadingTitleRow extends StatelessWidget {
  final String title;
  const HeadingTitleRow({super.key, required this. title});

  @override
  Widget build(BuildContext context) {
    return   Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style:const  TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
           const   Text(
                'see all',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.orange,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        );
  }
}