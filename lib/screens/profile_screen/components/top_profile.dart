

import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class TopProfile extends StatelessWidget {
  final String profileImage;
  const TopProfile({super.key, required this. profileImage});

  @override
  Widget build(BuildContext context) {
      bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return  Stack(
          children: [
             SizedBox(
              height: Responsive.isDesktop(context) ? 450: 300,
              width: double.infinity,
            ),
            Container(
              height:Responsive.isDesktop(context) ? 350: 250,
              width: double.infinity,
              color: const Color(0xFFFA624F),
            ),
            if(isAndroid)
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {},
                color: Constants.secondaryColor,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),
                Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      image: DecorationImage(
                          image: NetworkImage(profileImage),
                          fit: BoxFit.cover)),
                ),
                const Text(
                  'dimi85',
                  style: TextStyle(
                      color: Constants.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                 SizedBox(height: Responsive.isDesktop(context) ? 35: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Message',
                        style: TextStyle(
                           
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Constants.secondaryColor),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Following',
                        style: TextStyle(
                        
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Constants.secondaryColor),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        );
  }
}