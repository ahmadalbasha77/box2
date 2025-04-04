import 'package:box_app/controller/auth/area_controller.dart';
import 'package:get/get.dart';

import '../controller/order/cart_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.put(AreaController(), permanent: true);
    Get.put(CartController(), permanent: true);

  }
}
