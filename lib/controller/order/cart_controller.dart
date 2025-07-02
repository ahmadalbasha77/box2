import 'dart:convert';

import 'package:box_app/core/my_shared_preferences.dart';
import 'package:box_app/core/utils.dart';
import 'package:get/get.dart';
import '../../model/home/product_model.dart';
import '../../model/order/cart_model.dart';
import '../../network/rest_api.dart';
import '../../view/ui/nav_bar_screen.dart';

class CartController extends GetxController {
  static CartController get to => Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());

  final List<CartItem> cartItems = [];

  void addProduct(ProductData product, ProductUnit unit) {
    final index = cartItems.indexWhere(
          (item) => item.product.id == product.id && item.unit.id == unit.id,
    );
    if (index >= 0) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(CartItem(product: product, unit: unit));
    }
    update();
  }

  void increment(ProductData product, ProductUnit unit) {
    final item = cartItems.firstWhere(
          (item) => item.product.id == product.id && item.unit.id == unit.id,
    );
    item.quantity++;
    update();
  }

  void decrement(ProductData product, ProductUnit unit) {
    final item = cartItems.firstWhere(
          (item) => item.product.id == product.id && item.unit.id == unit.id,
    );
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      cartItems.removeWhere(
            (item) => item.product.id == product.id && item.unit.id == unit.id,
      );
    }
    update();
  }

  void removeProduct(ProductData product, ProductUnit unit) {
    cartItems.removeWhere(
          (item) => item.product.id == product.id && item.unit.id == unit.id,
    );
    update();
  }

  int quantityOf(ProductData product, ProductUnit unit) {
    final item = cartItems.firstWhereOrNull(
          (item) => item.product.id == product.id && item.unit.id == unit.id,
    );
    return item?.quantity ?? 0;
  }


  double totalForProduct(CartItem item) {
    return item.unit.price * item.quantity;
  }

  double get total {
    double total = 0;
    for (var item in cartItems) {
      total += totalForProduct(item);
    }
    return total;
  }

  void addOrder() async {
    if (cartItems.isEmpty) {
      Utils.showFlutterToast('Cart is empty'.tr);
    } else {
      Utils.showLoadingDialog();

      List<Map<String, dynamic>> cartItemsData = cartItems.map((item) {
        return {
          "productId": item.product.id,
          "unitId": item.unit.id,
          "quantity": item.quantity,
          "price": item.unit.price
        };
      }).toList();

      double totalPrice = total;

      bool success = await RestApi.addOrder(jsonEncode({
        "name": "string",
        "userId": mySharedPreferences.userId,
        "cartItems": cartItemsData,
        "totalPrice": totalPrice.toStringAsFixed(2),
        "cartStatus": 0
      }));

      if (success) {
        cartItems.clear();
        Utils.showSnackbar('Successfully !', 'Order added successfully');
        Get.offAll(() => const NavBarScreen());
      } else {
        Utils.showSnackbar('Please try again', 'An error occurred');
      }
    }
  }

}
