import 'package:box_app/controller/category/brand_product_controller.dart';
import 'package:box_app/controller/home/product_controller.dart';
import 'package:box_app/core/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart'; // تم استبدال skeletonizer

class BrandProductWidget extends StatelessWidget {
  const BrandProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BrandProductController>(
      init: BrandProductController(),
      builder: (logic) => logic.isLoading
          ? SizedBox(
        height: 32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 80,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      )
          : SizedBox(
        height: 32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: logic.brand.length,
          itemBuilder: (context, index) => FittedBox(
            child: GestureDetector(
              onTap: () {
                if (logic.idSelected != logic.brand[index].id) {
                  final controller = ProductController.to;
                  logic.idSelected = logic.brand[index].id;
                  controller.brandId = logic.brand[index].id;
                  controller.refreshScreen();
                  logic.update();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: logic.idSelected == logic.brand[index].id
                        ? Colors.black54
                        : Colors.white,
                    width: 0.8,
                  ),
                ),
                child: Center(
                  child: Text(
                    logic.brand[index].name,
                    style: regular16.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
