import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/currency_formatter.dart';
import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/view/more/checkout_view.dart';
import 'package:get/get.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final itemController = Get.put(ItemController());
    return Obx(() {
      return Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))
        ]),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                if (itemController.isOpen.value) {
                  itemController.isOpen.value = !itemController.isOpen.value;
                } else {
                  itemController.isOpen.value = !itemController.isOpen.value;
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset("assets/images/shopping_cart.png",
                      width: 35, height: 35, color: TColor.primary),
                  Positioned(
                    top: -16,
                    right: -18,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: TColor.primary, // Màu sắc của hình tròn nhỏ
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Màu sắc viền của hình tròn nhỏ
                          width: 2, // Độ dày của viền
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${itemController.getTotalQuantity()}', // Số lượng hoặc thông báo
                          style: const TextStyle(
                            color: Colors.white, // Màu sắc của chữ
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(
              width: 15,
            ),
            Text(
              formatCurrency(itemController.total.value),
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 19,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              width: 18,
            ),
            InkWell(
                onTap: () {
                  Get.to(() => const CheckOutView());
                },
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  color: TColor.primary,
                  child: Text(
                    "Đặt hàng",
                    style: TextStyle(
                        fontSize: 14,
                        color: TColor.white,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ],
        ),
      );
    });
  }
}
