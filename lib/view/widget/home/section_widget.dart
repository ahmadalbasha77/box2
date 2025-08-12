import 'package:box_app/core/app_color.dart';
import 'package:box_app/core/font_style.dart';
import 'package:box_app/view/ui/category/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/home/brand_screen.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final String? actionText;

  const SectionWidget({super.key, required this.title, this.actionText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.tr, style: bold18.copyWith(color: AppColor.primaryColor)),
          if (actionText != null)
            TextButton(
              onPressed: () {
                Get.to(() =>  BrandScreen());
              },
              child: Text(actionText!.tr,
                  style: regular14.copyWith(color: AppColor.primaryColor)),
            )
        ],
      ),
    );
  }
}
