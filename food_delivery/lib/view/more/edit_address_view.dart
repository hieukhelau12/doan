import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/address_controller.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:get/get.dart';

class EditAddressView extends StatefulWidget {
  const EditAddressView({super.key, required this.address});
  final AddressModel address;
  @override
  State<EditAddressView> createState() => _EditAddressViewState();
}

class _EditAddressViewState extends State<EditAddressView> {
  final addressController = Get.put(AddressController());
  @override
  void initState() {
    super.initState();
    addressController.txtDisplayName.text = widget.address.displayName ?? "";
    addressController.txtClientName.text = widget.address.clientName ?? "";
    addressController.txtPhone.text = widget.address.phoneNumber ?? "";
    addressController.txtDetailAddress.text =
        widget.address.detailAddress ?? "";
    addressController.txtDistrict.text = widget.address.district ?? "";
    addressController.txtWard.text = widget.address.ward ?? "";
    addressController.txtCity.text = widget.address.city ?? "";
    addressController.isChecked.value = widget.address.isDefault;
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
            "Sửa địa chỉ",
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
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Obx(() {
                    return Column(
                      children: [
                        RoundTitleTextfield(
                          title: "Tên địa chỉ",
                          hintText: "Tên địa chỉ",
                          controller: addressController.txtDisplayName,
                        ),
                        const SizedBox(height: 10),
                        RoundTitleTextfield(
                          title: "Tên của bạn",
                          hintText: "Tên của bạn",
                          controller: addressController.txtClientName,
                        ),
                        const SizedBox(height: 10),
                        RoundTitleTextfield(
                          title: "Số điện thoại",
                          hintText: "Số điện thoại",
                          controller: addressController.txtPhone,
                        ),
                        const SizedBox(height: 10),
                        RoundTitleTextfield(
                          title: "Địa chỉ cụ thể",
                          hintText: "Địa chỉ cụ thể",
                          controller: addressController.txtDetailAddress,
                        ),
                        const SizedBox(height: 10),
                        RoundTitleTextfield(
                          title: "Phường/Xã",
                          hintText: "Phường/Xã",
                          controller: addressController.txtWard,
                        ),
                        const SizedBox(height: 10),
                        RoundTitleTextfield(
                          title: "Quận/Huyện",
                          hintText: "Quận/Huyện",
                          controller: addressController.txtDistrict,
                        ),
                        const SizedBox(height: 10),
                        RoundTitleTextfield(
                          title: "Thành phố",
                          hintText: "Thành phố",
                          controller: addressController.txtCity,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: addressController.isChecked.value,
                              onChanged: (bool? value) {
                                addressController.isChecked.value =
                                    value ?? false;
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
                                  addressController.txtDetailAddress.text ==
                                      "" ||
                                  addressController.txtDistrict.text == "" ||
                                  addressController.txtWard.text == "" ||
                                  addressController.txtCity.text == "" ||
                                  addressController.txtPhone.text == "") {
                                Get.snackbar(
                                    'Lỗi', "Vui lòng nhập đầy đủ thông tin!!");
                              } else {
                                addressController.updateInformation(
                                    context, widget.address.addressId ?? "");
                              }
                            }),
                        TextButton(
                          onPressed: () {
                            addressController.onDeletePressed(
                                context, widget.address.addressId ?? "");
                          },
                          child: Text(
                            "Xoá địa chỉ",
                            style:
                                TextStyle(color: TColor.primary, fontSize: 14),
                          ),
                        )
                      ],
                    );
                  })),
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
        ));
  }
}
