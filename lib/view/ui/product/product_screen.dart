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
        title: Text(
          "المنتجات".tr,
          style: const TextStyle(
            color: Colors.black,
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
                    onChanged: (value) {
                      if (value.trim().isEmpty) {
                        logic
                            .refreshScreen(); // يرجع البيانات الأصلية إذا الحقل فاضي
                      }
                    },
                    onSearch: () =>
                        logic.refreshScreen(), // ينفذ البحث أو الريفريش
                  ),
                  const SizedBox(height: 20),
                  if (isCart) const BrandProductWidget(),
                  if (isCart) const SizedBox(height: 20),
                  Expanded(
                    child: PagedListView<int, ProductData>(
                      pagingController: logic.pagingController,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      builderDelegate: PagedChildBuilderDelegate<ProductData>(
                        itemBuilder: (context, item, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ProductWidget(data: item),
                          );
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

class SearchTextFiled extends StatelessWidget {
  final String hint;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final VoidCallback onSearch; // إضافة Callback للبحث

  const SearchTextFiled({
    super.key,
    required this.onChanged,
    required this.controller,
    required this.hint,
    required this.onSearch,
  });

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
        controller: controller,
        onChanged: (value) {
          if (value.trim().isEmpty) {
            onSearch(); // يعمل Refresh إذا الحقل فاضي
          }
          onChanged(value); // يمرر القيمة للـ logic
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, color: AppColor.primaryColor),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward, color: AppColor.primaryColor),
            onPressed: onSearch, // ينفذ البحث عند الضغط
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

class ProductWidget extends StatefulWidget {
  final ProductData data;

  const ProductWidget({super.key, required this.data});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late ProductUnit selectedUnit;

  @override
  void initState() {
    super.initState();
    selectedUnit = widget.data.productUnits.isNotEmpty
        ? widget.data.productUnits.firstWhere(
          (e) => e.isDefault,
      orElse: () => widget.data.productUnits.first,
    )
        : ProductUnit(
        id: 0, unit: '', price: 0, size: 0, quantity: 0, isDefault: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
      child: Row(
        children: [
          /// صورة المنتج
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: InteractiveViewer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CacheImageWidget(
                          image: widget.data.imageUrl,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CacheImageWidget(
                image: widget.data.imageUrl,
                width: 110,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// التفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// الاسم
                Text(
                  widget.data.name,
                  style: bold16.copyWith(color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                /// قائمة اختيار الوحدة
                if (widget.data.productUnits.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.data.productUnits.map((unit) {
                      final isSelected = unit.id == selectedUnit.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedUnit = unit;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primaryColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            unit.unit,
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.black : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 10),

                /// السعر
                Text(
                  '${selectedUnit.price.toStringAsFixed(2)} ${'JD'.tr}',
                  style: bold16.copyWith(color: AppColor.primaryColor),
                ),

                const SizedBox(height: 8),

                /// زر إضافة أو نفذت الكمية
                widget.data.isSoldOut
                    ? CustomButton(
                  vertical: 4,
                  style: regular12.copyWith(color: Colors.white),
                  color: Colors.grey,
                  title: 'نفذت الكمية'.tr,
                  onTap: () {},
                )
                    : AnimatedAddRemoveButton(
                  product: widget.data,
                  unit: selectedUnit,
                  iconSize: 16,
                  buttonSize: 28,
                  fontSize: 12,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedAddRemoveButton extends StatelessWidget {
  final ProductData product;
  final ProductUnit unit;
  final double iconSize;
  final double buttonSize;
  final double fontSize;

  const AnimatedAddRemoveButton({
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
