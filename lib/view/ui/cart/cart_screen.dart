import 'package:box_app/core/app_color.dart';
import 'package:box_app/core/font_style.dart';
import 'package:box_app/model/order/cart_model.dart';
import 'package:box_app/view/widget/cache_image_widget.dart';
import 'package:box_app/view/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/order/cart_controller.dart';
import '../../../core/my_shared_preferences.dart';
import '../../../core/utils.dart';
import '../auth/login_screen.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final controller = CartController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('السلة'.tr),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: GetBuilder<CartController>(builder: (logic) {
            return CustomButton(
              title: '${'تنفيذ الطلب'.tr} ${controller.total.toStringAsFixed(2)} JD'
                  '',
              onTap: () async {
                if (mySharedPreferences.isLogin) {
                  if (await Utils.showAreYouSureDialog(
                      title: 'تنفيذ الطلب'.tr)) {
                    controller.addOrder();
                  }
                } else {
                  Utils.showSnackbar('تنبيه !', 'يرجى تسجيل الدخول');
                  Get.to(() => LoginScreen(
                        isOpen: true,
                      ));
                }
              },
            );
          }),
        ),
      ),
      body: GetBuilder<CartController>(builder: (logic) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text('${'السلة'.tr} (${controller.cartItems.length} ${'عناصر'.tr})',
                  style: bold16.copyWith(color: AppColor.primaryColor)),
              Expanded(
                child: controller.cartItems.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.cartItems.length,
                        itemBuilder: (context, index) => CartWidget(
                            price: controller
                                .totalForProduct(controller.cartItems[index]),
                            onDecrement: () {
                              controller.decrement(
                                  controller.cartItems[index].product);
                            },
                            onIncrement: () {
                              controller.increment(
                                  controller.cartItems[index].product);
                            },
                            item: controller.cartItems[index]),
                      )
                    : Center(
                        child: Text('لا يوجد عناصر في السلة'.tr,
                            style:
                                bold16.copyWith(color: AppColor.primaryColor)),
                      ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class CartWidget extends StatelessWidget {
  final CartItem item;
  final double price;
  final void Function() onIncrement;
  final void Function() onDecrement;

  const CartWidget(
      {super.key,
      required this.item,
      required this.onIncrement,
      required this.onDecrement,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.primaryColor.withOpacity(0.1),
              ),
              child: CacheImageWidget(
                image: item.product.imageUrl,
                height: 100,
                width: 100,
              )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: regular14,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${price.toStringAsFixed(2)} JD',
                  style: bold14.copyWith(color: AppColor.primaryColor),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onDecrement,
                  icon: const Icon(Icons.remove, color: AppColor.primaryColor),
                ),
                Text(
                  '${item.quantity}',
                  style: bold16.copyWith(color: AppColor.primaryColor),
                ),
                IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add, color: AppColor.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
