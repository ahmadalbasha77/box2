import 'package:box_app/core/utils.dart';
import 'package:get/get.dart';

class Validation {
  static String? isEmail(String? email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    if (Utils.isEmpty(email)) {
      return "This is required".tr;
    } else if (!regExp.hasMatch(email!)) {
      return "Please enter valid email".tr;
    }
    return null;
  }

  static String? isPassword(String? password) {
    if (Utils.isEmpty(password)) {
      return "This is required".tr;
    } else if (password!.length < 8) {
      return "Please enter valid password".tr;
    }
    return null;
  }

  static String? isConfirmPassword(String? password, String? confirmPassword) {
    if (Utils.isEmpty(confirmPassword)) {
      return "This is required".tr;
    } else if (password != confirmPassword) {
      return "Password does not match".tr;
    }
    return null;
  }

  static String? isRequired(String? text) {
    if (Utils.isEmpty(text)) {
      return "This is required".tr;
    }
    return null;
  }

  static String? isRequired3(String? text) {
    if (Utils.isEmpty(text)) {
      return "This is required".tr;
    } else if (text!.trim().length < 3) {
      return "Must be at least 3 characters".tr;
    }
    return null;
  }

  static String? isPhone(String? text) {
    try {
      RegExp regExp = RegExp(r'^07[0-9]{8}$');
      if (Utils.isEmpty(text)) {
        return "This is required".tr;
      } else if (!regExp.hasMatch(text!)) {
        return "Please enter a valid phone number".tr;
      }
      return null;
    } catch (e) {
      return "Please enter a valid phone number".tr;
    }
  }
}
