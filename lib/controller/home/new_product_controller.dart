import 'dart:async';

import 'package:box_app/model/home/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../network/rest_api.dart';

class NewProductController extends GetxController {
  static NewProductController get to => Get.isRegistered<NewProductController>()
      ? Get.find<NewProductController>()
      : Get.put(NewProductController());

  final TextEditingController controllerSearch = TextEditingController();
  final Rxn<Timer> searchOnStoppedTyping = Rxn<Timer>();

  PagingController<int, ProductData> pagingController =
      PagingController(firstPageKey: 0);
  int currentPageSize = 0;
  int subCategoryId = -1;
  int brandId = -1;

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null) {
      subCategoryId = Get.arguments['id'] ?? -1;
      brandId = Get.arguments['brandId'] ?? -1;

    }
    pagingController.addPageRequestListener((pageKey) {
      getNewProduct(pageKey: pageKey);
    });

    controllerSearch.addListener(searchOnChange);
  }

  void getNewProduct({required int pageKey}) async {
    try {
      currentPageSize++;
      final result = await RestApi.getNewProduct(
        pageSize: 10,
        pageIndex: currentPageSize,
        search: controllerSearch.text,
        subCategoryId: subCategoryId,
        brandId: brandId
      );

      if (result.data.items.isNotEmpty) {
        final List<ProductData> flatList = result.data.items;
        final isLastPage = flatList.length < 5;
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

  void searchOnChange() {
    // if (searchOnStoppedTyping.value != null) {
    //   searchOnStoppedTyping.value!.cancel();
    // }
    // searchOnStoppedTyping.value = Timer(const Duration(milliseconds: 300), () {
    //   refreshScreen();
    // });
  }

  void refreshScreen() {
    currentPageSize = 0;
    pagingController.refresh();
  }

  void refreshPagingController() {
    pagingController = PagingController(firstPageKey: 0);
    currentPageSize = 0;
    pagingController.addPageRequestListener((pageKey) {
      getNewProduct(pageKey: pageKey);
    });
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    searchOnStoppedTyping.value?.cancel();
    super.dispose();
  }
}
