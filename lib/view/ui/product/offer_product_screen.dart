import 'package:box_app/controller/home/product_controller.dart';
import 'package:box_app/model/home/product_model.dart';
import 'package:box_app/view/widget/cart_icon_widget.dart';
import 'package:box_app/view/widget/home/brand_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../controller/home/offer_product_controller.dart';
import '../../../controller/order/cart_controller.dart';
import '../../../core/app_color.dart';
import '../../../core/font_style.dart';
import '../../widget/cache_image_widget.dart';

class OfferProductScreen extends StatelessWidget {
  final bool isCart;
  final int subCategoryId;

  const OfferProductScreen({super.key, this.isCart = true, this.subCategoryId = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // appBar: _buildAppBar(),
      appBar: AppBar(
        title: Text(
          'عروض مميزة'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        // foregroundColor: Colors.black,
        backgroundColor: AppColor.primaryColor,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: GetBuilder<OfferProductController>(
        init: OfferProductController(),
        builder: (logic) {
          return Column(
            children: [
              // _buildSearch(logic),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: _SearchField(
                  hint: 'ابحث عن منتج'.tr,
                  controller: logic.controllerSearch,
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      logic.refreshScreen();
                    }
                  },
                  onSearch: () => logic.refreshScreen(),
                ),
              ),
              if (isCart) _buildBrand(),
              _buildList(logic),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBrand() {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: BrandProductWidget(subCategoryId: subCategoryId,),
    );
  }

  Widget _buildList(OfferProductController logic) {
    return Expanded(
      child: PagedListView<int, ProductData>(
        pagingController: logic.pagingController,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        builderDelegate: PagedChildBuilderDelegate<ProductData>(
          itemBuilder: (context, item, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _HorizontalProductCard(data: item),
            );
          },
        ),
      ),
    );
  }
}

/// =================================================================
/// PRODUCT CARD (HORIZONTAL – BALANCED)
class _HorizontalProductCard extends StatefulWidget {
  final ProductData data;

  const _HorizontalProductCard({required this.data});

  @override
  State<_HorizontalProductCard> createState() => _HorizontalProductCardState();
}

class _HorizontalProductCardState extends State<_HorizontalProductCard> {
  late ProductUnit selectedUnit;

  @override
  void initState() {
    super.initState();
    selectedUnit = widget.data.productUnits.firstWhere(
      (e) => e.isDefault,
      orElse: () => widget.data.productUnits.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(14),
            ),
            child: CacheImageWidget(
              image: widget.data.imageUrl,
              width: 120,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME
                  Text(
                    widget.data.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),

                  /// UNITS
                  SizedBox(
                    height: 26,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: widget.data.productUnits.map((unit) {
                        final selected = unit.id == selectedUnit.id;
                        return Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: GestureDetector(
                            onTap: () => setState(() => selectedUnit = unit),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColor.primaryColor
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                unit.unit,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  /// PRICE + CART
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${selectedUnit.price.toStringAsFixed(2)} ${'JD'.tr}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      widget.data.isSoldOut
                          ? Text(
                              'نفذت'.tr,
                              style: regular12.copyWith(color: Colors.grey),
                            )
                          : _HorizontalCartButton(
                              product: widget.data,
                              unit: selectedUnit,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =================================================================
/// CART BUTTON (COMPACT)
class _HorizontalCartButton extends StatelessWidget {
  final ProductData product;
  final ProductUnit unit;

  const _HorizontalCartButton({
    required this.product,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cart) {
        final count = cart.quantityOf(product, unit);

        return Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: count > 0 ? AppColor.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: count > 0 ? AppColor.primaryColor : Colors.grey[300]!,
            ),
          ),
          child: count == 0
              ? InkWell(
                  onTap: () => cart.addProduct(product, unit),
                  child:
                      Icon(Icons.add, size: 22, color: AppColor.primaryColor),
                )
              : Row(
                  children: [
                    InkWell(
                      onTap: () => cart.decrement(product, unit),
                      child: const Icon(Icons.remove,
                          size: 22, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => cart.increment(product, unit),
                      child:
                          const Icon(Icons.add, size: 22, color: Colors.white),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hint;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final VoidCallback onSearch;

  const _SearchField({
    required this.onChanged,
    required this.controller,
    required this.hint,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          if (value.trim().isEmpty) {
            onSearch();
          }
          onChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey[500],
            size: 22,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 20),
              onPressed: onSearch,
              padding: EdgeInsets.zero,
            ),
          ),
          hintText: hint,
          hintStyle: regular14.copyWith(color: Colors.grey[500]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
