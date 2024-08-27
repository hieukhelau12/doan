import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/view/csdl/edit_restaurant_view.dart';
import 'package:get/get.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({super.key});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  final controller = Get.put(RestaurantController());
  final categoryController = Get.put(CategoryController());
  // final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchCategories();
    controller.txtSearch.clear();
  }

  Future<void> fetchCategories() async {
    for (var restaurant in controller.allRestaurants) {
      await categoryController.getCategory(restaurant.idCategory ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RoundTextField(
                    controller: controller.txtSearch,
                    hintText: "Tìm kiếm quán ăn",
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
                    itemCount: controller.filteredRestaurants.length,
                    separatorBuilder: ((context, index) => Divider(
                          indent: 25,
                          endIndent: 25,
                          color: TColor.secondaryText.withOpacity(0.4),
                          height: 1,
                        )),
                    itemBuilder: ((context, index) {
                      var list = controller.filteredRestaurants[index];
                      var categoryName = categoryController
                          .getCategoryNameById(list.idCategory ?? "");
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
                              imageUrl: list.imageUrl,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    list.restaurantName ?? "",
                                    style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Danh mục: $categoryName",
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Địa chỉ: ${list.address ?? ""}",
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Giờ mở cửa: ${list.openingTime ?? ""} - ${list.closingTime ?? ""}",
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: TColor.secondaryText,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.to(() => EditRestaurantView(
                                          restaurantId: list.restaurantID,
                                          categoryId: list.idCategory ?? "",
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.edit_square,
                                    color: TColor.secondaryText,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.onDeletePressed(
                                        context, list.restaurantID);
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
                }),
              ],
            ),
          ),
        ),
        Obx(() {
          return controller.isLoading.value
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
