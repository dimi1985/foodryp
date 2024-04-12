import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class CustomCategoryTopThreeMobileCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color color;
  final String itemList;
  final String internalUse;
  final VoidCallback? onTap;
  final String username;
  final String userImageURL;
  final DateTime date;

  const CustomCategoryTopThreeMobileCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.color,
    required this.itemList,
    required this.internalUse,
    required this.username,
    required this.userImageURL,
    required this.date,
    this.onTap,
  });

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Responsive.isMobile(context) ? 140 : 120,
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? 150 : 135,
                        child: Text(
                          maxLines: Responsive.isMobile(context) ? 4 : 3,
                          overflow: TextOverflow.ellipsis,
                          title,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 30 : 50,
                      ),
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
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
