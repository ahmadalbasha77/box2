import 'package:box_app/model/home/sub_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../controller/category/sub_category_controller.dart';
import '../../../core/app_color.dart';
import '../../../core/font_style.dart';
import '../../widget/cache_image_widget.dart';
import '../../widget/cart_icon_widget.dart';
import '../product/product_screen.dart';
import 'category_screen.dart';

class SubCategoryScreen extends StatelessWidget {
  SubCategoryScreen({super.key});

  final _controller = SubCategoryController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الاصناف الفرعية'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        actions: [CartIconWidget()],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
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
                    _controller.refreshScreen(); // يعمل ريفريش إذا الحقل فاضي
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon:
                  const Icon(Icons.search, color: AppColor.primaryColor),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        color: AppColor.primaryColor),
                    onPressed: () {
                      _controller.refreshScreen(); // البحث عند الضغط على الزر
                    },
                  ),
                  hintText: 'ابحث عن صنف'.tr,
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
                onFieldSubmitted: (value) {
                  _controller.refreshScreen(); // البحث عند الضغط على Enter
                },
              ),
            ),
            const SizedBox(height: 20),
            GetBuilder<SubCategoryController>(
              builder: (logic) {
                return Expanded(
                  child: PagedGridView<int, SubCategoryData>(
                    pagingController: logic.pagingController,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // ثلاث أعمدة
                      crossAxisSpacing: 12, // مسافة أفقية
                      mainAxisSpacing: 12, // مسافة رأسية
                      childAspectRatio: 0.75, // تناسب العرض والطول
                    ),
                    builderDelegate: PagedChildBuilderDelegate<SubCategoryData>(
                      itemBuilder: (context, item, index) {
                        return CategoryGridItem(data: item);
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CategoryGridItem extends StatelessWidget {
  final SubCategoryData data;

  const CategoryGridItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ProductScreen(), arguments: {'id': data.id});
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(15)),
                child: CacheImageWidget(
                  image: data.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                data.name,
                style: bold14.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
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

class SubCategoryWidget extends StatelessWidget {
  final SubCategoryData data;

  const SubCategoryWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ProductScreen(), arguments: {'id': data.id});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.primaryColor.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CacheImageWidget(
                  image: data.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                data.name,
                style: bold16.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
