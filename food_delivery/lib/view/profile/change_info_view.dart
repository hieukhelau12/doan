import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/controller/profile_controller.dart';
import 'package:get/get.dart';

class ChangeInfoView extends StatelessWidget {
  const ChangeInfoView(
      {super.key,
      required this.controller,
      required this.title,
      this.isNameInfo = false});
  final TextEditingController controller;
  final String title;
  final bool isNameInfo;
  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: TColor.white,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            color: TColor.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: [
                Text(title),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(
                title: 'Lưu',
                height: 45,
                onPressed: () {
                  if (controller.text == "") {
                    Get.snackbar('Lỗi', "Vui lòng nhập đầy đủ thông tin!!");
                  } else {
                    isNameInfo
                        ? profileController.updateName(context)
                        : profileController.updateJob(context);
                  }
                }),
          )
        ],
      ),
    );
  }
}
