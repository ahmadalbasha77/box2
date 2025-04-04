import 'package:box_app/view/ui/cart/cart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';

import '../../controller/order/cart_controller.dart';
import '../../core/app_color.dart';

class CartIconWidget extends StatelessWidget {
  CartIconWidget({super.key});

  final controller = CartController.to;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (logic) {
      return badges.Badge(
        showBadge: logic.cartItems.isNotEmpty,
        position: badges.BadgePosition.topStart(top: 0, start: 0),
        badgeStyle: const badges.BadgeStyle(badgeColor: Colors.white),
        badgeContent: Text(
          // textAlign: TextAlign.center,
          '${logic.cartItems.length}',
          style: const TextStyle(color: AppColor.primaryColor, fontSize: 10),
        ),
        child: IconButton(
            onPressed: () {
              Get.to(() => CartScreen());
            },
            icon: const Icon(CupertinoIcons.cart)),
      );
    });
  }
}
