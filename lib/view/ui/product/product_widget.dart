import 'package:box_app/controller/home/product_controller.dart';
import 'package:box_app/model/home/product_model.dart';
import 'package:box_app/view/widget/cart_icon_widget.dart';
import 'package:box_app/view/widget/custom_button.dart';
import 'package:box_app/view/widget/home/brand_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../controller/order/cart_controller.dart';
import '../../../core/app_color.dart';
import '../../../core/font_style.dart';
import '../../widget/cache_image_widget.dart';

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}


class AnimatedAddRemoveButton2 extends StatelessWidget {
  final ProductData product;
  final ProductUnit unit;
  final double iconSize;
  final double buttonSize;
  final double fontSize;

  const AnimatedAddRemoveButton2({
    super.key,
    required this.product,
    required this.unit,
    this.iconSize = 18,
    this.buttonSize = 32,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        int count = cartController.quantityOf(product, unit);
        bool expanded = count > 0;

        return AnimatedContainer(
          height: 35,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// زر الإنقاص
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: expanded
                    ? IconButton(
                  key: const ValueKey('remove'),
                  icon: Icon(Icons.remove,
                      color: Colors.black, size: iconSize),
                  onPressed: () =>
                      cartController.decrement(product, unit),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
                    : const SizedBox.shrink(),
              ),

              /// زر العدد أو الإضافة
              GestureDetector(
                onTap: () {
                  if (expanded) {
                    // cartController.removeProduct(product, unit);
                  } else {
                    cartController.addProduct(product, unit);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: buttonSize,
                  height: buttonSize,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primaryColor,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) => RotationTransition(
                      turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                      child: ScaleTransition(scale: animation, child: child),
                    ),
                    child: expanded
                        ? Text(
                      '$count',
                      key: ValueKey<int>(count),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : Icon(
                      Icons.add,
                      key: const ValueKey('add'),
                      color: Colors.black,
                      size: iconSize,
                    ),
                  ),
                ),
              ),

              /// زر الزيادة
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: expanded
                    ? IconButton(
                  key: const ValueKey('add_more'),
                  icon: Icon(Icons.add,
                      color: Colors.black, size: iconSize),
                  onPressed: () =>
                      cartController.increment(product, unit),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
