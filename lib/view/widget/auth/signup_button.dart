import 'package:box_app/core/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_color.dart';
import '../../ui/auth/signup_screen.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          "Don't have an account ?".tr,
          style: const TextStyle(color: AppColor.primaryColor),
        ),
        TextButton(
          onPressed: () {
            Get.to(() =>  SignUpScreen());
          },
          child: Text(
            "Sign Up".tr,
            style: semiBold16,
          ),
        ),
      ],
    );
  }
}
