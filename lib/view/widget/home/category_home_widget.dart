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
      onTap: () {
        Get.to(() => SubCategoryScreen(), arguments: {'id': data.id});
      },
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 100,
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
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                data.name,
                textAlign: TextAlign.center,
                style: regular16,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
