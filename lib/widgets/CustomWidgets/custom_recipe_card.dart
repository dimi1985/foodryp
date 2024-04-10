import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class CustomRecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color color;
  final String itemList;
  final String internalUse;
  final Function() onTap;
  final String username;
  final String userImageURL;
  final String description;

  const CustomRecipeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.color,
    required this.itemList,
    required this.internalUse,
    required this.onTap,
    required this.username,
    required this.userImageURL,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
           bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return GestureDetector(
  onTap: onTap,
  child: Container(
    height: 150,
    width: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Constants.defaultPadding),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(isAndroid ? 0.2: 0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Constants.defaultPadding),
              topRight: Radius.circular(Constants.defaultPadding),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          flex:isAndroid ? 3 : 2,
          child: Container(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Constants.defaultPadding),
                bottomRight: Radius.circular(Constants.defaultPadding),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userImageURL),
                      backgroundColor: Colors.grey[200],
                      radius: 10,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context)
                            ? Constants.desktopFontSize
                            : Constants.mobileFontSize,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Responsive.isDesktop(context)
                        ? Constants.desktopFontSize
                        : Constants.mobileFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // You can add more widgets here if needed
              ],
            ),
          ),
        ),
        if(isAndroid)
        const SizedBox(height: 20,)
      ],
    ),
  ),
);
  }
}
