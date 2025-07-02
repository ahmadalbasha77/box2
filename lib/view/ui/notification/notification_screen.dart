import 'package:box_app/core/app_color.dart';
import 'package:box_app/core/font_style.dart';
import 'package:box_app/core/my_shared_preferences.dart';
import 'package:box_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/home/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final _controller = NotificationController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الاشعارات'.tr,
          style: const TextStyle(
            // color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child:GetBuilder<
            NotificationController>(
            builder: (logic) =>
            _controller.isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : _controller.notifications.isEmpty
                ? Center(child: Text('لا يوجد بيانات'.tr))
                : ListView.builder(
              itemCount: _controller.notifications.length,
              itemBuilder: (context, index) =>
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.primaryColor.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _controller.notifications[index].title,
                                style: bold14,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _controller.notifications[index].body,
                                style: regular12.copyWith(
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              Utils.formatDate(_controller
                                  .notifications[index].createdDate),
                              style:
                              regular12.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
            )),
      ),
    );
  }
}
