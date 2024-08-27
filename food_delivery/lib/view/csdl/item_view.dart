import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/view/csdl/edit_item_view.dart';
import 'package:get/get.dart';

class ItemView extends StatefulWidget {
  const ItemView({super.key});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final itemController = Get.put(ItemController());
  final restaurantController = Get.put(RestaurantController());
  final categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    itemController.txtSearch.clear();
    fetchCategoriesAndRestaurants();
  }

  Future<void> fetchCategoriesAndRestaurants() async {
    for (var item in itemController.allItems) {
      await categoryController.getCategory(item.itemCategoryID ?? "");
      await restaurantController.getRestaurant(item.restaurantID ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RoundTextField(
                    controller: itemController.txtSearch,
                    hintText: "Tìm kiếm món ăn",
                    left: Container(
                      alignment: Alignment.center,
                      width: 30,
                      child: Image.asset(
                        "assets/images/search.png",
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: itemController.filteredItems.length,
                    separatorBuilder: ((context, index) => Divider(
                          indent: 25,
                          endIndent: 25,
                          color: TColor.secondaryText.withOpacity(0.4),
                          height: 1,
                        )),
                    itemBuilder: ((context, index) {
                      var listItem = itemController.filteredItems[index];
                      var categoryName = categoryController
                          .getCategoryNameById(listItem.itemCategoryID ?? "");
                      var restaurantName = restaurantController
                          .getRestaurantNameById(listItem.restaurantID ?? "");
                      return Container(
                        decoration: BoxDecoration(color: TColor.white),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              height: 90,
                              width: 90,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listItem.itemName ?? "",
                                    style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Giá: ${listItem.price} VND",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Danh mục: $categoryName",
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Thuộc quán: $restaurantName",
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.to(() => EditItemView(
                                          itemId: listItem.itemID ?? "",
                                          categoryId:
                                              listItem.itemCategoryID ?? "",
                                          restaurantId:
                                              listItem.restaurantID ?? "",
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.edit_square,
                                    color: TColor.secondaryText,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    itemController.onDeletePressed(
                                        context, listItem.itemID ?? "");
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: TColor.secondaryText,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                  );
                })
              ],
            ),
          ),
        ),
        Obx(() {
          return itemController.isLoading.value
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
    );
  }
}
