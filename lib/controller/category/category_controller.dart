import 'dart:async';

import 'package:box_app/model/home/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../network/rest_api.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.isRegistered<CategoryController>()
      ? Get.find<CategoryController>()
      : Get.put(CategoryController(),permanent: true);

  final TextEditingController controllerSearch = TextEditingController();
  final Rxn<Timer> searchOnStoppedTyping = Rxn<Timer>();

  PagingController<int, CategoryData> pagingController = PagingController(firstPageKey: 0);
  int currentPageSize = 0;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      getCategory(pageKey: pageKey);
    });

    controllerSearch.addListener(searchOnChange);
  }

  void getCategory({required int pageKey}) async {
    try {
      currentPageSize++;
      final result = await RestApi.getCategory(
        pageSize: 10,
        pageIndex: currentPageSize,
        search: controllerSearch.text,
      );

      if (result.data.items.isNotEmpty) {
        final List<CategoryData> flatList = result.data.items;
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

  void searchOnChange() {
    if (searchOnStoppedTyping.value != null) {
      searchOnStoppedTyping.value!.cancel();
    }
    searchOnStoppedTyping.value = Timer(const Duration(milliseconds: 300), () {
      refreshScreen();
    });
  }

  void refreshScreen() {
    currentPageSize = 0;
    pagingController.refresh();
  }

  void refreshPagingController() {
    pagingController = PagingController(firstPageKey: 0);
    currentPageSize = 0;
    pagingController.addPageRequestListener((pageKey) {
      getCategory(pageKey: pageKey);
    });
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    searchOnStoppedTyping.value?.cancel();
    super.dispose();
  }
}
