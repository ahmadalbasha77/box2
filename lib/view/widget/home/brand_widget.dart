import 'package:box_app/model/home/brand_model.dart';
import 'package:box_app/view/widget/cache_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/product/product_screen.dart';

class BrandWidget extends StatelessWidget {
  final BrandDate data;

  const BrandWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ProductScreen(isCart: false,), arguments: {'brandId': data.id});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: const EdgeInsets.all(15),
          height: 90,
          width: 90,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: CacheImageWidget(
            image: data.imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
