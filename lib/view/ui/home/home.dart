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
import '../../widget/cache_image_widget.dart';
import '../auth/login_screen.dart';

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
                  Expanded(
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
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('طلباتي '),
              onTap: () {
                Get.to(() => OrderScreen());
                // Navigate to orders screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support_outlined),
              title: const Text('تواصل معنا'),
              onTap: () {
                Utils.launchNumber('0782495807');
                // Implement logout
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.rate_review_outlined),
            //   title: const Text('قيم التطبيق'),
            //   onTap: () {
            //     // Implement logout
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('سياسة الخصوصية'),
              onTap: () {
                Utils.launchURL('https://sites.google.com/view/kabsetzr/home');
                // Implement logout
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined),
              title: const Text('حذف الحساب'),
              onTap: () async {
                if (await Utils.showAreYouSureDialog(title: 'حذف الحساب'.tr)) {
                  Utils.showLoadingDialog();
                  bool success = await RestApi.deleteAccount();
                  if (success) {
                    Utils.hideLoadingDialog();

                    mySharedPreferences.clearProfile();
                    Get.offAll(() => LoginScreen());
                    Utils.showSnackbar(
                        'successfully! ', 'Account deleted successfully');
                  } else {
                    Utils.showSnackbar(
                        'Failed Account deleted ! ', 'Please try again');
                  }
                }
                // Implement logout
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('تسجيل الخروج'),
              onTap: () async {
                if (await Utils.showAreYouSureDialog(title: 'تسجيل خروج'.tr)) {
                  mySharedPreferences.clearProfile();
                  return Get.offAll(() => LoginScreen());
                }
                // Implement logout
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        title: Text('الصفحة الرئيسية',
            style: bold18.copyWith(color: Colors.white)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              readOnly: true,
              onTap: () {
                Get.to(() => const ProductScreen());
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن منتجات...',
                prefixIcon:
                    const Icon(Icons.search, color: AppColor.primaryColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
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
                const SizedBox(height: 20),
                const SectionWidget(title: 'العلامات الغذائية'),
                BrandListWidget(),
                const SectionWidget(title: 'الأصناف', actionText: 'عرض الكل'),
                CategoryHomeListWidget(),
                const SectionWidget(title: 'المنتجات الأكثر مبيعاً'),
              ],
            ),
          ),
          BestSellerProductWidget()
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
      builder: (logic) => _controller.isLoading == true
          ? const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()))
          : _controller.product.isEmpty
              ? const SliverToBoxAdapter(
                  child: Center(child: Text('لا يوجد بيانات')))
              : SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: GetBuilder<BestSellerProductController>(
                    builder: (logic) => logic.isLoading
                        ? const SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()))
                        : logic.product.isEmpty
                            ? const SliverToBoxAdapter(
                                child: Center(child: Text('لا يوجد بيانات')))
                            : SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.64,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (_, index) =>
                                      ProductWidget(data: logic.product[index]),
                                  childCount: logic.product.length,
                                ),
                              ),
                  ),
                ),
    );
  }
}

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
                ? const Center(child: Text('لا يوجد بيانات'))
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
                          aspectRatio: 16 / 7,
                          viewportFraction: 0.8,
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
