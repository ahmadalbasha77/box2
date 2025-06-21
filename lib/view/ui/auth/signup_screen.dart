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
                    'assets/images/signup.png',
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    width: MediaQuery.sizeOf(context).width * 0.44,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Create Account".tr,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please enter your info to create an account".tr,
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
                      icon: Icons.person_pin,
                      controller: _controller.userName),
                  const SizedBox(height: 10),
                  CustomTextFiled(
                      label: 'Full Name',
                      icon: Icons.person,
                      controller: _controller.name),
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
                  GetBuilder<SignUpController>(builder: (logic) {
                    return CustomTextFiled(
                        validator: (text) => Validation.isPassword(text),
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
                        label: 'Password',
                        icon: Icons.lock,
                        controller: _controller.password);
                  }),
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
                      child: Text(
                        "Sign Up".tr,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?".tr,
                        style: const TextStyle(
                            fontSize: 16, color: AppColor.primaryColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Login".tr,
                          style: const TextStyle(
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
