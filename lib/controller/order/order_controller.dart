import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../network/rest_api.dart';
import '../../model/order/order_model.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.isRegistered<OrderController>()
      ? Get.find<OrderController>()
      : Get.put(OrderController());

  PagingController<int, OrderItem> pagingController =
      PagingController(firstPageKey: 0);
  int currentPageSize = 0;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      getOrder(pageKey: pageKey);
    });
  }

  void getOrder({required int pageKey}) async {
    try {

      currentPageSize++;
      final result = await RestApi.getOrder(
        pageSize: 10,
        pageIndex: currentPageSize,
      );


      if (result.data.items.isNotEmpty) {

        final List<OrderItem> flatList = result.data.items;
        final isLastPage = flatList.length < 10;
        if (isLastPage) {
          pagingController.appendLastPage(flatList);
        } else {
          pagingController.appendPage(flatList, pageKey + flatList.length);
        }
      } else {
        pagingController.appendLastPage([]);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  void refreshScreen() {
    currentPageSize = 0;
    pagingController.refresh();
  }

  void refreshPagingController() {
    pagingController = PagingController(firstPageKey: 0);
    currentPageSize = 0;
    pagingController.addPageRequestListener((pageKey) {
      getOrder(pageKey: pageKey);
    });
  }
}
