import 'package:box_app/core/font_style.dart';
import 'package:box_app/core/validation.dart';
import 'package:box_app/view/widget/auth/area_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth/sign_up_controller.dart';
import '../../../core/app_color.dart';
import '../../widget/auth/custom_text_filed.dart';
import '../../widget/custom_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _controller = SignUpController.to;

  @override
  Widget build(BuildContext context) {
    final primary = AppColor.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 1. الجزء العلوي الموحد (الهوية البصرية)
            Container(
              height: MediaQuery.sizeOf(context).height * 0.28,
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
                    'assets/images/signup.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Form(
                key: _controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    Text(
                      "إنشاء حساب جديد".tr,
                      style: bold24.copyWith(color: Colors.black, fontSize: 26),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "أدخل بياناتك للانضمام إلينا والبدء بالتسوق".tr,
                      style: medium14.copyWith(color: Colors.grey),
                    ),

                    const SizedBox(height: 25),

                    /// حقل البريد الإلكتروني
                    // CustomTextFiled(
                    //     validator: (email) => Validation.isEmail(email),
                    //     label: 'البريد الإلكتروني'.tr,
                    //     icon: Icons.email_outlined,
                    //     controller: _controller.email),
                    //
                    // const SizedBox(height: 15),

                    /// الصف الأول: اسم المستخدم + الاسم الكامل
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFiled(
                              label: 'اسم المستخدم'.tr,
                              icon: Icons.person_outline_rounded,
                              controller: _controller.userName),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFiled(
                              label: 'اسم المندوب'.tr,
                              icon: Icons.badge_outlined,
                              controller: _controller.name),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// الصف الثاني: اسم المتجر + رقم الهاتف
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFiled(
                              label: 'المتجر'.tr,
                              icon: Icons.store_outlined,
                              controller: _controller.shopName),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFiled(
                              keyboardType: TextInputType.phone,
                              validator: (text) => Validation.isPhone(text),
                              label: 'الهاتف'.tr,
                              icon: Icons.phone_android_outlined,
                              controller: _controller.phoneNumber),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// حقل كلمة المرور
                    GetBuilder<SignUpController>(builder: (logic) {
                      return CustomTextFiled(
                          validator: (text) => Validation.isPassword(text),
                          obscureText: _controller.isObsecure,
                          suffixIcon: IconButton(
                              onPressed: () => _controller.togglePassword(),
                              icon: Icon(
                                _controller.isObsecure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _controller.isObsecure ? Colors.grey : primary,
                              )),
                          label: 'كلمة المرور'.tr,
                          icon: Icons.lock_outline,
                          controller: _controller.password);
                    }),

                    const SizedBox(height: 15),

                    /// اختيار المنطقة
                     AreaWidget(),

                    const SizedBox(height: 30),

                    /// زر التسجيل
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: CustomButton(
                        title: 'إنشاء الحساب'.tr,
                        onTap: () => _controller.signUp(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// الرجوع لتسجيل الدخول
                    Center(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text.rich(
                          TextSpan(
                            text: "لديك حساب بالفعل؟ ".tr,
                            style: medium14.copyWith(color: Colors.grey),
                            children: [
                              TextSpan(
                                text: "تسجيل الدخول".tr,
                                style: bold16.copyWith(
                                  color: primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
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