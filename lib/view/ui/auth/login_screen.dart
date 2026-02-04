import 'package:box_app/core/font_style.dart';
import 'package:box_app/view/ui/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth/login_controller.dart';
import '../../../core/app_color.dart';
import '../../widget/auth/custom_text_filed.dart';
import '../../widget/auth/signup_button.dart';
import '../../widget/custom_button.dart';

class LoginScreen extends StatelessWidget {
  final bool isOpen;
  LoginScreen({super.key, this.isOpen = false});

  final _controller = LoginController.to;

  @override
  Widget build(BuildContext context) {
    final primary = AppColor.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 1. الجزء العلوي (خلفية ملونة مع الصورة)
            Container(
              height: MediaQuery.sizeOf(context).height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Center(
                child: SafeArea(
                  child: Image.asset(
                    'assets/images/login.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            /// 2. محتوى تسجيل الدخول
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    /// نصوص الترحيب باللغة العربية
                    Text(
                      "مرحباً بك مجدداً!".tr,
                      style: bold24.copyWith(color: Colors.black, fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "يسعدنا رؤيتك مرة أخرى، قم بتسجيل الدخول لحسابك.".tr,
                      style: medium14.copyWith(color: Colors.grey),
                    ),

                    const SizedBox(height: 40),

                    /// حقل البريد الإلكتروني
                    CustomTextFiled(
                      label: 'البريد الإلكتروني'.tr,
                      icon: Icons.email_outlined,
                      controller: _controller.email,
                    ),
                    const SizedBox(height: 20),

                    /// حقل كلمة المرور
                    GetBuilder<LoginController>(builder: (logic) {
                      return CustomTextFiled(
                        obscureText: _controller.isObsecure,
                        suffixIcon: IconButton(
                          onPressed: () => _controller.togglePassword(),
                          icon: Icon(
                            _controller.isObsecure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: _controller.isObsecure
                                ? Colors.grey
                                : primary,
                          ),
                        ),
                        label: 'كلمة المرور'.tr,
                        icon: Icons.lock_outline,
                        controller: _controller.password,
                      );
                    }),

                    const SizedBox(height: 35),

                    /// زر تسجيل الدخول
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: CustomButton(
                        title: 'تسجيل الدخول'.tr,
                        onTap: () => _controller.login(),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// أزرار الإنشاء والضيف
                    Center(
                      child: Column(
                        children: [
                          const SignUpButton(),
                          const SizedBox(height: 10),
                          if (!isOpen)
                            TextButton(
                              onPressed: () {
                                Get.offAll(() => const NavBarScreen());
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "المتابعة كزائر".tr,
                                    style: medium16.copyWith(
                                      color: Colors.grey.shade600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(Icons.arrow_forward, size: 16, color: Colors.grey.shade600),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}