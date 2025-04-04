import 'package:box_app/model/home/ads_model.dart';
import 'package:box_app/network/rest_api.dart';
import 'package:get/get.dart';

class AdsController extends GetxController {
  static AdsController get to => Get.isRegistered<AdsController>()
      ? Get.find<AdsController>()
      : Get.put(AdsController());

  List<AdsData> ads = [];

  bool isLoading = false;

  int current = 0;

  void onPageChanged(index, carouselPageChangedReason) {
    current = index;
    update();
  }

  @override
  onInit() {
    super.onInit();
    getCategory();
  }

  Future<void> getCategory() async {
    try {
      isLoading = true;
      update();
      var response = await RestApi.getAds(pageSize: 20, pageIndex: 1);
      ads = response.data.items;
    } finally {
      isLoading = false;
      update();
    }
  }
}
