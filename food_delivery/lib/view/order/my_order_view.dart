import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/controller/order_detail_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/view/order/history_order_view.dart';
import 'package:food_delivery/view/order/pending_view.dart';
import 'package:get/get.dart';

class MyOrderView extends StatefulWidget {
  const MyOrderView({super.key});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  final orderController = Get.put(OrderController());
  final restaurantController = Get.put(RestaurantController());
  final orderDetailController = Get.put(OrderDetailController());
  late Future<void> _pendingOrdersFuture;
  late Future<void> _completeOrdersFuture;

  @override
  void initState() {
    super.initState();
    orderController.selectedStatus.value = "Tất cả";
    _pendingOrdersFuture = _loadPendingOrders();
    _completeOrdersFuture = _loadCompleteOrders();
  }

  Future<void> _loadPendingOrders() async {
    await orderController.getOrdersPending();
    final restaurantIds = orderController.allOrdersPending
        .map((order) => order.restaurantID)
        .where((id) => id != null)
        .cast<String>()
        .toList();
    await restaurantController.loadRestaurants(restaurantIds);
  }

  Future<void> _loadCompleteOrders() async {
    await orderController.getOrdersCompleteAndCancel();
    final restaurantIds = orderController.allOrdersCompleteAndCancel
        .map((order) => order.restaurantID)
        .where((id) => id != null)
        .cast<String>()
        .toList();
    await restaurantController.loadRestaurants(restaurantIds);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: TColor.textfield,
        appBar: AppBar(
          backgroundColor: TColor.white,
          title: Text(
            "Đơn hàng",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          bottom: TabBar(
            indicatorColor: TColor.primary,
            onTap: (index) {
              if (index == 1) {
                orderController.selectStatus("Tất cả");
                _completeOrdersFuture = _loadCompleteOrders(); // Update future
              }
            },
            tabs: const [
              Tab(text: "Đang đến"),
              Tab(text: "Lịch sử"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<void>(
              future: _pendingOrdersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Obx(() {
                    return orderController.allOrdersPending.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/checklist.png",
                                scale: 1.8,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                "Quên chưa đặt món rồi nè bạn ơi?",
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  "Bạn sẽ nhìn thấy các món đang được chuẩn bị hoặc giao đi tại đây để kiểm tra đơn hàng nhanh hơn!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          )
                        : PendingView(
                            orderController: orderController,
                            orderDetailController: orderDetailController,
                          );
                  });
                }
              },
            ),
            FutureBuilder<void>(
              future: _completeOrdersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Obx(() {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  orderController.togglePopup();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      orderController.selectedStatus.value,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: orderController
                                                      .selectedStatus.value ==
                                                  'Đang xử lý'
                                              ? TColor.primaryText
                                              : TColor.primary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    orderController.isPopupVisible.value
                                        ? Icon(
                                            Icons.keyboard_arrow_up,
                                            color: orderController
                                                        .selectedStatus.value ==
                                                    'Đang xử lý'
                                                ? TColor.primaryText
                                                : TColor.primary,
                                          )
                                        : Icon(
                                            Icons.keyboard_arrow_down,
                                            color: orderController
                                                        .selectedStatus.value ==
                                                    'Đang xử lý'
                                                ? TColor.primaryText
                                                : TColor.primary,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            if (!orderController.isPopupVisible.value)
                              HistoryOrderView(
                                controller: orderDetailController,
                              ),
                          ],
                        ),
                        orderController.isPopupVisible.value
                            ? Positioned(
                                left: 0,
                                right: 0,
                                top: 50,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: orderController.statuses1
                                        .map((String status) {
                                      final bool isSelected = orderController
                                              .selectedStatus.value ==
                                          status;
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
