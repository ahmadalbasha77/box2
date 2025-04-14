import 'package:box_app/view/ui/cart/cart_screen.dart';
import 'package:box_app/view/ui/category/category_screen.dart';
import 'package:box_app/view/ui/home/home.dart';
import 'package:get/get.dart';

import '../view/ui/notification/notification_screen.dart';
import '../view/ui/product/product_screen.dart';

class MainController extends GetxController {
  static MainController get to => Get.isRegistered<MainController>()
      ? Get.find<MainController>()
      : Get.put(MainController(),permanent: true);

  int selectedIndex = 0;

  final tabs = [
    const HomeScreen(),
    CategoryScreen(
      isCart: false,
    ),
    CartScreen(),
    const ProductScreen(
      isCart: false,
    ),
     NotificationScreen(),
  ];
}
