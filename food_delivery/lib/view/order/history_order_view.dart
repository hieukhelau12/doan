import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/currency_formatter.dart';
import 'package:food_delivery/common_widget/review_dialog.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/controller/order_detail_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/controller/review_controller.dart';
import 'package:food_delivery/view/menu/restaurant_details_view.dart';
import 'package:food_delivery/view/order/order_detail_view.dart';
import 'package:get/get.dart';

class HistoryOrderView extends StatefulWidget {
  const HistoryOrderView({
    super.key,
    required this.controller,
  });
  final OrderDetailController controller;
  @override
  State<HistoryOrderView> createState() => _HistoryOrderViewState();
}

class _HistoryOrderViewState extends State<HistoryOrderView> {
  final orderController = Get.put(OrderController());
  final reviewController = Get.put(ReviewController());
  final restaurantController = Get.put(RestaurantController());

  Future<void> _loadReviewedOrders() async {
    var filteredOrders = orderController.filteredOrders;
    var orderIds = filteredOrders.map((order) => order.orderID ?? "").toList();
    await reviewController.loadReviewedOrders(orderIds);
  }

  @override
  void initState() {
    super.initState();
    _loadReviewedOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadReviewedOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Expanded(
            child: Obx(() {
              var filteredOrders = orderController.filteredOrders;
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: filteredOrders.length,
                separatorBuilder: (context, index) => Container(
                  decoration: BoxDecoration(color: TColor.textfield),
                  height: 5,
                ),
                itemBuilder: (context, index) {
                  var list = filteredOrders[index];
                  var orderId = list.orderID ?? "";
                  var restaurantId = list.restaurantID ?? "";
                  var restaurant =
                      restaurantController.restaurants[restaurantId];
                  var status = list.status == 3 ? "Bị huỷ" : "Hoàn thành";

                  if (restaurant == null) {
                    return const SizedBox.shrink();
                  }

                  // Tải dữ liệu từ cache
                  orderController.loadOrderDetails(orderId);
                  orderController.loadItemsForOrder(orderId);

                  return Obx(() {
                    var orderDetails =
                        orderController.orderDetailsCache[orderId] ?? [];
                    var items = orderController.itemsCache[orderId] ?? [];

                    Map<String, int> itemQuantities = {};
                    Map<String, double> itemTotals = {};

                    for (var detail in orderDetails) {
                      if (detail.itemID != null) {
                        itemQuantities.update(
                          detail.itemID,
                          (value) => value + (detail.quantity ?? 0),
                          ifAbsent: () => detail.quantity ?? 0,
                        );
                        itemTotals.update(
                          detail.itemID,
                          (value) =>
                              value +
                              (double.tryParse(detail.totalPrice ?? "0") ?? 0),
                          ifAbsent: () =>
                              double.tryParse(detail.totalPrice ?? "0") ?? 0,
                        );
                      }
                    }

                    int totalQuantity =
                        itemQuantities.values.fold(0, (a, b) => a + b);
                    double total = itemTotals.values.fold(0, (a, b) => a + b);

                    return Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: TColor.primary,
                          width: 2,
                        ),
                        color: TColor.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => RestaurantDetailsView(
                                    restaurant: restaurant,
                                  ));
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    restaurant.restaurantName ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,
                                    color: TColor.placeholder),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              Get.to(() => OrderDetailView(
                                  orderId: orderId, listItem: restaurant));
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 280,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: items.length,
                                    itemBuilder: (context, itemIndex) {
                                      final item = items[itemIndex];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CachedNetworkImage(
                                              height: 70,
                                              width: 70,
                                              imageUrl: item.imageUrl ?? "",
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.black),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              item.itemName ?? "",
                                              style: TextStyle(
                                                color: TColor.primaryText,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(formatCurrency(total)),
                                    Text("$totalQuantity món"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Divider(
                            color: TColor.secondaryText.withOpacity(0.2),
                            height: 0.3,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                status,
                                style: TextStyle(
                                  color: TColor.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              !(reviewController.reviewedOrders[orderId] ??
                                      false)
                                  ? InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => ReviewDialog(
                                            orderId: orderId,
                                            restaurantId: restaurantId,
                                          ),
                                        ).then((_) => _loadReviewedOrders());
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: TColor.primary),
                                        child: Text(
                                          "Đánh giá",
                                          style: TextStyle(
                                              color: TColor.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  : const Text("Đã đánh giá")
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                },
              );
            }),
          );
        }
      },
    );
  }
}
