import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class CustomCategoryTopThreeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color color;
  final String itemList;
  final String internalUse;
  final VoidCallback? onTap;
  final String username;
  final String userImageURL;
  final DateTime date;

  const CustomCategoryTopThreeCard({
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
      onTap: onTap,
      child: SizedBox(
        height: 150,
        width: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.defaultPadding),
          child: Stack(
            children: [
              // Recipe image with gradient overlay
              Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // image fully loaded, return the image widget
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null, // This will show a determinate progress indicator if size is known, otherwise indeterminate
                          ),
                        );
                      }
                    },
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.none,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        // Image was loaded synchronously
                        return child; // Replace YourWidget with your custom widget
                      } else {
                        // Image is being loaded asynchronously
                        return child; // Replace YourLoadingWidget with your loading indicator or placeholder
                      }
                    },
                  ),
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom:
                    10, // Adjust this value to position it slightly above the bottom
                left: Constants.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Responsive.isMobile(context) ? 150 : 135,
                      child: Text(
                        title,
                        maxLines: Responsive.isMobile(context) ? 4 : 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: color, // Keep title color constant
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ImagePickerPreviewContainer(
                          initialImagePath: userImageURL,
                          containerSize: 30,
                          onImageSelected: (image, bytes) {},
                          gender: Constants.emptyField,
                          isFor: Constants.emptyField,
                          isForEdit: Constants.defaultBoolValue,
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
