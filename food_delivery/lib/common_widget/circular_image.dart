import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class CircularImage extends StatelessWidget {
  final String image;
  final bool isNetworkImage;
  const CircularImage(
      {super.key, required this.image, this.isNetworkImage = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: TColor.placeholder,
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: isNetworkImage
              ? CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 65,
                  color: TColor.secondaryText,
                ),
        ),
      ),
    );
  }
}
