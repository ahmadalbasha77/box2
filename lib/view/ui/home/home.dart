import 'package:box_app/controller/home/ads_controller.dart';
import 'package:box_app/core/app_color.dart';
import 'package:box_app/core/font_style.dart';
import 'package:box_app/core/my_shared_preferences.dart';
import 'package:box_app/core/utils.dart';
import 'package:box_app/network/rest_api.dart';
import 'package:box_app/view/ui/cart/order_screen.dart';
import 'package:box_app/view/ui/product/product_screen.dart';
import 'package:box_app/view/widget/home/brand_list_widget.dart';
import 'package:box_app/view/widget/home/category_home_list_widget.dart';
import 'package:box_app/view/widget/home/section_widget.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../controller/home/best_seller_product_controller.dart';
import '../../../controller/order/cart_controller.dart';
import '../../../model/home/product_model.dart';
import '../../widget/cache_image_widget.dart';
import '../auth/login_screen.dart';
import 'home_quick_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColor.primaryColor,
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 40, color: AppColor.primaryColor),
                  ),
                  const SizedBox(width: 16),
                  mySharedPreferences.isLogin
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mySharedPreferences.userName,
                                style: bold18.copyWith(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 0),
                              Text(
                                mySharedPreferences.email,
                                style: const TextStyle(color: Colors.white70),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      : Text(
                          'ضيف'.tr,
                          style: bold18.copyWith(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ],
              ),
            ),
            if (mySharedPreferences.isLogin) ...[
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: Text('طلباتي'.tr),
                onTap: () {
                  Get.to(() => OrderScreen());
                  // Navigate to orders screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('language'.tr),
                onTap: () {
                  Utils.changeLanguage();
                  // Implement logout
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_support_outlined),
                title: Text('تواصل معنا'.tr),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text('اختر رقم للتواصل'.tr),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.phone),
                              title: const Text('0791131013'),
                              onTap: () {
                                Navigator.pop(context);
                                Utils.launchNumber('0791131013');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.phone),
                              title: const Text('0799310625'),
                              onTap: () {
                                Navigator.pop(context);
                                Utils.launchNumber('0799310625');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text('سياسة الخصوصية'.tr),
                onTap: () {
                  Utils.launchURL(
                      'https://sites.google.com/view/kabsetzr/home');
                  // Implement logout
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever_outlined),
                title: Text('حذف الحساب'.tr),
                onTap: () async {
                  if (await Utils.showAreYouSureDialog(
                      title: 'حذف الحساب'.tr)) {
                    Utils.showLoadingDialog();
                    bool success = await RestApi.deleteAccount();
                    if (success) {
                      Utils.hideLoadingDialog();

                      mySharedPreferences.clearProfile();
                      Get.offAll(() => LoginScreen());
                      Utils.showSnackbar('successfully !'.tr,
                          'Account deleted successfully'.tr);
                    } else {
                      Utils.showSnackbar('Failed Account deleted ! '.tr,
                          'Please try again'.tr);
                    }
                  }
                  // Implement logout
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text('تسجيل الخروج'.tr),
                onTap: () async {
                  if (await Utils.showAreYouSureDialog(
                      title: 'تسجيل خروج'.tr)) {
                    mySharedPreferences.clearProfile();
                    return Get.offAll(() => LoginScreen());
                  }
                  // Implement logout
                },
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('language'.tr),
                onTap: () {
                  Utils.changeLanguage();
                  // Implement logout
                },
              ),
              ListTile(
                leading: const Icon(Icons.login),
                title: Text('تسجيل دخول'.tr),
                onTap: () async {
                  return Get.to(() => LoginScreen(
                        isOpen: true,
                      ));
                  // Implement logout
                },
              ),
            ]
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              /// Drawer Button (Circle + Shadow)
              Builder(
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 24,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  );
                },
              ),

              const SizedBox(width: 12),

              /// Search Bar (Floating Card)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const ProductScreen());
                  },
                  child: AbsorbPointer(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ابحث عن منتجات...'.tr,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColor.primaryColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                AdsWidget(),
                // const SizedBox(height: 24),
                // const HomeQuickCards(), // 👈 الكاردات هون

                const SizedBox(height: 0),

                // const SectionWidget(title: 'المنتجات الجديدة'),
                // const SizedBox(
                //   height: 20,
                // ),
              ],
            ),
          ),
          // BestSellerProductWidget(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SectionWidget(
                  title: 'الأصناف',
                ),
                CategoryHomeListWidget(),
                const SizedBox(
                  height: 20,
                ),
                const SectionWidget(title: 'المنتجات الاكثر مبيعا'),
              ],
            ),
          ),
          BestSellerProductWidget(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionWidget(
                  title: 'العلامات الغذائية',
                  actionText: 'See All'.tr,
                ),
                BrandListWidget(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class BestSellerProductWidget extends StatelessWidget {
  BestSellerProductWidget({super.key});

  final _controller = BestSellerProductController.to;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BestSellerProductController>(
      builder: (logic) {
        if (logic.isLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (logic.product.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text('لا يوجد بيانات'.tr)),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: 340, // 👈 ارتفاع الكروت
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: logic.product.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 230, // 👈 عرض كرت المنتج
                    child: ProductHorizontalWidget(
                      data: logic.product[index],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ProductHorizontalWidget extends StatefulWidget {
  final ProductData data;

  const ProductHorizontalWidget({super.key, required this.data});

  @override
  State<ProductHorizontalWidget> createState() =>
      _ProductHorizontalWidgetState();
}

class _ProductHorizontalWidgetState extends State<ProductHorizontalWidget> {
  late ProductUnit selectedUnit;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    selectedUnit = widget.data.productUnits.isNotEmpty
        ? widget.data.productUnits.firstWhere(
            (e) => e.isDefault,
            orElse: () => widget.data.productUnits.first,
          )
        : ProductUnit(
            id: 0,
            unit: '',
            price: 0,
            size: 0,
            quantity: 0,
            isDefault: true,
          );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _showProductBottomSheet(context),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 220,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColor.primaryColor.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
            border: Border.all(
              color: Colors.grey.shade100,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// صورة المنتج مع زر التكبير
              Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade50,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CacheImageWidget(
                        image: widget.data.imageUrl,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  /// شارة المنتج الأكثر مبيعاً
                  // Positioned(
                  //   top: 8,
                  //   left: 8,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 8,
                  //       vertical: 4,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: [
                  //           AppColor.primaryColor,
                  //           AppColor.primaryColor.withOpacity(0.8),
                  //         ],
                  //         begin: Alignment.topLeft,
                  //         end: Alignment.bottomRight,
                  //       ),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: const Text(
                  //       '🔥 الأكثر مبيعاً',
                  //       style: TextStyle(
                  //         fontSize: 10,
                  //         fontWeight: FontWeight.w700,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  /// زر التكبير
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _showImageDialog(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.zoom_in,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// اسم المنتج
              Text(
                widget.data.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              /// الوحدات (الحجم/الوزن)
              if (widget.data.productUnits.isNotEmpty)
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.data.productUnits.length,
                    itemBuilder: (context, index) {
                      final unit = widget.data.productUnits[index];
                      final isSelected = unit.id == selectedUnit.id;
                      return GestureDetector(
                        onTap: () => setState(() => selectedUnit = unit),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primaryColor
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColor.primaryColor.withOpacity(0.3)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              unit.unit,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 6),
                  ),
                ),

              const Spacer(),

              /// السعر وزر الإضافة
              Container(
                padding: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// السعر
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السعر',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${selectedUnit.price.toStringAsFixed(2)} ${'JD'.tr}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// زر الإضافة/الإزالة
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.data.isSoldOut
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.shade100,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.block,
                                size: 14,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'نفذت',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        )
                      : AnimatedAddRemoveButton(
                          product: widget.data,
                          unit: selectedUnit,
                          iconSize: 16,
                          buttonSize: 32,
                          fontSize: 13,
                          // borderRadius: 8,
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );

  }

  void _showProductBottomSheet(BuildContext context) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.6,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Drag Indicator
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    /// Image + Close
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CacheImageWidget(
                            image: widget.data.imageUrl,
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.45),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Product Name
                    Text(
                      widget.data.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Divider(color: Colors.grey.shade200),

                    const SizedBox(height: 14),

                    /// Units
                    if (widget.data.productUnits.isNotEmpty)
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: widget.data.productUnits.map((unit) {
                          final isSelected = unit.id == selectedUnit.id;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => selectedUnit = unit),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.primaryColor
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isSelected
                                    ? [
                                  BoxShadow(
                                    color: AppColor.primaryColor
                                        .withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                                    : [],
                              ),
                              child: Text(
                                unit.unit,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 28),

                    /// Price Card
                    Card(
                      elevation: 0,
                      color: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'السعر',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${selectedUnit.price.toStringAsFixed(2)} ${'JD'.tr}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// Add To Cart CTA
                    SizedBox(
                      width: double.infinity,
                      child: widget.data.isSoldOut
                          ? Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            'نفذت الكمية',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                          : PremiumAddToCartButton(
                        product: widget.data,
                        unit: selectedUnit,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CacheImageWidget(
                    image: widget.data.imageUrl,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.7,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class PremiumAddToCartButton extends StatelessWidget {
  final ProductData product;
  final ProductUnit unit;

  const PremiumAddToCartButton({
    super.key,
    required this.product,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cart) {
        final count = cart.quantityOf(product, unit);
        final expanded = count > 0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 56,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: expanded
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stepButton(
                icon: Icons.remove,
                onTap: () => cart.decrement(product, unit),
              ),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              _stepButton(
                icon: Icons.add,
                onTap: () => cart.increment(product, unit),
              ),
            ],
          )
              : InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => cart.addProduct(product, unit),
            child: const Center(
              child: Text(
                'أضف إلى السلة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _stepButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Icon(
          icon,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

// class BestSellerProductWidget extends StatelessWidget {
//   BestSellerProductWidget({super.key});
//
//   final _controller = BestSellerProductController.to;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BestSellerProductController>(
//       builder: (logic) => logic.isLoading
//           ? const SliverToBoxAdapter(
//               child: Center(child: CircularProgressIndicator()))
//           : logic.product.isEmpty
//               ? SliverToBoxAdapter(
//                   child: Center(child: Text('لا يوجد بيانات'.tr)))
//               : SliverPadding(
//                   padding: const EdgeInsets.all(20),
//                   sliver: SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) => Padding(
//                         padding: const EdgeInsets.only(bottom: 10),
//                         child: ProductWidget(data: logic.product[index]),
//                       ),
//                       childCount: logic.product.length,
//                     ),
//                   ),
//                 ),
//     );
//   }
// }

class AdsWidget extends StatelessWidget {
  AdsWidget({super.key});

  final _controller = AdsController.to;

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 160,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 8,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                height: 8,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                height: 8,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(
        builder: (logic) => _controller.isLoading == true
            ? _buildShimmer()
            : _controller.ads.isEmpty
                ? Center(child: Text('لا يوجد بيانات'.tr))
                : Column(
                    children: [
                      CarouselSlider(
                        items: _controller.ads
                            .map((image) => ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CacheImageWidget(
                                    image: image.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ))
                            .toList(),
                        options: CarouselOptions(
                          onPageChanged: _controller.onPageChanged,
                          aspectRatio: 12 / 5,
                          viewportFraction: 0.9,
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: _controller.current,
                          count: _controller.ads.length,
                          effect: const ExpandingDotsEffect(
                            activeDotColor: AppColor.primaryColor,
                            dotHeight: 8,
                            dotWidth: 8,
                          ),
                        ),
                      ),
                    ],
                  ));
  }
}
