import 'package:box_app/core/validation.dart';
import 'package:box_app/view/widget/auth/area_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth/sign_up_controller.dart';
import '../../../core/app_color.dart';
import '../../widget/auth/custom_text_filed.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _controller = SignUpController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
            child: Form(
              key: _controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/undraw_mobile-login_4ntr-removebg-preview.png',
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    width: MediaQuery.sizeOf(context).width * 0.44,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please enter your info to create an account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFiled(
                      label: 'Email',
                      icon: Icons.email,
                      controller: _controller.email),
                  const SizedBox(height: 10),
                  CustomTextFiled(
                      label: 'Username',
                      icon: Icons.person,
                      controller: _controller.userName),
                  const SizedBox(height: 10),
                  CustomTextFiled(
                      label: 'Store Name',
                      icon: Icons.store,
                      controller: _controller.shopName),
                  const SizedBox(height: 10),
                  CustomTextFiled(
                      keyboardType: TextInputType.phone,
                      validator: (text) => Validation.isPhone(text),
                      label: 'Phone Number',
                      icon: Icons.phone,
                      controller: _controller.phoneNumber),
                  const SizedBox(height: 10),
                  CustomTextFiled(
                      validator: (text) => Validation.isPassword(text),
                      obscureText: true,
                      label: 'Password',
                      icon: Icons.lock,
                      controller: _controller.password),
                  const SizedBox(height: 10),
                  AreaWidget(),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        shadowColor: AppColor.primaryColor.withOpacity(0.5),
                      ),
                      onPressed: () {
                        _controller.signUp();
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                            fontSize: 16, color: AppColor.primaryColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ),
                    ],
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
