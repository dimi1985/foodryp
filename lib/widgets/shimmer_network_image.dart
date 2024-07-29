import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double width;
  final double height;
  final double? memCacheHeight;
  final double? memCacheWidth;

  const ShimmerNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width = double.infinity,
    this.height = double.infinity,
    this.memCacheHeight,
    this.memCacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      memCacheHeight: memCacheHeight?.toInt(),
      memCacheWidth: memCacheWidth?.toInt(),
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      filterQuality: FilterQuality.none,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Stack(
          children: <Widget>[
            // Image placeholder
            Positioned.fill(
              child: Image.asset(
                'assets/placeholder.png',
                fit: BoxFit.cover,
              ),
            ),
            // Text at the bottom
            Positioned(
              bottom: 20.0,
              left: 0.0,
              right: 0.0,
              child: Text(
                AppLocalizations.of(context).translate('No Image at this time'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize:5,
                  color: Colors.white,
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
