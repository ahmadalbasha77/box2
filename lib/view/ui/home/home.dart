import 'package:box_app/controller/home/ads_controller.dart';
import 'package:box_app/core/app_color.dart';
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
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../controller/home/best_seller_product_controller.dart';
import '../../../controller/order/cart_controller.dart';
import '../../../model/home/product_model.dart';
import '../../widget/cache_image_widget.dart';
import '../auth/login_screen.dart';
import '../product/product_widget.dart';
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
        width: 320,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color(0xFFF8FAFD),
              ],
            ),
          ),
          child: Column(
            children: [
              // Header Section
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryColor,
                      AppColor.primaryColor.withOpacity(0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 34,
                          color: AppColor.primaryColor,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // User Info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: mySharedPreferences.isLogin
                              ? [
                                  Text(
                                    mySharedPreferences.userName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Cairo',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    mySharedPreferences.email,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'حساب مفعل',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ]
                              : [
                                  Text(
                                    'ضيف'.tr,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                        Get.to(() => LoginScreen(isOpen: true));
                                      },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.login_rounded,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'تسجيل الدخول',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Menu Items
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      if (mySharedPreferences.isLogin) ...[
                        _MenuTile(
                          icon: Icons.shopping_bag_outlined,
                          title: 'طلباتي'.tr,
                          onTap: () {
                            Get.back();
                            Get.to(() => OrderScreen());
                          },
                          color: const Color(0xFF4CAF50),
                        ),
                      ],

                      _MenuTile(
                        icon: Icons.language_rounded,
                        title: 'language'.tr,
                        onTap: () {
                          Get.back();
                          Utils.changeLanguage();
                        },
                        color: const Color(0xFF2196F3),
                      ),

                      _MenuTile(
                        icon: Icons.phone_rounded,
                        title: 'تواصل معنا'.tr,
                        onTap: () {
                          Get.back();
                          _showContactDialog(context);
                        },
                        color: const Color(0xFFFF9800),
                      ),

                      _MenuTile(
                        icon: Icons.security_rounded,
                        title: 'سياسة الخصوصية'.tr,
                        onTap: () {
                          Get.back();
                          Utils.launchURL(
                              'https://sites.google.com/view/kabsetzr/home');
                        },
                        color: const Color(0xFF9C27B0),
                      ),

                      if (mySharedPreferences.isLogin) ...[
                        _MenuTile(
                          icon: Icons.delete_forever_rounded,
                          title: 'حذف الحساب'.tr,
                          onTap: () async {
                            Get.back();
                            if (await Utils.showAreYouSureDialog(
                                title: 'حذف الحساب'.tr)) {
                              Utils.showLoadingDialog();
                              bool success = await RestApi.deleteAccount();
                              Utils.hideLoadingDialog();

                              if (success) {
                                mySharedPreferences.clearProfile();
                                Get.offAll(() => LoginScreen());
                                Utils.showSnackbar(
                                    'نجاح!'.tr, 'تم حذف الحساب بنجاح'.tr);
                              } else {
                                Utils.showSnackbar(
                                    'فشل!'.tr, 'يرجى المحاولة مرة أخرى'.tr);
                              }
                            }
                          },
                          color: const Color(0xFFF44336),
                          isWarning: true,
                        ),
                        _MenuTile(
                          icon: Icons.logout_rounded,
                          title: 'تسجيل الخروج'.tr,
                          onTap: () async {
                            Get.back();
                            if (await Utils.showAreYouSureDialog(
                                title: 'تسجيل خروج'.tr)) {
                              mySharedPreferences.clearProfile();
                              Get.offAll(() => LoginScreen());
                            }
                          },
                          color: const Color(0xFF607D8B),
                        ),
                      ] else ...[
                        _MenuTile(
                          icon: Icons.login_rounded,
                          title: 'تسجيل دخول'.tr,
                          onTap: () async {
                            Get.back();
                            Get.to(() => LoginScreen(isOpen: true));
                          },
                          color: AppColor.primaryColor,
                          isHighlighted: true,
                        ),
                      ],

                      // App Version / Footer
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            Divider(
                              color: Colors.grey[200],
                              height: 1,
                              indent: 24,
                              endIndent: 24,
                            ),
                            const SizedBox(height: 16),
                            // Text(
                            //   'الإصدار 1.0.0',
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.w500,
                            //     color: Colors.grey[500],
                            //   ),
                            // ),
                            const SizedBox(height: 4),
                            Text(
                              '© 2026 جميع الحقوق محفوظة',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

      /*
        appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 180,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.primaryColor,
                AppColor.primaryColor.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor.withOpacity(0.4),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Bar Content
                Row(
                  children: [
                    // Menu Button
                    _CircularIconButton(
                      icon: Icons.menu_rounded,
                      onTap: () => Scaffold.of(context).openDrawer(),
                      color: Colors.white,
                      iconColor: AppColor.primaryColor,
                    ),

                    const Spacer(),

                    // App Title
                    Text(
                      'متجرك'.tr,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        letterSpacing: -0.5,
                      ),
                    ),

                    const Spacer(),

                    // Cart Icon
                    _CircularIconButton(
                      icon: Icons.shopping_cart_outlined,
                      onTap: () => Get.to(() => CartScreen()),
                      color: Colors.white,
                      iconColor: AppColor.primaryColor,
                      badgeCount: CartController.to.cartItems.length,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Premium Search Bar
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 12),
                        child: Icon(
                          Icons.search_rounded,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.to(() => const ProductScreen()),
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'ابحث عن منتج أو ماركة...'.tr,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.filter_alt_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
       */

// Reusable Circular Icon Button Component

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
                const SizedBox(height: 24),
                const PremiumHomeQuickButtons(), // 👈 الكاردات هون

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

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;
  final int badgeCount;

  const _CircularIconButton({
    required this.icon,
    required this.onTap,
    required this.color,
    required this.iconColor,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              splashColor: iconColor.withOpacity(0.2),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  badgeCount > 9 ? '9+' : '$badgeCount',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

void _showContactDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_rounded,
                      color: Color(0xFFFF9800),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'اختر رقم للتواصل'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _ContactTile(
                number: '0791131013',
                onTap: () {
                  Navigator.pop(context);
                  Utils.launchNumber('0791131013');
                },
              ),
              const SizedBox(height: 12),
              _ContactTile(
                number: '0799310625',
                onTap: () {
                  Navigator.pop(context);
                  Utils.launchNumber('0799310625');
                },
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'إغلاق'.tr,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Menu Tile Widget
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;
  final bool isWarning;
  final bool isHighlighted;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
    this.isWarning = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          splashColor: color.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color:
                  isHighlighted ? color.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: isHighlighted
                  ? Border.all(
                      color: color.withOpacity(0.3),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isHighlighted ? FontWeight.w800 : FontWeight.w600,
                      color: isWarning ? Colors.red[700] : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Contact Tile Widget
class _ContactTile extends StatelessWidget {
  final String number;
  final VoidCallback onTap;

  const _ContactTile({
    required this.number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_rounded,
                  color: Color(0xFFFF9800),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اتصل الآن',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      number,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
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
            oldPrice: 0,
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
                                color:
                                    isSelected ? Colors.white : Colors.black87,
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
                      : AnimatedAddRemoveButton2(
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
      elevation: 0,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          snap: true,
          builder: (context, scrollController) {
            // استخدام StatefulBuilder لتحديث الحالة داخل الـ BottomSheet
            return StatefulBuilder(builder: (context, setState) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    /// 1. المقبض العلوي (Drag Handle)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeroImage(context),

                              const SizedBox(height: 24),

                              /// اسم المنتج
                              Text(
                                widget.data.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Cairo',
                                  color: Colors.black,
                                ),
                              ),

                              /// عرض تاريخ الانتهاء (إذا وجد)
                              if (widget.data.endDate != null) ...[
                                const SizedBox(height: 16),
                                Builder(builder: (context) {
                                  // حساب إذا كان المنتج منتهي الصلاحية أم لا
                                  final bool isExpired = widget.data.endDate!
                                      .isBefore(DateTime.now());
                                  final Color statusColor = isExpired
                                      ? Colors.red
                                      : AppColor.primaryColor;

                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: statusColor.withOpacity(0.2),
                                          width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isExpired
                                              ? Icons.error_outline_rounded
                                              : Icons.timer_outlined,
                                          color: statusColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isExpired
                                                    ? 'المنتج منتهي الصلاحية'.tr
                                                    : 'تاريخ انتهاء الصلاحية'
                                                        .tr,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: statusColor,
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                              Text(
                                                // استخدام دالة فورمات التاريخ الخاصة بك
                                                formatDate(
                                                    widget.data.endDate!),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  color: statusColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],

                              const SizedBox(height: 24),

                              /// اختيار الوحدات
                              _buildUnitSelector(setState),

                              const SizedBox(height: 32),

                              /// قسم السعر والكمية (التفاعلي)
                              _buildPriceAndActionSection(),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        );
      },
    );
  }

  /// بناء قسم الصورة
  Widget _buildHeroImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 260,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(28),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: CacheImageWidget(
              image: widget.data.imageUrl,
              height: 260,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.close_rounded,
                  size: 20, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  /// بناء اختيار الوحدات
  Widget _buildUnitSelector(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختر الوحدة'.tr,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo')),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: widget.data.productUnits.map((unit) {
            bool isSelected = unit.id == selectedUnit.id;
            return InkWell(
              onTap: () => setState(() => selectedUnit = unit),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.primaryColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isSelected
                          ? AppColor.primaryColor
                          : Colors.transparent),
                ),
                child: Text(
                  unit.unit,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// بناء السعر وأزرار التحكم بالكمية
  Widget _buildPriceAndActionSection() {
    return GetBuilder<CartController>(
      builder: (cartController) {
        final quantity = cartController.quantityOf(widget.data, selectedUnit);
        final isSoldOut = widget.data.isSoldOut;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('السعر الإجمالي'.tr,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13)),
                      Text(
                        '${(selectedUnit.price * (quantity > 0 ? quantity : 1)).toStringAsFixed(2)} JD',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColor.primaryColor),
                      ),
                    ],
                  ),
                  if (quantity > 0)
                    _buildQuantityCounter(cartController, quantity),
                ],
              ),
              const SizedBox(height: 20),

              /// زر الإضافة الرئيسي (يظهر فقط إذا كانت الكمية 0)
              if (quantity == 0) _buildAddButton(cartController, isSoldOut)
            ],
          ),
        );
      },
    );
  }

  /// زر "أضف للسلة" للمرة الأولى
  Widget _buildAddButton(CartController cartController, bool isSoldOut) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isSoldOut
            ? null
            : () {
                cartController.addProduct(widget.data, selectedUnit);
                HapticFeedback.lightImpact();
                // لا نغلق الشيت هنا، فقط نعطي إشعاراً بسيطاً
                Get.rawSnackbar(
                  message: 'تمت الإضافة للسلة'.tr,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: AppColor.primaryColor,
                  duration: const Duration(seconds: 1),
                  margin: const EdgeInsets.all(15),
                  borderRadius: 10,
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSoldOut ? Colors.grey : AppColor.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: Text(
          isSoldOut ? 'نفذت الكمية'.tr : 'أضف إلى السلة'.tr,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// عداد الكمية (يظهر بعد أول إضافة)
  Widget _buildQuantityCounter(CartController cartController, int quantity) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          _counterButton(Icons.remove_rounded,
              () => cartController.decrement(widget.data, selectedUnit)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text('$quantity',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _counterButton(Icons.add_rounded,
              () => cartController.increment(widget.data, selectedUnit)),
        ],
      ),
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: () {
        onTap();
        HapticFeedback.selectionClick();
      },
      icon: Icon(icon, color: AppColor.primaryColor),
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
