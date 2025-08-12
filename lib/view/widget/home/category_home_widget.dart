import 'package:box_app/core/font_style.dart';
import 'package:box_app/model/home/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/category/sub_category_screen.dart';
import '../cache_image_widget.dart';

class CategoryHomeWidget extends StatelessWidget {
  final CategoryData data;

  const CategoryHomeWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.to(() => SubCategoryScreen(), arguments: {'id': data.id}),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 6)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CacheImageWidget(
                  image: data.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                data.name,
                textAlign: TextAlign.center,
                style: regular14,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
