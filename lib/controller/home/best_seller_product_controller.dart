import 'package:box_app/model/home/product_model.dart';
import 'package:box_app/network/rest_api.dart';
import 'package:get/get.dart';

class BestSellerProductController extends GetxController {
  static BestSellerProductController get to =>
      Get.isRegistered<BestSellerProductController>()
          ? Get.find<BestSellerProductController>()
          : Get.put(BestSellerProductController());

  List<ProductData> product = [];

  bool isLoading = false;

  @override
  onInit() {
    super.onInit();
    getProduct();
  }

  Future<void> getProduct() async {
    try {
      isLoading = true;
      update();
      var response = await RestApi.getProduct(
          pageSize: 15, pageIndex: 1, subCategoryId: -1, brandId: -1);
      product = response.data.items;
    } finally {
      isLoading = false;
      update();
    }
  }
}
