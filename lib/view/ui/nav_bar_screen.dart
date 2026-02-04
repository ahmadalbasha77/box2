import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';

import '../../core/app_color.dart';
import '../../controller/main_controller.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final MainController _controller = MainController.to;
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.primaryColor.withOpacity(0.05),
                AppColor.primaryColor.withOpacity(0.02),
                Colors.transparent,
              ],
            ),
          ),
          child: GetBuilder<MainController>(
            builder: (logic) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: child,
                  );
                },
                child: Container(
                  key: ValueKey<int>(_controller.selectedIndex),
                  child: _controller.tabs.elementAt(_controller.selectedIndex),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: CurvedNavBarWidget(),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();

    // إذا كان الزر غير الصفحة الرئيسية
    if (_controller.selectedIndex != 0) {
      _controller.selectedIndex = 0;
      _controller.update();
      return false;
    }

    // للخروج من التطبيق: اضغط مرتين خلال ثانيتين
    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;

      // عرض رسالة تنبيه
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('اضغط مرة أخرى للخروج'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColor.primaryColor,
        ),
      );
      return false;
    }

    return true;
  }
}

class CurvedNavBarWidget extends StatelessWidget {
  final MainController _controller = MainController.to;
  final List<String> _labels = [
    'الرئيسية',
    'الفئات',
    'السلة',
    'البحث',
    'الإشعارات'
  ];
  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.category_outlined,
    Icons.shopping_cart_outlined,
    Icons.search_outlined,
    Icons.notifications_outlined,
  ];
  final List<IconData> _activeIcons = [
    Icons.home,
    Icons.category,
    Icons.shopping_cart,
    Icons.search,
    Icons.notifications,
  ];

  CurvedNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final isTablet = screenWidth > 600;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: GetBuilder<MainController>(builder: (logic) {
        return CurvedNavigationBar(
          index: _controller.selectedIndex,
          height: isTablet ? 70.0 : 65.0,
          color: AppColor.primaryColor,
          buttonBackgroundColor: AppColor.primaryColor,
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 350),
          animationCurve: Curves.easeInOutCubic,
          onTap: (index) {
            // تأثير الاهتزاز عند النقر
            if (index != _controller.selectedIndex) {
              _controller.selectedIndex = index;

              _controller.update();
            }
          },
          items: List.generate(_icons.length, (index) {
            final isActive = _controller.selectedIndex == index;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // الأيقونة مع تأثيرات
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Colors.white.withOpacity(0.9)
                          : Colors.transparent,
                      boxShadow: isActive
                          ? [
                        BoxShadow(
                          color: AppColor.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                          : null,
                    ),
                    child: Icon(
                      isActive ? _activeIcons[index] : _icons[index],
                      size: isTablet ? 28 : 24,
                      color: isActive
                          ? AppColor.primaryColor
                          : Colors.white.withOpacity(0.9),
                    ),
                  ),

                  // النص أسفل الأيقونة
                  const SizedBox(height: 4),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isActive ? 1.0 : 0.7,
                    child: Text(
                      _labels[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 12 : 10,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight
                            .w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      }),
    );
  }
}

// ---------------------------------------------
// تحسين ملف AppColor (ألوان إضافية)
// ---------------------------------------------
// class AppColor {
//   static const Color primaryColor = Color(0xFF6C63FF);
//   static const Color secondaryColor = Color(0xFF4A44C6);
//   static const Color accentColor = Color(0xFFFF6584);
//   static const Color backgroundColor = Color(0xFFF9F9FF);
//   static const Color surfaceColor = Color(0xFFFFFFFF);
//   static const Color textPrimary = Color(0xFF333333);
//   static const Color textSecondary = Color(0xFF666666);
// }