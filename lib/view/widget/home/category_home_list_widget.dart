
import 'package:box_app/controller/home/category_home_controller.dart';
import 'package:box_app/view/widget/home/category_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryHomeListWidget extends StatelessWidget {
  CategoryHomeListWidget({super.key});

  final _controller = CategoryHomeController.to;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryHomeController>(
        builder: (logic) => _controller.isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : _controller.categories.isEmpty
            ?  Center(child: Text('لا يوجد بيانات'.tr))
            : SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.15,
            child: ListView.builder(
              itemCount: _controller.categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => FittedBox(
                child: CategoryHomeWidget(
                    data: _controller.categories[index]),
              ),
            )));
  }
}

