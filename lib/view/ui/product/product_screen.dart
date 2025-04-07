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

class ProductScreen extends StatelessWidget {
  final bool isCart;

  const ProductScreen({super.key, this.isCart = true});

  // final _controller = ProductController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'المنتجات'.tr,
          style: TextStyle(
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
        child: GetBuilder<ProductController>(
            init: ProductController(),
            builder: (logic) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  SearchTextFiled(
                    hint: 'ابحث عن منتج'.tr,
                    controller: logic.controllerSearch,
                    onChanged: (p0) => logic.searchOnChange(),
                  ),
                  const SizedBox(height: 20),
                  if(isCart)
                  const BrandProductWidget(),
                  if(isCart)
                  const SizedBox(height: 20),
                  Expanded(
                    child: PagedGridView<int, ProductData>(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.64,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      // scrollDirection: Axis.horizontal,
                      pagingController: logic.pagingController,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      builderDelegate: PagedChildBuilderDelegate<ProductData>(
                        itemBuilder: (context, item, index) {
                          return ProductWidget(data: item);
                        },
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  final ProductData data;

  const ProductWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CacheImageWidget(
                  image: data.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: bold14.copyWith(color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.price}',
                  textAlign: TextAlign.center,
                  style: bold16.copyWith(color: AppColor.primaryColor),
                ),
                const SizedBox(height: 10),
                Center(
                    child: data.isSoldOut
                        ? CustomButton(
                            vertical: 5,
                            style: regular12.copyWith(color: Colors.white),
                            color: Colors.grey,
                            title: 'نفذت الكمية'.tr,
                            onTap: () {},
                          )
                        : AnimatedAddRemoveButton(
                            product: data,
                          )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchTextFiled extends StatelessWidget {
  final String hint;
  final void Function(String) onChanged;
  final TextEditingController controller;

  const SearchTextFiled(
      {super.key,
      required this.onChanged,
      required this.controller,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColor.primaryColor,
          ),
          hintText: hint,
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
    );
  }
}

class AnimatedAddRemoveButton extends StatelessWidget {
  final ProductData product;

  const AnimatedAddRemoveButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        int count = cartController.quantityOf(product);
        bool expanded = count > 0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: expanded ? AppColor.primaryColor : AppColor.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: expanded
                    ? IconButton(
                        key: const ValueKey('remove'),
                        icon: const Icon(Icons.remove, color: Colors.white),
                        onPressed: () => cartController.decrement(product),
                      )
                    : const SizedBox.shrink(),
              ),
              GestureDetector(
                onTap: () {
                  if (expanded) {
                    // cartController.removeProduct(product);
                  } else {
                    cartController.addProduct(product);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
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
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        : const Icon(
                            Icons.add,
                            key: ValueKey('add'),
                            color: Colors.white,
                            size: 24,
                          ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: expanded
                    ? IconButton(
                        key: const ValueKey('add_more'),
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => cartController.increment(product),
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
