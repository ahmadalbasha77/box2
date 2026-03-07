import 'package:box_app/controller/home/product_controller.dart';
import 'package:box_app/model/home/product_model.dart';
import 'package:box_app/view/ui/product/product_widget.dart';
import 'package:box_app/view/widget/cart_icon_widget.dart';
import 'package:box_app/view/widget/home/brand_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../controller/order/cart_controller.dart';
import '../../../core/app_color.dart';
import '../../../core/font_style.dart';
import '../../widget/cache_image_widget.dart';

class ProductScreen extends StatefulWidget {
  final bool isCart;
  final int subCategoryId;

  const ProductScreen({super.key, this.isCart = true, this.subCategoryId = 0});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // appBar: _buildAppBar(),
      appBar: AppBar(
        title: Text(
          'المنتجات'.tr,
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
      body: GetBuilder<ProductController>(
        init: ProductController(),
        builder: (logic) {
          return Column(
            children: [
              // _buildSearch(logic),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: SearchField(
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
              if (widget.isCart) _buildBrand(),
              _buildList(logic),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBrand() {
    print(widget.subCategoryId);
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: BrandProductWidget(subCategoryId: widget.subCategoryId,),
    );
  }

  Widget _buildList(ProductController logic) {
    return Expanded(
      child: PagedListView<int, ProductData>(
        pagingController: logic.pagingController,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        builderDelegate: PagedChildBuilderDelegate<ProductData>(
          itemBuilder: (context, item, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HorizontalProductCard(data: item),
            );
          },
        ),
      ),
    );
  }
}

class HorizontalProductCard extends StatefulWidget {
  final ProductData data;

  const HorizontalProductCard({super.key, required this.data});

  @override
  State<HorizontalProductCard> createState() => HorizontalProductCardState();
}

class HorizontalProductCardState extends State<HorizontalProductCard> {
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
    const primary = AppColor.primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 165, // زيادة الطول قليلاً لاستيعاب البيانات الجديدة
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 1. IMAGE SECTION WITH BADGES
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(15)),
                  child: CacheImageWidget(
                    image: widget.data.imageUrl,
                    width: 120,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// شارة وصل حديثاً
              if (widget.data.newArrivals)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildBadge("وصل حديثاً".tr, Colors.green),
                ),

              /// شارة عرض مميز
              if (widget.data.offer ?? false)
                Positioned(
                  top: widget.data.newArrivals == true ? 35 : 8,
                  right: 8,
                  child: _buildBadge("عرض خاص".tr, Colors.orange.shade700),
                ),
            ],
          ),

          /// 2. CONTENT SECTION
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// اسم المنتج
                  Text(
                    widget.data.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        fontFamily: 'Cairo'),
                  ),

                  const SizedBox(height: 8),

                  /// الوحدات (Chips)
                  _buildUnitSelector(),

                  const Spacer(),

                  /// تاريخ الانتهاء (بشكل بسيط وواضح)
                  if (widget.data.endDate != null) _buildExpiryDate(),

                  const SizedBox(height: 8),

                  /// PRICE + CART
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.data.offer == true &&
                              selectedUnit.oldPrice != null)
                            Text(
                              '${selectedUnit.oldPrice!.toStringAsFixed(2)} ${'JD'.tr}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            '${selectedUnit.price.toStringAsFixed(2)} ${'JD'.tr}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                      widget.data.isSoldOut
                          ? _buildSoldOutBadge()
                          : HorizontalCartButton(
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

  /// ويدجت الشارات (Badges)
  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// اختيار الوحدات
  Widget _buildUnitSelector() {
    return SizedBox(
      height: 28,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.data.productUnits.map((unit) {
          final selected = unit.id == selectedUnit.id;
          return Padding(
            padding: const EdgeInsets.only(left: 6),
            child: InkWell(
              onTap: () => setState(() => selectedUnit = unit),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: selected ? AppColor.primaryColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: selected
                          ? AppColor.primaryColor
                          : Colors.transparent),
                ),
                child: Text(
                  unit.unit,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// ويدجت تاريخ الانتهاء
  Widget _buildExpiryDate() {
    final bool isExpired = widget.data.endDate!.isBefore(DateTime.now());
    return Row(
      children: [
        Icon(Icons.timer_outlined,
            size: 14, color: isExpired ? Colors.red : Colors.orange),
        const SizedBox(width: 4),
        Text(
          '${'ينتهي:'.tr} ${formatDate(widget.data.endDate!)}',
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isExpired ? Colors.red : Colors.grey[600]),
        ),
      ],
    );
  }

  /// ويدجت نفذت الكمية
  Widget _buildSoldOutBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Text('نفذت'.tr,
          style: const TextStyle(
              color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

/// =================================================================
/// CART BUTTON (COMPACT)
class HorizontalCartButton extends StatelessWidget {
  final ProductData product;
  final ProductUnit unit;

  const HorizontalCartButton({super.key,
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

class SearchField extends StatelessWidget {
  final String hint;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchField({
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
