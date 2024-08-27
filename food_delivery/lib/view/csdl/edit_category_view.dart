import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:get/get.dart';

class EditCategoryView extends StatefulWidget {
  final String categoryId;
  const EditCategoryView({super.key, required this.categoryId});

  @override
  State<EditCategoryView> createState() => _EditCategoryViewState();
}

class _EditCategoryViewState extends State<EditCategoryView> {
  final controller = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    controller.txtName.clear();
    controller.txtImageUrl.value = '';
    // Lấy dữ liệu nhà hàng khi khởi tạo
    controller.getCategory(widget.categoryId);
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
          "Sửa danh mục",
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
                      title: "Tên danh mục",
                      hintText: "Danh mục",
                      controller: controller.txtName,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundButton(
                        title: "Lưu",
                        onPressed: () {
                          if (controller.txtName.text == "") {
                            Get.snackbar(
                                'Lỗi', "Vui lòng nhập đầy đủ thông tin!!");
                          } else {
                            controller.updateInformation(
                                context, widget.categoryId);
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
      ),
    );
  }
}
