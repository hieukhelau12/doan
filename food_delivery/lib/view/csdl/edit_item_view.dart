import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/constants.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/controller/item_controller.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:food_delivery/models/category_model.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:get/get.dart';

class EditItemView extends StatefulWidget {
  final String itemId;
  final String categoryId;
  final String restaurantId;
  const EditItemView(
      {super.key,
      required this.itemId,
      required this.categoryId,
      required this.restaurantId});

  @override
  State<EditItemView> createState() => _EditItemViewState();
}

class _EditItemViewState extends State<EditItemView> {
  final itemController = Get.put(ItemController());
  final restaurantController = Get.put(RestaurantController());
  final categoryController = Get.put(CategoryController());
  final TextEditingController categoryEditingController =
      TextEditingController();
  final TextEditingController restaurantEditingController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    itemController.selectedRestaurant.value = widget.restaurantId;
    itemController.selectedCategory.value = widget.categoryId;
    itemController.txtName.clear();
    itemController.txtPrice.clear();
    itemController.txtImageUrl.value = "";
    itemController.getItem(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
              Image.asset("assets/images/btn_back.png", width: 20, height: 20),
        ),
        centerTitle: false,
        title: Text(
          "Sửa món ăn",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            if (!categoryController.allCategories.any((category) =>
                category.itemCategoryID ==
                itemController.selectedCategory.value)) {
              final category = categoryController
                  .getCategoryNameById(itemController.selectedCategory.value);
              itemController.selectedCategory.value = category;
            }
            if (!restaurantController.allRestaurants.any((restaurant) =>
                restaurant.restaurantID ==
                itemController.selectedRestaurant.value)) {
              final restaurant = restaurantController.getRestaurantNameById(
                  restaurantController.allRestaurants.first.restaurantID);
              itemController.selectedRestaurant.value = restaurant;
            }
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (itemController.txtImageUrl.value.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: itemController.txtImageUrl.value,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    TextButton.icon(
                      onPressed: () {
                        itemController.pickImage();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: TColor.primary,
                        size: 12,
                      ),
                      label: Text(
                        "Thay đổi ảnh quán ăn",
                        style: TextStyle(color: TColor.primary, fontSize: 12),
                      ),
                    ),
                    RoundTitleTextfield(
                      title: "Tên món ăn",
                      hintText: "Tên món",
                      controller: itemController.txtName,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RoundTitleTextfield(
                      title: "Giá",
                      hintText: "Giá",
                      keyboardType: TextInputType.number,
                      controller: itemController.txtPrice,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonFormField2<CategoryModel>(
                        decoration: InputDecoration(
                          labelText: "Chọn danh mục",
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: categoryController.allCategories.firstWhere(
                          (category) =>
                              category.itemCategoryID ==
                              itemController.selectedCategory.value,
                          orElse: () => defaultCategory,
                        ),
                        isExpanded: true,
                        onChanged: (CategoryModel? newValue) {
                          itemController.selectedCategory.value =
                              newValue?.itemCategoryID ?? '';
                        },
                        items: [
                          DropdownMenuItem<CategoryModel>(
                            value: defaultCategory,
                            child: Text(
                              defaultCategory.categoryName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          ...categoryController.allCategories.map((category) {
                            return DropdownMenuItem<CategoryModel>(
                              value: category,
                              child: Text(
                                category.categoryName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
                        ],
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: categoryEditingController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: categoryEditingController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Tìm kiếm danh mục',
                                hintStyle: const TextStyle(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (category, searchValue) {
                            final name =
                                category.value!.categoryName.toLowerCase();
                            final searchTerm = searchValue.toLowerCase();
                            return name.contains(searchTerm);
                          },
                        ),
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            categoryEditingController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonFormField2<RestaurantModel>(
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          isDense: true,
                          labelText: "Chọn quán ăn",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: restaurantController.allRestaurants.firstWhere(
                          (restaurant) =>
                              restaurant.restaurantID ==
                              itemController.selectedRestaurant.value,
                          orElse: () => defaultRestaurant,
                        ),
                        isDense: false,
                        isExpanded: true,
                        onChanged: (RestaurantModel? newValue) {
                          itemController.selectedRestaurant.value =
                              newValue?.restaurantID ?? '';
                        },
                        items: [
                          DropdownMenuItem<RestaurantModel>(
                            value: defaultRestaurant,
                            child: Text(
                              defaultRestaurant.restaurantName ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          ...restaurantController.allRestaurants
                              .map((restaurant) {
                            return DropdownMenuItem<RestaurantModel>(
                              value: restaurant,
                              child: Text(
                                restaurant.restaurantName ?? "",
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
                        ],
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: restaurantEditingController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: restaurantEditingController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Tìm kiếm quán ăn',
                                hintStyle: const TextStyle(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (restaurant, searchValue) {
                            final name =
                                restaurant.value!.restaurantName!.toLowerCase();
                            final searchTerm = searchValue.toLowerCase();
                            return name.contains(searchTerm);
                          },
                        ),
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            restaurantEditingController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundButton(
                        title: "Lưu",
                        onPressed: () {
                          if (itemController.txtName.text == "" ||
                              itemController.txtPrice.text == "" ||
                              itemController.selectedRestaurant.value == "" ||
                              itemController.selectedCategory.value == "") {
                            Get.snackbar(
                                'Lỗi', "Vui lòng nhập đầy đủ thông tin!!");
                          } else {
                            itemController.updateInformation(
                                context, widget.itemId);
                          }
                        }),
                  ],
                ),
              ),
            );
          }),
          Obx(() {
            return itemController.isLoading.value ||
                    categoryController.allCategories.isEmpty ||
                    restaurantController.allRestaurants.isEmpty
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
      ),
    );
  }
}
