import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color color;
  final String itemList;
  final String internalUse;
  final VoidCallback? onTap;
  final String username;
  final String userImageURL;
  final DateTime date;

  const CustomCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.color,
    required this.itemList,
    required this.internalUse,
    required this.username,
    required this.userImageURL,
    required this.date,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Wrap with InkWell for interaction (optional)
      onTap: onTap,
      child: SizedBox(
        height: 150,
        width: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.defaultPadding),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: Constants.defaultPadding,
                left: Constants.defaultPadding,
                child: internalUse == 'categories'
                    ? Column(
                        // Layout for categories
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maxLines: 2,
                            title,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.menu,
                                color: color,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$itemList Recipes',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        // Layout for recipes (assuming 'recipes' internalUse)
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context)
                                  ? Constants.desktopFontSize
                                  : Constants.mobileFontSize,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Image avatar (assuming you have a 'userImage' field)
                              CircleAvatar(
                                backgroundImage: NetworkImage(userImageURL),
                                // Handle missing image (optional)
                                backgroundColor: Colors.grey[200],
                                radius: 10,
                              ),
                              const SizedBox(width: 10),
                              // Username (assuming you have a 'username' field)
                              Text(
                                username, // Handle missing data
                                style: TextStyle(
                                  fontSize: Responsive.isDesktop(context)
                                      ? Constants.desktopFontSize
                                      : Constants.mobileFontSize,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Date (assuming you have a 'date' field)
                          Text(
                            DateFormat('dd/MM/yyyy').format(date),
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context)
                                  ? Constants.desktopFontSize
                                  : Constants.mobileFontSize,
                              color: Constants.headerColor,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
