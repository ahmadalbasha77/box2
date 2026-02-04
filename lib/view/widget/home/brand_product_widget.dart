import 'package:box_app/controller/category/brand_product_controller.dart';
import 'package:box_app/controller/home/product_controller.dart';
import 'package:box_app/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class BrandProductWidget extends StatefulWidget {
  final int subCategoryId;

  const BrandProductWidget({super.key, required this.subCategoryId});

  @override
  State<BrandProductWidget> createState() => _BrandProductWidgetState();
}

class _BrandProductWidgetState extends State<BrandProductWidget> {
  final controller = BrandProductController.to;

  @override
  void initState() {
    controller.subCategoryId = widget.subCategoryId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GetBuilder<BrandProductController>(
        init: BrandProductController(),
        builder: (logic) {
          if (logic.isLoading) {
            return _buildLoadingShimmer();
          }

          if (logic.brand.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.grey[100]!,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: logic.brand.length,
              itemBuilder: (context, index) {
                final brand = logic.brand[index];
                final isSelected = logic.idSelected == brand.id;

                return _BrandCard(
                  brand: brand,
                  isSelected: isSelected,
                  onTap: () {
                    if (!isSelected) {
                      final controller = ProductController.to;
                      logic.idSelected = brand.id;
                      controller.brandId = brand.id;
                      controller.refreshScreen();
                      logic.update();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 120,
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BrandCard extends StatefulWidget {
  final dynamic brand;
  final bool isSelected;
  final VoidCallback onTap;

  const _BrandCard({
    required this.brand,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_BrandCard> createState() => __BrandCardState();
}

class __BrandCardState extends State<_BrandCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColor.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isSelected
                  ? AppColor.primaryColor.withOpacity(0.3)
                  : Colors.grey[200]!,
              width: widget.isSelected ? 0 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? AppColor.primaryColor.withOpacity(0.25)
                    : Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
                blurRadius: widget.isSelected
                    ? 16
                    : _isHovered
                        ? 12
                        : 8,
                offset: Offset(
                    0,
                    widget.isSelected
                        ? 6
                        : _isHovered
                            ? 4
                            : 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Brand Logo
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.brand.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.business_rounded,
                          size: 18,
                          color: widget.isSelected
                              ? AppColor.primaryColor
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Brand Name
                Text(
                  widget.brand.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: widget.isSelected ? Colors.white : Colors.black87,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Alternative: Minimal Brand Tabs
class _MinimalBrandTabs extends StatelessWidget {
  final dynamic brand;
  final bool isSelected;
  final VoidCallback onTap;

  const _MinimalBrandTabs({
    required this.brand,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          brand.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

// Alternative: Premium Brand Cards
class _PremiumBrandCard extends StatefulWidget {
  final dynamic brand;
  final bool isSelected;
  final VoidCallback onTap;

  const _PremiumBrandCard({
    required this.brand,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PremiumBrandCard> createState() => __PremiumBrandCardState();
}

class __PremiumBrandCardState extends State<_PremiumBrandCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 140,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      AppColor.primaryColor,
                      AppColor.primaryColor.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white,
                    ],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected ? Colors.transparent : Colors.grey[200]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? AppColor.primaryColor.withOpacity(0.3)
                    : Colors.black.withOpacity(_isHovered ? 0.06 : 0.03),
                blurRadius: widget.isSelected ? 20 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Brand Logo
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? Colors.white.withOpacity(0.9)
                      : Colors.grey[50],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected
                        ? Colors.white.withOpacity(0.3)
                        : Colors.grey[200]!,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.brand.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.storefront_rounded,
                      color: widget.isSelected
                          ? AppColor.primaryColor
                          : Colors.grey[600],
                      size: 22,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Brand Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  textAlign: TextAlign.center,
                  widget.brand.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: widget.isSelected ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
