import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/currency_formatter.dart';
import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/models/item_model.dart';
import 'package:get/get.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final itemController = Get.find<ItemController>();

    return Container(
      height: 400,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15), // Bo góc trên bên phải
          topLeft: Radius.circular(15), // Góc trên bên trái không bo
          bottomRight: Radius.circular(0), // Góc dưới bên phải không bo
          bottomLeft: Radius.circular(0), // Góc dưới bên trái không bo
        ),
      ),
      child: Obx(() {
        List<ItemModel> itemsWithQuantities = [];
        for (int i = 0; i < itemController.allItemsByResId.length; i++) {
          if (itemController.quantities[i] > 0) {
            itemsWithQuantities.add(itemController.allItemsByResId[i]);
          }
        }

        return Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    itemController.clearAllQuantities();
                    if (itemController.isOpen.value) {
                      itemController.isOpen.value =
                          !itemController.isOpen.value;
                    }
                  },
                  child: Text(
                    "Xoá tất cả",
                    style: TextStyle(fontSize: 12, color: TColor.primary),
                  ),
                ),
                const SizedBox(
                  width: 87,
                ),
                const Text(
                  "Giỏ hàng",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      if (itemController.isOpen.value) {
                        itemController.isOpen.value =
                            !itemController.isOpen.value;
                      }
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: itemsWithQuantities.length,
                itemBuilder: (context, index) {
                  final item = itemsWithQuantities[index];
                  final quantity = itemController
                      .quantities[itemController.allItemsByResId.indexOf(item)];

                  return ListTile(
                    leading: CachedNetworkImage(
                      height: 60,
                      width: 60,
                      imageUrl: item.imageUrl ?? "",
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    title: Text(item.itemName ?? "Tên món ăn"),
                    subtitle: Text("Số lượng: $quantity"),
                    trailing: Text(formatCurrency(
                        double.tryParse(item.price ?? '0') ?? 0)),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
