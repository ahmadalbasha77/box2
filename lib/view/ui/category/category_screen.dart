import 'package:box_app/controller/category/category_controller.dart';
import 'package:box_app/model/home/category_model.dart';
import 'package:box_app/view/ui/category/sub_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/app_color.dart';
import '../../../core/font_style.dart';
import '../../widget/cache_image_widget.dart';
import '../../widget/cart_icon_widget.dart';

class CategoryScreen extends StatelessWidget {
  final bool isCart;

  CategoryScreen({super.key, this.isCart = true});

  final _controller = CategoryController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'الاصناف'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        actions: [if (isCart) CartIconWidget()],
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
                onChanged: (value) => _controller.searchOnChange,
                controller: _controller.controllerSearch,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColor.primaryColor,
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
              ),
            ),
            const SizedBox(height: 20),
            GetBuilder<CategoryController>(
                // init: CategoryController(),
                builder: (logic) {
                  return Expanded(
                    child: PagedListView<int, CategoryData>(
                      pagingController: logic.pagingController,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      builderDelegate: PagedChildBuilderDelegate<CategoryData>(
                        itemBuilder: (context, item, index) {
                          return CategoryWidget(data: item);
                        },
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final CategoryData data;

  const CategoryWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SubCategoryScreen(), arguments: {'id': data.id});
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
                  color: AppColor.primaryColor,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColor.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
