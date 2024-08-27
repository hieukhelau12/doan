import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/currency_formatter.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/controller/order_detail_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/view/order/order_detail_view.dart';

import 'package:get/get.dart';

class AllOrderView extends StatefulWidget {
  const AllOrderView({super.key});

  @override
  State<AllOrderView> createState() => _AllOrderViewState();
}

class _AllOrderViewState extends State<AllOrderView> {
  final orderController = Get.put(OrderController());
  final restaurantController = Get.put(RestaurantController());
  final orderDetailController = Get.put(OrderDetailController());
  @override
  void initState() {
    super.initState();
    orderController.selectedStatus.value = "Đang xử lý";
    orderController.sortOrder.value = "Sắp xếp";
    orderController.getOrder().then((_) {
      final restaurantIds = orderController.allOrders
          .map((order) => order.restaurantID)
          .where((id) => id != null)
          .cast<String>()
          .toList();
      restaurantController.loadRestaurants(restaurantIds);
    });
  }

  DateTime getOrderDateTime(OrderModel? order) {
    if (order != null && order.orderDate != null) {
      return DateTime.parse(order.orderDate!);
    } else {
      return DateTime.now();
    }
  }

  String formatDateTime(DateTime dateTime) {
    String formattedDay = dateTime.day.toString().padLeft(2, '0');
    String formattedMonth = dateTime.month.toString().padLeft(2, '0');
    String formattedHour = dateTime.hour.toString().padLeft(2, '0');
    String formattedMinute = dateTime.minute.toString().padLeft(2, '0');
    return "$formattedHour:$formattedMinute $formattedDay/$formattedMonth/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (orderController.filteredOrdersCSDL.isEmpty &&
          restaurantController.restaurants.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return Stack(
        children: [
          Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        orderController.togglePopup();
                      },
                      child: Row(
                        children: [
                          Text(
                            orderController.selectedStatus.value,
                            style: TextStyle(
                                fontSize: 15,
                                color: orderController.selectedStatus.value ==
                                        'Đang xử lý'
                                    ? TColor.primaryText
                                    : TColor.primary,
                                fontWeight: FontWeight.w600),
                          ),
                          orderController.isPopupVisible.value
                              ? Icon(
                                  Icons.keyboard_arrow_up,
                                  color: orderController.selectedStatus.value ==
                                          'Đang xử lý'
                                      ? TColor.primaryText
                                      : TColor.primary,
                                )
                              : Icon(
                                  Icons.keyboard_arrow_down,
                                  color: orderController.selectedStatus.value ==
                                          'Đang xử lý'
                                      ? TColor.primaryText
                                      : TColor.primary,
                                ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        orderController.toggleSortPopup();
                      },
                      child: Row(
                        children: [
                          Text(
                            orderController.sortOrder.value,
                            style: TextStyle(
                              fontSize: 15,
                              color: TColor.primaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          orderController.isSortPopupVisible.value
                              ? Icon(
                                  Icons.keyboard_arrow_up,
                                  color: TColor.primaryText,
                                )
                              : Icon(
                                  Icons.keyboard_arrow_down,
                                  color: TColor.primaryText,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!orderController.isPopupVisible.value)
                Expanded(
                  child: Obx(() {
                    if (orderController.filteredOrdersCSDL.isEmpty) {
                      // Nếu chỉ có danh sách đơn hàng trống
                      return const Center(child: Text("Không có đơn hàng"));
                    }
                    var filteredOrdersCSDL = orderController.filteredOrdersCSDL;

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: filteredOrdersCSDL.length,
                      separatorBuilder: (context, index) => Container(
                        height: 3,
                      ),
                      itemBuilder: (context, index) {
                        var list = filteredOrdersCSDL[index];
                        var restaurantId = list.restaurantID ?? "";
                        var orderId = list.orderID;
                        var restaurant =
                            restaurantController.restaurants[restaurantId];
                        DateTime dateTime = getOrderDateTime(list);
                        String orderDate = formatDateTime(dateTime);
                        String status = '';
                        Color color = Colors.transparent;
                        if (list.status == 1) {
                          status = "Đang xử lý";
                          color = TColor.primary;
                        } else if (list.status == 2) {
                          status = "Đang giao hàng";
                          color = Colors.blue;
                        } else if (list.status == 3) {
                          status = "Đã huỷ";
                          color = Colors.red;
                        } else if (list.status == 4) {
                          status = "Hoàn thành";
                          color = Colors.green;
                        }
                        if (restaurant == null) {
                          return const SizedBox.shrink();
                        }
                        return InkWell(
                          onTap: () {
                            Get.to(() => OrderDetailView(
                                  orderId: orderId ?? "",
                                  listItem: restaurant,
                                  isAdmin: true,
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: TColor
                                    .primary, // Màu sắc viền của hình tròn nhỏ
                                width: 2, // Độ dày của viền
                              ),
                              color: TColor.white,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mã đơn: ${list.orderID}"),
                                const SizedBox(height: 5),
                                Text("Ngày đặt đơn: $orderDate"),
                                const SizedBox(height: 5),
                                Text(
                                  "Quán ăn: ${restaurant.restaurantName ?? ""}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Tổng tiền: ${formatCurrency(double.parse(list.totalAmount ?? ""))}"),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Divider(
                                  color: TColor.secondaryText.withOpacity(0.2),
                                  height: 0.3,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text("Trạng thái:  "),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      color: color,
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: TColor.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
            ],
          ),
          orderController.isSortPopupVisible.value
              ? Positioned(
                  right: 20,
                  top: 50,
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: ['Sắp xếp', 'Mới nhất', 'Cũ nhất']
                          .map((String value) {
                        final bool isSelected =
                            orderController.sortOrder.value == value;
                        return InkWell(
                          onTap: () {
                            orderController.selectSortOrder(value);
                            if (value != "Sắp xếp") {
                              // Thực hiện logic sắp xếp nếu không chọn "Sắp xếp"
                              orderController.sortOrdersBy(value);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? TColor.primary.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  value,
                                  style: TextStyle(
                                    color: isSelected
                                        ? TColor.primary
                                        : TColor.primaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check,
                                      color: TColor.primary, size: 18),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          orderController.isPopupVisible.value
              ? Positioned(
                  left: 0,
                  right: 0,
                  top: 50,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: orderController.statuses2.map((String status) {
                        final bool isSelected =
                            orderController.selectedStatus.value == status;
                        return ListTile(
                          title: Text(
                            status,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? TColor.primary
                                  : TColor.primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            orderController.selectStatus(status);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      );
    });
  }
}
