import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class DesktopRightSide extends StatelessWidget {
  const DesktopRightSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          
          children: [
            // Friend List Title
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Friends List',
                style: TextStyle(
                  fontSize: Responsive.isDesktop(context)
                      ? Constants.desktopFontSize
                      : Constants.mobileFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ListView for Friends
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: DemoData.friendsList.length,
                  itemBuilder: (context, index) {
                    final friend = DemoData.friendsList[index];
                    return InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(friend['image']),
                        ),
                        title: Text(friend['user']),
                        subtitle: Text(friend['status']),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
