import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/currency_formatter.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/controller/order_detail_controller.dart';
import 'package:food_delivery/models/item_model.dart';
import 'package:food_delivery/models/ordel_detail_model.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:get/get.dart';

class OrderDetailView extends StatefulWidget {
  const OrderDetailView({
    super.key,
    required this.orderId,
    required this.listItem,
    this.isAdmin = false,
  });
  final String orderId;
  final RestaurantModel listItem;
  final bool isAdmin;

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final orderController = Get.put(OrderController());
  final orderDetailController = Get.put(OrderDetailController());
  @override
  void initState() {
    super.initState();
    // orderDetailController.getOrder(widget.orderId);
    orderController.getOrderById(widget.orderId);
  }

  DateTime getOrderDateTime(OrderModel? order) {
    if (order != null && order.orderDate != null) {
      return DateTime.parse(order.orderDate!);
    } else {
      return DateTime.now();
    }
  }

  DateTime getCompleteDateTime(OrderModel? order) {
    if (order != null && order.completeDate != null) {
      return DateTime.parse(order.completeDate!);
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
    return Scaffold(
      body: Obx(() {
        var order = orderController.order.value;
        DateTime dateTime = getOrderDateTime(order);
        // DateTime completeDateTime = getCompleteDateTime(order);
        // String completeDate = formatDateTime(completeDateTime);
        String orderDate = formatDateTime(dateTime);
        String status = '';
        if (order.status == 1) {
          status = "Đang xử lý";
        } else if (order.status == 2) {
          status = "Đang giao hàng";
        } else if (order.status == 3) {
          status = "Đã huỷ";
        } else if (order.status == 4) {
          status = "Hoàn thành";
        }
        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 46,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset("assets/images/btn_back.png",
                              width: 20, height: 20),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "Thông tin đơn hàng",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        if (!widget.isAdmin)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  status,
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (order.status == 1)
                                  const Text(
                                      "Đơn của bạn đang được quán ăn xử lý, vui lòng đợi trong giây lát!"),
                                if (order.status == 2)
                                  const Text(
                                      "Đơn của bạn đang được giao đến, bạn vui lòng để ý điện thoại!"),
                                if (order.status == 3)
                                  const Text(
                                      "Bạn đã huỷ đơn, nếu có vấn đề gì về đơn hàng hãy liên hệ với chúng tôi!"),
                                if (order.status == 4)
                                  const Text(
                                      "Nếu cần hỗ trợ thêm về vấn đề gì, bạn vui lòng truy cập trung tâm trợ giúp nhé!!")
                              ],
                            ),
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (!widget.isAdmin)
                          if (order.status == 1)
                            Image.asset(
                              "assets/images/cooking.png",
                              scale: 1.5,
                            ),
                        if (!widget.isAdmin)
                          if (order.status == 2)
                            Image.asset(
                              "assets/images/delivery.png",
                              scale: 1.5,
                            ),
                        if (!widget.isAdmin)
                          if (order.status == 3)
                            Image.asset(
                              "assets/images/cancel-order.png",
                              scale: 1.5,
                            ),
                        if (!widget.isAdmin)
                          if (order.status == 4)
                            Image.asset(
                              "assets/images/package.png",
                              scale: 1.5,
                            ),
                      ],
                    ),
                    if (!widget.isAdmin)
                      const SizedBox(
                        height: 25,
                      ),
                    if (!widget.isAdmin)
                      Divider(
                        height: 0.1,
                        color: TColor.placeholder.withOpacity(0.3),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.fiber_manual_record,
                              size: 13,
                              color: TColor.primary,
                            ),
                            const Text("Từ"),
                          ],
                        ),
                        Text(
                          "${widget.listItem.restaurantName}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${widget.listItem.address}",
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.fiber_manual_record,
                              size: 13,
                              color: Colors.green,
                            ),
                            Text(
                              "Đến",
                            ),
                          ],
                        ),
                        Text(
                          "${order.deliveryAddress}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${order.clientName} - ${order.clientPhone}",
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 0.1,
                      color: TColor.placeholder.withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Chi tiết đơn hàng",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    FutureBuilder<List<OrderDetailModel>>(
                      future:
                          orderDetailController.getOrderDetails(widget.orderId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text("No items found"));
                        } else {
                          List<OrderDetailModel> orderDetails = snapshot.data!;

                          return FutureBuilder<List<ItemModel>>(
                            future: orderDetailController
                                .getItemsForOrder(widget.orderId),
                            builder: (context, itemSnapshot) {
                              if (itemSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (itemSnapshot.hasError) {
                                return Center(
                                    child:
                                        Text("Error: ${itemSnapshot.error}"));
                              } else if (!itemSnapshot.hasData ||
                                  itemSnapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text("No items found"));
                              } else {
                                List<ItemModel> items = itemSnapshot.data!;
                                int totalQuantity = 0;
                                double totalPrice = 0;
                                for (var detail in orderDetails) {
                                  totalQuantity +=
                                      detail.quantity?.toInt() ?? 0;
                                  totalPrice += double.tryParse(
                                          detail.totalPrice ?? "") ??
                                      0;
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      itemCount: items.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, itemIndex) {
                                        final item = items[itemIndex];
                                        OrderDetailModel orderDetail =
                                            OrderDetailModel.empty();
                                        for (var detail in orderDetails) {
                                          if (detail.itemID == item.itemID) {
                                            orderDetail = detail;
                                          }
                                        }
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Row(
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
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  "${orderDetail.quantity} x ${item.itemName ?? ""}",
                                                  style: TextStyle(
                                                    color: TColor.primaryText,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                formatCurrency(
                                                  double.tryParse(orderDetail
                                                              .totalPrice ??
                                                          "") ??
                                                      0,
                                                ),
                                                style: TextStyle(
                                                  color: TColor.primaryText,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    Divider(
                                      color:
                                          TColor.secondaryText.withOpacity(0.2),
                                      height: 0.3,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          "Tổng ($totalQuantity món)",
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          formatCurrency(totalPrice),
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Phí giao hàng",
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          formatCurrency(20000),
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        formatCurrency(double.tryParse(
                                                order.totalAmount ?? "") ??
                                            0),
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Mã đơn hàng",
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.orderId,
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: widget.orderId))
                                                  .then((_) {
                                                // Hiển thị thông báo sau khi sao chép thành công
                                                Get.showSnackbar(
                                                  const GetSnackBar(
                                                    title: "Thông báo",
                                                    message:
                                                        "Đã sao chép vào bộ nhớ tạm!",
                                                    duration:
                                                        Duration(seconds: 2),
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              });
                                            },
                                            child: Text(
                                              "Sao chép",
                                              style: TextStyle(
                                                  color: TColor.primary),
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Thời gian đặt hàng",
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          orderDate,
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (order.status == 4)
                                      Row(
                                        children: [
                                          Text(
                                            "Thời gian giao hoàn thành",
                                            style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "",
                                            style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (order.status == 4)
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    Row(
                                      children: [
                                        Text(
                                          "Thanh toán",
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          order.paymentMethod ?? "",
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    if (order.status == 1)
                                      RoundButton(
                                          title: "Đã chuẩn bị xong món",
                                          onPressed: () {
                                            orderController.onUpdatePressed(
                                                context, widget.orderId, 2);
                                          }),
                                    if (order.status == 2)
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              orderController.onUpdatePressed(
                                                  context, widget.orderId, 4);
                                            },
                                            child: Container(
                                              height: 56,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(28),
                                              ),
                                              child: Text(
                                                "Giao hàng thành công",
                                                style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              orderController.onUpdatePressed(
                                                  context, widget.orderId, 3);
                                            },
                                            child: Container(
                                              height: 56,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: TColor.primary,
                                                    width: 1),
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(28),
                                              ),
                                              child: Text(
                                                "Giao hàng thất bại",
                                                style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    if (!widget.isAdmin)
                                      if (order.status == 1)
                                        RoundButton(
                                            title: "Huỷ đơn hàng",
                                            onPressed: () {
                                              orderController.onUpdatePressed(
                                                  context, widget.orderId, 3);
                                            })
                                  ],
                                );
                              }
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            Obx(() {
              return orderController.isLoading.value
                  ? Positioned(
                      child: Container(
                        color: Colors.black12,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ],
        );
      }),
    );
  }
}
