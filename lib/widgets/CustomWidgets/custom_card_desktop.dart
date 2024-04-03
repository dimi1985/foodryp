import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class CustomCardDesktop extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color color;
  final String itemList;
  final String internalUse;
  final Function() onTap;
  final String username;
  final String userImageURL;
  final String description;

  const CustomCardDesktop({
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
    return InkWell(
      hoverColor: Colors.white,
      onTap: onTap,
      child: SizedBox(
        height: 500,
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                // Wrap Image.network here
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: SizedBox(
                  width: screenSize.width,
                  height: 250,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Constants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: Responsive.isMobile(context)
                                ? Constants.mobileFontSize
                                : Constants.desktopFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.heart_broken),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue, // Set background color
                        borderRadius:
                            BorderRadius.circular(5.0), // Adjust corner radius
                      ),
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? Constants.mobileFontSize
                              : Constants.desktopFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Adjust text color for contrast
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context)
                          ? Constants.mobileFontSize
                          : Constants.desktopFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context)
                          ? Constants.mobileFontSize
                          : Constants.desktopFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
