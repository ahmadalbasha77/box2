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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/login.png',
                    height: MediaQuery.sizeOf(context).height * 0.18,
                    // color: AppColor.primaryColor,
                  ),
                  const SizedBox(height: 30),
                  Text("Welcome Back!".tr,
                      style: bold24.copyWith(color: AppColor.primaryColor)),
                  const SizedBox(height: 20),
                  CustomTextFiled(
                      label: 'Email'.tr,
                      icon: Icons.email_outlined,
                      controller: _controller.email),
                  const SizedBox(height: 15),
                  GetBuilder<LoginController>(builder: (logic) {
                    return CustomTextFiled(
                        obscureText: _controller.isObsecure,
                        suffixIcon: IconButton(
                            onPressed: () {
                              _controller.togglePassword();
                            },
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: _controller.isObsecure
                                  ? Colors.black45
                                  : AppColor.primaryColor,
                            )),
                        label: 'Password'.tr,
                        icon: Icons.lock_outline,
                        controller: _controller.password);
                  }),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        title: 'Login',
                        onTap: () {
                          _controller.login();
                        },
                      )),
                  const SizedBox(height: 0),
                  // Align(
                  //   alignment: AlignmentDirectional.centerStart,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Get.to(() => const ForgetPasswordScreen());
                  //     },
                  //     child: const Text(
                  //       "Forgot Password?",
                  //       style: TextStyle(color: AppColor.primaryColor2),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  const SignUpButton(),
                  const SizedBox(height: 15),
                  if (!isOpen)
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => const NavBarScreen());
                      },
                      child: Text(
                        "Login as a guest".tr,
                        style: bold16.copyWith(color: AppColor.primaryColor2),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
