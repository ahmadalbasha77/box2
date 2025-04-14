import 'dart:convert';

import 'package:box_app/core/my_shared_preferences.dart';
import 'package:box_app/core/utils.dart';
import 'package:box_app/model/auth/sign_up_model.dart';
import 'package:box_app/view/ui/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/rest_api.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.isRegistered<SignUpController>()
      ? Get.find<SignUpController>()
      : Get.put(SignUpController());

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final TextEditingController name = TextEditingController();
  final TextEditingController userName = TextEditingController();

  final TextEditingController shopName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  var selectedAreaId = Rxn<String>();
  var selectedAreaName = Rxn<String>();

  void setSelectedArea(String id, String name) {
    selectedAreaId.value = id;
    selectedAreaName.value = name;
  }
  bool isObsecure = true;

  void togglePassword() {
    isObsecure = !isObsecure;
    update();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void signUp() async {
    if (formKey.currentState!.validate()) {
      try {
        Utils.showLoadingDialog();
        SignUpModel result = await RestApi.signUp(
          jsonEncode({
            "name": name.text,
            "userName": userName.text,
            "shopName": shopName.text,
            "email": email.text,
            "phoneNumber": phoneNumber.text,
            "password": password.text,
            "areaId": selectedAreaId.value,
            "role": 1,
            "isActive": true,
            "deviceToken": mySharedPreferences.deviceToken
          }),
        );
        if (result.success == true) {
          Utils.hideLoadingDialog();
          mySharedPreferences.isLogin = true;
          mySharedPreferences.token = result.data.token;
          mySharedPreferences.userId = result.data.id;
          mySharedPreferences.userName = result.data.userName;
          mySharedPreferences.email = result.data.email;
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
