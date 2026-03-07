import 'package:box_app/controller/category/brand_product_controller.dart';
import 'package:box_app/controller/home/product_controller.dart';
import 'package:box_app/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class BrandProductWidget extends StatelessWidget {
  final int subCategoryId;

  const BrandProductWidget({super.key, required this.subCategoryId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GetBuilder<BrandProductController>(
        init: BrandProductController(subCategoryId),
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

