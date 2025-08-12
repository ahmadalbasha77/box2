import 'package:box_app/controller/home/category_home_controller.dart';
import 'package:box_app/core/app_color.dart';
import 'package:box_app/view/widget/home/category_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math' as math;
import 'package:box_app/view/ui/category/category_screen.dart'; // لو مساره مختلف عدّله

class CategoryHomeListWidget extends StatelessWidget {
  CategoryHomeListWidget({super.key});

  final _controller = CategoryHomeController.to;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryHomeController>(
      builder: (logic) {
        if (_controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.categories.isEmpty) {
          return Center(child: Text('لا يوجد بيانات'.tr));
        }

        // أول 5 عناصر + كرت "عرض الكل"
        final visibleCount = math.min(5, _controller.categories.length) + 1;

        // ارتفاع يكفي صفّين بشكل مريح
        final itemSpacing = 12.0;
        const itemAspectRatio = 0.78; // عدّلها إذا بدك الكرت أطول/أقصر
        final gridHeight = _twoRowGridHeight(context,
            crossAxisCount: 3,
            spacing: itemSpacing,
            childAspectRatio: itemAspectRatio);

        return SizedBox(
          height: gridHeight,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: itemSpacing,
              crossAxisSpacing: itemSpacing,
              childAspectRatio: itemAspectRatio,
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

  // يحسب ارتفاع صفّين بحسب عرض الشاشة و childAspectRatio
  double _twoRowGridHeight(BuildContext context,
      {required int crossAxisCount,
        required double spacing,
        required double childAspectRatio}) {
    final width = MediaQuery.sizeOf(context).width;
    // المساحة الأفقية المتاحة لكل عنصر
    final totalHSpacing =
        spacing * (crossAxisCount - 1) + 24; // padding أفقي (12+12)
    final itemWidth = (width - totalHSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;
    // صفّين + مسافة بين الصفوف + padding عمودي (8+8)
    return itemHeight * 2 + spacing + 16;
  }
}

class SeeAllCategoryTile extends StatelessWidget {
  final VoidCallback onTap;

  const SeeAllCategoryTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.primaryColor.withOpacity(0.15), // فاتح
              AppColor.primaryColor.withOpacity(0.35), // أغمق شوي
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.apps_rounded,
                  size: 36, color: AppColor.primaryColor),
              const SizedBox(height: 8),
              Text(
                'عرض الكل'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
