import 'package:box_app/core/utils.dart';
import 'package:box_app/view/ui/cart/details_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../controller/order/order_controller.dart';
import '../../../model/order/order_model.dart';

class OrderScreen extends StatelessWidget {
  final _controller = OrderController.to;

  OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('طلباتي'),
          centerTitle: true,
        ),
        body: GetBuilder<OrderController>(builder: (logic) {
          return PagedListView<int, OrderItem>(
            pagingController: logic.pagingController,
            padding: const EdgeInsets.symmetric(vertical: 10),
            builderDelegate: PagedChildBuilderDelegate<OrderItem>(
              itemBuilder: (context, item, index) {
                return OrderCard(order: item);
              },
            ),
          );
        }));
  }
}

class OrderCard extends StatelessWidget {
  final OrderItem order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب رقم: ${order.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  Utils.formatDate(order.createdDate),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('عدد المنتجات: ${order.cartItems.length}'),
                _buildStatusBadge(order.cartStatus),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${order.totalPrice.toStringAsFixed(2)} JD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => OrderDetailsScreen(order: order));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('عرض التفاصيل'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int status) {
    Color bgColor;
    Color textColor;
    String statusText;

    switch (status) {
      case 0:
        bgColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange;
        statusText = 'قيد المراجعة';
        break;
      case 1:
        bgColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        statusText = 'تم التسليم';

        break;
      case 2:
        bgColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue;
        statusText = 'قيم التجهيز';
        break;
      case 3:
        bgColor = Colors.red.withOpacity(0.2);
        textColor = Colors.red;
        statusText = 'ملغي';
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
        statusText = 'ملغي';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
