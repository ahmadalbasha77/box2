import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:box_app/controller/home/category_home_controller.dart';
import 'package:box_app/core/app_color.dart';
import 'package:box_app/view/widget/home/category_home_widget.dart';
import 'package:box_app/view/ui/category/category_screen.dart';

class CategoryHomeListWidget extends StatelessWidget {
  CategoryHomeListWidget({super.key});

  final _controller = CategoryHomeController.to;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryHomeController>(
      builder: (logic) {
        if (_controller.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (_controller.categories.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'لا يوجد بيانات'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }

        /// أول 5 تصنيفات + كرت "عرض الكل"
        final visibleCount =
            math.min(5, _controller.categories.length) + 1;

        const spacing = 12.0;
        const childAspectRatio = 0.8;

        final gridHeight = _twoRowGridHeight(
          context,
          crossAxisCount: 3,
          spacing: spacing,
          childAspectRatio: childAspectRatio,
        );

        return SizedBox(
          height: gridHeight,
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: visibleCount,
            itemBuilder: (context, index) {
              final isSeeAll = index == visibleCount - 1;

              if (isSeeAll) {
                return SeeAllCategoryTile(
                  onTap: () => Get.to(() => CategoryScreen()),
                );
              }

              final item = _controller.categories[index];
              return CategoryHomeWidget(data: item);
            },
          ),
        );
      },
    );
  }

  /// حساب ارتفاع صفّين بشكل دقيق
  double _twoRowGridHeight(
      BuildContext context, {
        required int crossAxisCount,
        required double spacing,
        required double childAspectRatio,
      }) {
    final width = MediaQuery.sizeOf(context).width;
    final totalHSpacing = spacing * (crossAxisCount - 1) + 32;
    final itemWidth = (width - totalHSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;
    return itemHeight * 2 + spacing + 20;
  }
}

/// =================================================================
/// SEE ALL TILE (PROFESSIONAL)
class SeeAllCategoryTile extends StatelessWidget {
  final VoidCallback onTap;

  const SeeAllCategoryTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            border: Border.all(
              color: AppColor.primaryColor.withOpacity(0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primaryColor.withOpacity(0.12),
                  ),
                  child: const Icon(
                    Icons.apps_rounded,
                    size: 24,
                    color: AppColor.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'عرض الكل'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
