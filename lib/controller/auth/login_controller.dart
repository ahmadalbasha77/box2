import 'dart:convert';

import 'package:box_app/core/my_shared_preferences.dart';
import 'package:box_app/core/utils.dart';
import 'package:box_app/view/ui/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/auth/login_model.dart';
import '../../network/rest_api.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.isRegistered<LoginController>()
      ? Get.find<LoginController>()
      : Get.put(LoginController());

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        Utils.showLoadingDialog();
        LoginModel result = await RestApi.login(
          jsonEncode(
            {
              "emailOrUsername": email.text,
              "password": password.text,
              "deviceToken": "string"
            },
          ),
        );
        if (result.success == true) {
          Utils.hideLoadingDialog();
          mySharedPreferences.isLogin = true;
          mySharedPreferences.token = result.data.token;
          mySharedPreferences.userName = result.data.username;
          mySharedPreferences.userId = result.data.userId;
          mySharedPreferences.email = result.data.email;
          // mySharedPreferences.saveUserData(result.data);
          Get.offAll(() => const NavBarScreen());
        } else {
          Utils.showSnackbar('Please try again', result.message);
        }
      } catch (e) {
        Utils.hideLoadingDialog();
        Utils.showSnackbar('Please try again', 'an error occurred');
      }
    }
  }
}
