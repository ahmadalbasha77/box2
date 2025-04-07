import 'package:box_app/core/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_color.dart';

class CustomTextFiled extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;


  const CustomTextFiled({super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.validator, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        keyboardType:keyboardType,
        obscureText: obscureText,
        validator: validator ?? (value) => Validation.isRequired(value),
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: label.tr,
          prefixIcon: Icon(icon, color: AppColor.primaryColor2),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        ),
      ),
    );
  }
}
