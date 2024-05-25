import 'package:cached_network_image/cached_network_image.dart';
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
    final screenSize = MediaQuery.of(context).size;
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
                  CachedNetworkImage(
                    memCacheHeight: screenSize.height.toInt(),
                    memCacheWidth: screenSize.width.toInt(),
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: screenSize.width,
                    height: screenSize.height,
                    filterQuality: FilterQuality.none,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error),
                    ),
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
              // Custom orange shape background
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipPath(
                    clipper: OrangeClipPath(),
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      width: screenSize.width * 0.5, // Adjust as needed
                    ),
                  ),
                ),
              ),
              // Title and user info
              Positioned(
                bottom: 10,
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
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        userImageURL.isEmpty
                            ? Container()
                            : ImagePickerPreviewContainer(
                                initialImagePath: userImageURL,
                                containerSize: 30,
                                onImageSelected: (image, bytes) {},
                                gender: Constants.emptyField,
                                isFor: Constants.emptyField,
                                isForEdit: Constants.defaultBoolValue,
                              ),
                        const SizedBox(width: 10),
                        Text(
                          username,
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

class OrangeClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width * 0.5, 0);
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.5,
      size.width * 0.5,
      size.height,
    );
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
