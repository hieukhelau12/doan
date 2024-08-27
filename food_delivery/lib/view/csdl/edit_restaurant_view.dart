// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/constants.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:food_delivery/models/category_model.dart';
import 'package:get/get.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/restaurant_controller.dart';
import 'package:intl/intl.dart';

class EditRestaurantView extends StatefulWidget {
  final String restaurantId;
  final String categoryId;
  const EditRestaurantView({
    super.key,
    required this.restaurantId,
    required this.categoryId,
  });

  @override
  State<EditRestaurantView> createState() => _EditRestaurantViewState();
}

class _EditRestaurantViewState extends State<EditRestaurantView> {
  final controller = Get.put(RestaurantController());
  final categoryController = Get.put(CategoryController());
  @override
  void initState() {
    super.initState();
    controller.selectedCategory.value = widget.categoryId;
    controller.txtName.clear();
    controller.txtAddress.clear();
    controller.txtIdCatogory.clear();
    controller.txtOpen.value = "";
    controller.txtClose.value = "";
    controller.txtImageUrl.value = '';
    // Lấy dữ liệu nhà hàng khi khởi tạo
    controller.getRestaurant(widget.restaurantId);
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
            icon: Image.asset("assets/images/btn_back.png",
                width: 20, height: 20),
          ),
          centerTitle: false,
          title: Text(
            "Sửa quán ăn",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
        ),
        body: Stack(
          children: [
            Obx(() {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      if (controller.txtImageUrl.value.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: controller.txtImageUrl.value,
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
                          controller.pickImage();
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
                        title: "Tên quán ăn",
                        hintText: "Nhập tên quán ăn ...",
                        controller: controller.txtName,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundTitleTextfield(
                        title: "Địa chỉ",
                        hintText: "Nhập địa chị ...",
                        controller: controller.txtAddress,
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
                                controller.selectedCategory.value,
                            orElse: () => defaultCategory,
                          ),
                          isExpanded: true,
                          onChanged: (CategoryModel? newValue) {
                            controller.selectedCategory.value =
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
                            searchController:
                                controller.categoryEditingController,
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
                                controller:
                                    controller.categoryEditingController,
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
                              controller.categoryEditingController.clear();
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final DateTime? result =
                                    await showBoardDateTimePicker(
                                  context: context,
                                  pickerType: DateTimePickerType.time,
                                  initialDate: DateTime.now(),
                                );
                                if (result != null) {
                                  // Định dạng DateTime thành HH:mm
                                  final String formattedTime =
                                      DateFormat('HH:mm').format(result);
                                  controller.txtOpen.value = formattedTime;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: TColor.textfield,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Giờ mở cửa:",
                                      style: TextStyle(
                                          color: TColor.secondaryText),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      controller.txtOpen.value,
                                      style: TextStyle(
                                          color: TColor.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final DateTime? result =
                                    await showBoardDateTimePicker(
                                  context: context,
                                  pickerType: DateTimePickerType.time,
                                  initialDate: DateTime.now(),
                                );
                                if (result != null) {
                                  final String formattedTime =
                                      DateFormat('HH:mm').format(result);
                                  controller.txtClose.value = formattedTime;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: TColor.textfield,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Giờ đóng cửa:",
                                      style: TextStyle(
                                          color: TColor.secondaryText),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      controller.txtClose.value,
                                      style: TextStyle(
                                          color: TColor.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundButton(
                          title: "Lưu",
                          onPressed: () {
                            if (controller.txtName.text == "" ||
                                controller.txtAddress.text == "" ||
                                controller.txtClose.value == "" ||
                                controller.selectedCategory.value == "" ||
                                controller.txtOpen.value == "") {
                              Get.snackbar(
                                  'Lỗi', "Vui lòng nhập đầy đủ thông tin !!");
                            } else {
                              controller.updateInformation(
                                  context, widget.restaurantId);
                            }
                          }),
                    ],
                  ),
                ),
              );
            }),
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
            }),
          ],
        ));
  }
}
