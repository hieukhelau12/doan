// ignore_for_file: prefer_collection_literals, unused_field, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/address_controller.dart';
import 'package:food_delivery/view/more/add_address_view.dart';
import 'package:food_delivery/view/more/edit_address_view.dart';
import 'package:get/get.dart';

import '../../common/color_extension.dart';

class ChangeAddressView extends StatefulWidget {
  const ChangeAddressView({super.key});

  @override
  State<ChangeAddressView> createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<ChangeAddressView> {
  final addressController = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    addressController.getDefaultAddress();
    addressController.getNoDefaultAddresses();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
          "Thay đổi địa chỉ",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundTextField(
                          hintText: "Tìm kiếm địa chỉ",
                          left: Icon(Icons.search, color: TColor.primaryText),
                        ),
                        SizedBox(
                          height: media.height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            "Địa chỉ mặc định",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Obx(() {
                          final defaultAddress =
                              addressController.defaultAddress.value;
                          return InkWell(
                            onTap: () {
                              Get.back(result: defaultAddress);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: TColor.primary,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          defaultAddress.displayName ?? "",
                                          style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${defaultAddress.detailAddress}, ${defaultAddress.ward}, ${defaultAddress.district}, ${defaultAddress.city}",
                                          style: TextStyle(
                                              color: TColor.secondaryText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${defaultAddress.clientName} - ${defaultAddress.phoneNumber}",
                                          style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Địa chỉ mặc định",
                                          style: TextStyle(
                                            color: TColor.primary,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Get.to(() => EditAddressView(
                                            address: defaultAddress,
                                          ));
                                    },
                                    child: Text(
                                      "Sửa",
                                      style: TextStyle(color: TColor.primary),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                        Container(
                          decoration: BoxDecoration(color: TColor.textfield),
                          height: 8,
                        ),
                        Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (addressController
                                  .noDefaultAddresses.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text(
                                    "Địa chỉ đã lưu",
                                    style: TextStyle(
                                        color: TColor.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              if (addressController
                                  .noDefaultAddresses.isNotEmpty)
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: addressController
                                      .noDefaultAddresses.length,
                                  separatorBuilder: ((context, index) =>
                                      Divider(
                                        indent: 5,
                                        endIndent: 5,
                                        color: TColor.secondaryText
                                            .withOpacity(0.4),
                                        height: 0.5,
                                      )),
                                  itemBuilder: ((context, index) {
                                    var list = addressController
                                        .noDefaultAddresses[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.back(result: list);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: TColor.primary,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    list.displayName ?? "",
                                                    style: TextStyle(
                                                        color:
                                                            TColor.primaryText,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${list.detailAddress}, ${list.ward}, ${list.district}, ${list.city}",
                                                    style: TextStyle(
                                                        color: TColor
                                                            .secondaryText,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${list.clientName} - ${list.phoneNumber}",
                                                    style: TextStyle(
                                                        color:
                                                            TColor.primaryText,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(() => EditAddressView(
                                                      address: list,
                                                    ));
                                              },
                                              child: Text(
                                                "Sửa",
                                                style: TextStyle(
                                                    color: TColor.primary),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: RoundButton(
                    title: "Thêm địa chỉ mới",
                    onPressed: () {
                      Get.to(() => const AddAddressView());
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
