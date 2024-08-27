import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/restaurant_details.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/controller/order_detail_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:get/get.dart';

class PendingView extends StatelessWidget {
  const PendingView({
    super.key,
    required this.orderController,
    required this.orderDetailController,
  });

  final OrderController orderController;
  final OrderDetailController orderDetailController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(
      builder: (restaurantController) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: orderController.allOrdersPending.length,
          separatorBuilder: (context, index) => Container(
            decoration: BoxDecoration(color: TColor.textfield),
            height: 5,
          ),
          itemBuilder: (context, index) {
            var list = orderController.allOrdersPending[index];
            var orderId = list.orderID ?? "";
            var restaurantId = list.restaurantID ?? "";
            var restaurant = restaurantController.restaurants[restaurantId];
            var status = list.status == 1 ? "Đang chuẩn bị" : "Đang giao hàng";

            if (restaurant == null) {
              return const SizedBox.shrink();
            }

            return FutureBuilder<int>(
              future: orderDetailController.getTotalQuantity(orderId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  final quantity = snapshot.data ?? 0;
                  final totalPrice =
                      double.tryParse(list.totalAmount ?? "0") ?? 0;

                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: TColor.primary, // Màu sắc viền của hình tròn nhỏ
                        width: 2, // Độ dày của viền
                      ),
                      color: TColor.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: RestaurantDetails(
                      listItem: restaurant,
                      restaurantController: restaurantController,
                      isOrder: true,
                      quantity: quantity,
                      totalPrice: totalPrice,
                      orderId: orderId,
                      status: status,
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
