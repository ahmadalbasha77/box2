import 'package:box_app/model/auth/area_model.dart';
import 'package:box_app/network/rest_api.dart';
import 'package:get/get.dart';

class AreaController extends GetxController {
  static AreaController get to => Get.isRegistered<AreaController>()
      ? Get.find<AreaController>()
      : Get.put(AreaController());

  List<AreaItem> area = [];

  bool isLoading = false;


  @override
  onInit() {
    super.onInit();
    getArea();
  }

  Future<void> getArea() async {
    try {
      isLoading = true;
      update();
      var response = await RestApi.getArea(
        pageSize: 30,
        pageIndex: 1,
      );
      area = response.data.items;
    } finally {
      isLoading = false;
      update();
    }
  }
}
