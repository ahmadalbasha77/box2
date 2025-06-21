import 'package:box_app/network/rest_api.dart';
import 'package:get/get.dart';

import '../../model/home/brand_model.dart';

class BrandProductController extends GetxController {
  static BrandProductController get to =>
      Get.isRegistered<BrandProductController>()
          ? Get.find<BrandProductController>()
          : Get.put(BrandProductController());

  List<BrandDate> brand = [];

  int idSelected = -1;
  bool isLoading = false;

  @override
  onInit() {
    super.onInit();
    getBrand();
  }

  Future<void> getBrand() async {
    try {
      isLoading = true;
      update();

      var response = await RestApi.getBrand(pageSize: 15, pageIndex: 1);

      brand = [
        BrandDate(id: -1, name: 'all'.tr, imageUrl: ''),
        ...response.data.data
      ];
    } finally {
      isLoading = false;
      update();
    }
  }
}
