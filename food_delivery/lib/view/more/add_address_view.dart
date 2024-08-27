import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/address_controller.dart';
import 'package:get/get.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final addressController = Get.put(AddressController());
  @override
  void initState() {
    super.initState();
    addressController.txtDisplayName.clear();
    addressController.txtClientName.clear();
    addressController.txtDetailAddress.clear();
    addressController.txtPhone.clear();
    addressController.txtDistrict.clear();
    addressController.txtWard.clear();
    addressController.txtCity.clear();
    addressController.isChecked.value = false;
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
          "Thêm địa chỉ",
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Obx(() {
                return Column(children: [
                  RoundTextField(
                    hintText: "Tên địa chỉ",
                    controller: addressController.txtDisplayName,
                  ),
                  const SizedBox(height: 10),
                  RoundTextField(
                    hintText: "Tên của bạn",
                    controller: addressController.txtClientName,
                  ),
                  const SizedBox(height: 10),
                  RoundTextField(
                    hintText: "Số điện thoại",
                    controller: addressController.txtPhone,
                  ),
                  const SizedBox(height: 10),
                  RoundTextField(
                    hintText: "Địa chỉ cụ thể",
                    controller: addressController.txtDetailAddress,
                  ),
                  const SizedBox(height: 10),
                  RoundTextField(
                    hintText: "Phường/Xã",
                    controller: addressController.txtWard,
                  ),
                  const SizedBox(height: 10),
                  RoundTextField(
                    hintText: "Quận/Huyện",
                    controller: addressController.txtDistrict,
                  ),
                  const SizedBox(height: 10),
                  RoundTextField(
                    hintText: "Thành phố",
                    controller: addressController.txtCity,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: addressController.isChecked.value,
                        onChanged: (bool? value) {
                          addressController.isChecked.value = value ?? false;
                        },
                        // Tùy chỉnh các thuộc tính nếu cần
                      ),
                      const Text(
                        'Vị trí mặc định',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RoundButton(
                      title: "Lưu",
                      onPressed: () {
                        if (addressController.txtDisplayName.text == "" ||
                            addressController.txtClientName.text == "" ||
                            addressController.txtDetailAddress.text == "" ||
                            addressController.txtDistrict.text == "" ||
                            addressController.txtWard.text == "" ||
                            addressController.txtCity.text == "" ||
                            addressController.txtPhone.text == "") {
                          Get.snackbar(
                              'Lỗi', "Vui lòng nhập đầy đủ thông tin!!");
                        } else {
                          addressController.addAddress(context);
                        }
                      }),
                ]);
              }),
            ),
          ),
          Obx(() {
            return addressController.isLoading.value
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
      ),
    );
  }
}
