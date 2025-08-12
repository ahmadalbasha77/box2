import 'package:box_app/core/font_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CacheImageWidget extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CacheImageWidget(
      {super.key, required this.image, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit,
      imageUrl: image,
      errorWidget: (context, url, error) => const Icon(
        Icons.shopping_cart_outlined,
        color: Colors.black26,
        size: 50,
      ),
    );
  }
}
