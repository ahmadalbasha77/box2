import 'package:box_app/model/home/category_model.dart';
import 'package:box_app/network/rest_api.dart';
import 'package:get/get.dart';

class CategoryHomeController extends GetxController {
  static CategoryHomeController get to =>
      Get.isRegistered<CategoryHomeController>()
          ? Get.find<CategoryHomeController>()
          : Get.put(CategoryHomeController());

  List<CategoryData> categories = [];

  bool isLoading = false;

  @override
  onInit() {
    super.onInit();
    getCategory();
  }

  Future<void> getCategory() async {
    try {
      isLoading = true;
      update();
      var response = await RestApi.getCategory(pageSize: 15, pageIndex: 1);
      categories = response.data.items;
    } finally {
      isLoading = false;
      update();
    }
  }
}
