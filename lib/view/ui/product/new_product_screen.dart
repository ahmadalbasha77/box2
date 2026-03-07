import 'package:box_app/controller/home/product_controller.dart';
import 'package:box_app/model/home/product_model.dart';
import 'package:box_app/view/ui/product/product_screen.dart';
import 'package:box_app/view/widget/cart_icon_widget.dart';
import 'package:box_app/view/widget/home/brand_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../controller/home/new_product_controller.dart';
import '../../../controller/order/cart_controller.dart';
import '../../../core/app_color.dart';
import '../../../core/font_style.dart';
import '../../widget/cache_image_widget.dart';

class NewProductScreen extends StatelessWidget {
  final bool isCart;
  final int subCategoryId;

  const NewProductScreen(
      {super.key, this.isCart = true, this.subCategoryId = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // appBar: _buildAppBar(),
      appBar: AppBar(
        title: Text(
          'وصل حديثاً'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        // foregroundColor: Colors.black,
        backgroundColor: AppColor.primaryColor,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: GetBuilder<NewProductController>(
        init: NewProductController(),
        builder: (logic) {
          return Column(
            children: [
              // _buildSearch(logic),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: SearchField(
                  hint: 'ابحث عن منتج'.tr,
                  controller: logic.controllerSearch,
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      logic.refreshScreen();
                    }
                  },
                  onSearch: () => logic.refreshScreen(),
                ),
              ),
              if (isCart) _buildBrand(),
              _buildList(logic),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBrand() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: BrandProductWidget(
        subCategoryId: subCategoryId,
      ),
    );
  }

  Widget _buildList(NewProductController logic) {
    return Expanded(
      child: PagedListView<int, ProductData>(
        pagingController: logic.pagingController,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        builderDelegate: PagedChildBuilderDelegate<ProductData>(
          itemBuilder: (context, item, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HorizontalProductCard(data: item),
            );
          },
        ),
      ),
    );
  }
}
