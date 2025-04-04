import 'package:box_app/core/font_style.dart';
import 'package:flutter/material.dart';

import '../../core/app_color.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final TextStyle? style;
  final double? vertical;
  final Color? color;
  final Color? borderColor;

  const CustomButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.style,
      this.vertical,
      this.color,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColor.primaryColor,
        padding: EdgeInsets.symmetric(vertical: vertical ?? 15, horizontal: 10),
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: borderColor ?? AppColor.primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: style ?? regular16.copyWith(color: Colors.white
        ),
      ),
    );
  }
}
