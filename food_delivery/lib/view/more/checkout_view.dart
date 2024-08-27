import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/currency_formatter.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/controller/address_controller.dart';
import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/models/item_model.dart';
import 'package:food_delivery/view/more/change_address_view.dart';
import 'package:food_delivery/view/more/checkout_message_view.dart';
import 'package:get/get.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  List paymentArr = [
    {"name": "Tiền mặt", "icon": "assets/images/cash.png"},
    {"name": "Ngân hàng", "icon": "assets/images/visa_icon.png"},
  ];

  int selectMethod = 0;
  final addressController = Get.put(AddressController());
  final itemController = Get.put(ItemController());
  final orderController = Get.put(OrderController());
  @override
  void initState() {
    super.initState();
    addressController.getDefaultAddress();
  }

  void _placeOrder() async {
    final addressInfo = addressController.defaultAddress.value;
    final restaurantId = itemController.restaurant.value.restaurantID;
    final totalAmount = itemController.total.value + 20000;
    final paymentMethod = paymentArr[selectMethod]["name"].toString();

    await orderController.addOrder(
      restaurantId: restaurantId,
      totalAmount: totalAmount,
      deliveryAddress:
          "${addressInfo.detailAddress}, ${addressInfo.ward}, ${addressInfo.district}, ${addressInfo.city}",
      clientName: addressInfo.clientName ?? "",
      clientPhone: addressInfo.phoneNumber ?? "",
      paymentMethod: paymentMethod,
    );

    if (orderController.isLoading.value == false) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return const CheckoutMessageView();
        },
      );
    }
  }

  void _openChangeAddressPage() async {
    final selectedAddress = await Get.to(() => const ChangeAddressView());

    if (selectedAddress != null) {
      // Cập nhật địa chỉ đã chọn
      addressController.defaultAddress.value = selectedAddress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TColor.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 46,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
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
                              "Xác nhận đơn hàng",
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Địa chỉ giao hàng",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: TColor.secondaryText, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Obx(() {
                                  final address =
                                      addressController.defaultAddress.value;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${address.clientName} | ${address.phoneNumber}",
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${address.detailAddress}, ${address.ward}, ${address.district}, ${address.city}",
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              TextButton(
                                onPressed: _openChangeAddressPage,
                                child: Text(
                                  "Thay đổi",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: TColor.textfield),
                      height: 8,
                    ),
                    Obx(() {
                      List<ItemModel> itemsWithQuantities = [];
                      for (int i = 0;
                          i < itemController.allItemsByResId.length;
                          i++) {
                        if (itemController.quantities[i] > 0) {
                          itemsWithQuantities
                              .add(itemController.allItemsByResId[i]);
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${itemController.restaurant.value.restaurantName}",
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: itemsWithQuantities.length,
                              separatorBuilder: ((context, index) => Divider(
                                    indent: 5,
                                    endIndent: 5,
                                    color:
                                        TColor.secondaryText.withOpacity(0.4),
                                    height: 0.5,
                                  )),
                              itemBuilder: ((context, index) {
                                var listItem = itemsWithQuantities[index];
                                final quantity = itemController.quantities[
                                    itemController.allItemsByResId
                                        .indexOf(listItem)];
                                double price =
                                    double.tryParse(listItem.price ?? '0') ?? 0;
                                double totalValue = 0.0;
                                totalValue += price * quantity;
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CachedNetworkImage(
                                        height: 60,
                                        width: 60,
                                        imageUrl: listItem.imageUrl ?? "",
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "$quantity x ${listItem.itemName ?? ""}",
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        formatCurrency(totalValue),
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      );
                    }),
                    Container(
                      decoration: BoxDecoration(color: TColor.textfield),
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 4),
                            child: Text(
                              "Phương thức thanh toán",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: TColor.secondaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: paymentArr.length,
                              itemBuilder: (context, index) {
                                var pObj = paymentArr[index] as Map? ?? {};
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectMethod = index;
                                    });
                                  },
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 8, 15, 8),
                                    decoration: BoxDecoration(
                                        color: TColor.textfield,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: TColor.secondaryText
                                                .withOpacity(0.2))),
                                    child: Row(
                                      children: [
                                        Image.asset(pObj["icon"].toString(),
                                            width: 50,
                                            height: 20,
                                            fit: BoxFit.contain),
                                        // const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            pObj["name"],
                                            style: TextStyle(
                                                color: TColor.primaryText,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Icon(
                                          selectMethod == index
                                              ? Icons.radio_button_on
                                              : Icons.radio_button_off,
                                          color: TColor.primary,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(color: TColor.textfield),
                      height: 8,
                    ),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tổng cộng",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  formatCurrency(itemController.total.value),
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Phí vận chuyển",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  formatCurrency(20000),
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            // const SizedBox(
                            //   height: 8,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       "Mã khuyến mãi",
                            //       textAlign: TextAlign.center,
                            //       style: TextStyle(
                            //           color: TColor.primaryText,
                            //           fontSize: 13,
                            //           fontWeight: FontWeight.w500),
                            //     ),
                            //     Text(
                            //       "-\$4",
                            //       style: TextStyle(
                            //           color: TColor.primaryText,
                            //           fontSize: 13,
                            //           fontWeight: FontWeight.w700),
                            //     )
                            //   ],
                            // ),
                            const SizedBox(
                              height: 15,
                            ),
                            Divider(
                              color: TColor.secondaryText.withOpacity(0.5),
                              height: 1,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tổng cộng",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  formatCurrency(
                                      itemController.total.value + 20000),
                                  style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(color: TColor.textfield),
                      height: 8,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 25),
                        child: RoundButton(
                            title: "Đặt hàng", onPressed: _placeOrder)),
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
            })
          ],
        ));
  }
}
