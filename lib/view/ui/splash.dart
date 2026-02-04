import 'package:box_app/core/my_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/login_screen.dart';
import 'nav_bar_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    goToApp();
  }

  void goToApp() async {
    // ننتظر فقط حتى ينتهي تحميل البيانات الأساسية ثم ننتقل
    await Future.delayed(
      const Duration(seconds: 3),
      () => Get.offAll(
        () =>
            mySharedPreferences.isLogin ? const NavBarScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: primary.withOpacity(0.03),
            ),
          ),

          /// 2. المحتوى الرئيسي
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// حاوية الشعار بتصميم Static عالي الجودة
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    // استخدام ظلال متعددة الطبقات لتعطي بعداً بدون حركة
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                      BoxShadow(
                        color: primary.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(35),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 40),

                /// اسم التطبيق بتنسيق فخم وثابت
                Text(
                  "BOX SHOP",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: const Color(0xFF1D1D1F),
                    // لون Apple الشهير
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                /// وصف صغير (Slogan) يزيد من احترافية الواجهة
                Text(
                  "تجربة تسوق فريدة ومميزة".tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// 3. الجزء السفلي (ثابت)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                /// شريط تحميل ثابت وبسيط (Linear)
                Container(
                  width: 150,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                /// حقوق الحقوق أو النسخة
                Text(
                  "© 2026 BOX SHOP. All Rights Reserved",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
