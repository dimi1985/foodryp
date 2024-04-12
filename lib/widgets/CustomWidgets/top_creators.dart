import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class TopCreators extends StatefulWidget {
  const TopCreators({
    super.key,
  });

  @override
  State<TopCreators> createState() => _TopCreatorsState();
}

class _TopCreatorsState extends State<TopCreators> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SizedBox(
          height: 250,
          width: screenSize.width,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: DemoData.topCreators.length,
              shrinkWrap: true, // Prevent excessive scrolling
              itemBuilder: (context, index) {
                final topCreator = DemoData.topCreators[index];
                return SizedBox(
                  width: 250,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Constants.defaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(topCreator['image']),
                              ),
                              const SizedBox(width: 20,),
                             
                              Column(
                                children: [
                                  Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: _getRoleColor(topCreator[
                                      'role']), // Call function to get color
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  topCreator['role'],
                                  style: TextStyle(
                                    fontSize: Responsive.isDesktop(context)
                                        ? Constants.desktopFontSize
                                        : Constants.mobileFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .white, // Text color should be white for better contrast
                                  ),
                                ),
                              ),
                                  Text(
                                    topCreator['user'],
                                    style: TextStyle(
                                        fontSize: Responsive.isDesktop(context)
                                            ? Constants.desktopFontSize
                                            : Constants.mobileFontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                             
                              
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '${topCreator['creatorTeam']} (${topCreator['role']})',
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context)
                                  ? Constants.desktopFontSize
                                  : Constants.mobileFontSize,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${topCreator['totalRecipes']} Recipes',
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context)
                                  ? Constants.desktopFontSize
                                  : Constants.mobileFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Function to get color based on role
  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.yellow;
      case 'user':
        return Colors.grey;
      case 'New Member':
        return Colors.blue;
      case 'Old Member':
        return Colors.brown;
      default:
        return Colors.grey; // Default color for unknown roles
    }
  }
}
