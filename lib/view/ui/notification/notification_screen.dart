import 'package:box_app/core/app_color.dart';
import 'package:box_app/core/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'الاشعارات'.tr,
          style: TextStyle(
            color: Colors.white,
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
        child: ListView(
          children: List.generate(
            5,
                (index) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                          [
                            'عرض خاص اليوم',
                            'تنبيه نفاد المخزون',
                            'منتجات جديدة متاحة',
                            'خصومات نهاية الأسبوع',
                            'تم تحديث طلبك'
                          ][index],
                          style: bold14,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          [
                            'استفد من الخصم 20% على جميع المنتجات اليوم فقط!',
                            'الكمية المتبقية قليلة، سارع بالطلب قبل نفاد الكمية.',
                            'أضفنا منتجات جديدة إلى المتجر، تفقدها الآن.',
                            'لا تفوت الفرصة! عروض خاصة على المنتجات الغذائية.',
                            'تم تحديث حالة طلبك، يمكنك متابعته من قسم الطلبات.'
                          ][index],
                          style: regular12.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Text(
                        '10/10/2022',
                        style: regular12.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      // IconButton(
                      //   onPressed: () {
                      //     // تفاعل عند الضغط
                      //   },
                      //   icon: const Icon(
                      //     Icons.delete_outline,
                      //     color: Colors.redAccent,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}