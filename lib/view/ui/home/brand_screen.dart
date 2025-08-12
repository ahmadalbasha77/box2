import 'package:box_app/controller/home/brand_controller.dart'; // عدّل المسار حسب مشروعك
import 'package:box_app/core/app_color.dart';
import 'package:box_app/core/font_style.dart';
import 'package:box_app/view/ui/product/product_screen.dart';
import 'package:box_app/view/widget/cache_image_widget.dart'; // لو عندك الويدجت
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../model/home/brand_model.dart';
import '../category/sub_category_screen.dart';

class BrandScreen extends StatelessWidget {
  BrandScreen({super.key});

  final _controller = BrandController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'العلامات التجارية'.tr,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Search
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _controller.controllerSearch,
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    _controller.refreshScreen(); // يرجع البيانات الأصلية إذا الحقل فاضي
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search, color: AppColor.primaryColor),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: AppColor.primaryColor),
                    onPressed: () {
                      _controller.refreshScreen(); // ينفذ البحث عند الضغط
                    },
                  ),
                  hintText: 'ابحث عن علامة تجارية'.tr,
                  hintStyle: regular14.copyWith(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),


            const SizedBox(height: 20),

            // Grid 3 columns
            GetBuilder<BrandController>(
              builder: (logic) {
                return Expanded(
                  child: PagedGridView<int, BrandDate>(
                    pagingController: logic.pagingController,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // ثلاث أعمدة ثابتة
                      crossAxisSpacing: 12, // مسافة أفقية
                      mainAxisSpacing: 12, // مسافة رأسية
                      childAspectRatio: 0.78, // اضبطه لو حاسس الكرت طويل/قصير
                    ),
                    builderDelegate: PagedChildBuilderDelegate<BrandDate>(
                      firstPageProgressIndicatorBuilder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                      newPageProgressIndicatorBuilder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                      noItemsFoundIndicatorBuilder: (_) =>
                          Center(child: Text('لا يوجد بيانات'.tr)),
                      itemBuilder: (context, item, index) {
                        return BrandGridItem(data: item);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BrandGridItem extends StatelessWidget {
  final BrandDate data;

  const BrandGridItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => SubCategoryScreen(), arguments: {'brandId': data.id});
        Get.to(() => const ProductScreen(isCart: false,), arguments: {'brandId': data.id});
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة البراند
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: CacheImageWidget(
                  image: data.imageUrl, // تأكد من اسم الحقل بمويلك
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // اسم البراند
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Text(
                data.name, // تأكد من اسم الحقل بمويلك
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
