import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/category_controller.dart';
import 'package:get/get.dart';

class AddCategoryView extends StatefulWidget {
  const AddCategoryView({super.key});

  @override
  State<AddCategoryView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<AddCategoryView> {
  final controller = Get.put(CategoryController());
  @override
  void initState() {
    super.initState();
    controller.txtName.clear();
    controller.txtImageUrl.value = '';
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
            "Thêm danh mục",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Obx(
                  () {
                    return Column(
                      children: [
                        controller.selectedImage.value.isNotEmpty
                            ? Image.file(
                                File(controller.selectedImage.value),
                                height: 350,
                                width: 350,
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Text(
                                    "Vui lòng thêm ảnh danh mục bằng nút phía dưới !!!")),
                        TextButton.icon(
                          onPressed: () {
                            controller.pickImage();
                          },
                          icon: Icon(
                            Icons.edit,
                            color: TColor.primary,
                            size: 13,
                          ),
                          label: Text(
                            "Chọn ảnh danh mục",
                            style:
                                TextStyle(color: TColor.primary, fontSize: 13),
                          ),
                        ),
                        RoundTitleTextfield(
                          title: "Tên danh mục",
                          hintText: "Nhập tên danh mục ...",
                          controller: controller.txtName,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        RoundButton(
                            title: "Lưu",
                            onPressed: () {
                              if (controller.txtName.text == "") {
                                Get.snackbar(
                                    'Lỗi', "Vui lòng nhập đầy đủ thông tin!!");
                              } else {
                                controller.addCategory(context);
                              }
                            }),
                      ],
                    );
                  },
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
        ));
  }
}
