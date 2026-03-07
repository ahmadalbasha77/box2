import 'package:box_app/network/rest_api.dart';
import 'package:get/get.dart';

import '../../model/home/brand_model.dart';

class BrandProductController extends GetxController {
  BrandProductController(this.subCategoryId);


  final int subCategoryId;

  List<BrandDate> brand = [];

  int idSelected = -1;
  // int? subCategoryId;
  bool isLoading = false;

  @override
  onInit() {
    super.onInit();
    print('*************************************');
    print('subCategoryId: $subCategoryId');
    print('subCategoryId: $subCategoryId');
    print('subCategoryId: $subCategoryId');
    print('*************************************');
    getBrand();
  }

  Future<void> getBrand() async {
    try {
      isLoading = true;
      update();

      var response = await RestApi.getBrandBySubCategory(
          pageSize: 20, pageIndex: 1, subCategoryId: subCategoryId??0);

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
