import 'package:box_app/network/rest_api.dart';
import 'package:get/get.dart';

import '../../model/home/notification_model.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.isRegistered<NotificationController>()
      ? Get.find<NotificationController>()
      : Get.put(NotificationController() , permanent: true);

  List<ItemNotifications> notifications = [];

  bool isLoading = false;

  int current = 0;


  @override
  onInit() {
    super.onInit();
    getCategory();
  }

  Future<void> getCategory() async {
    try {
      isLoading = true;
      update();
      var response = await RestApi.getNotification();
      notifications = response.data.items;
    } finally {
      isLoading = false;
      update();
    }
  }
}
