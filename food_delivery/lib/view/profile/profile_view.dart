import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/change_info_button.dart';
import 'package:food_delivery/common_widget/circular_image.dart';
import 'package:food_delivery/controller/profile_controller.dart';
import 'package:food_delivery/view/profile/change_info_view.dart';
import 'package:food_delivery/view/profile/gender_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 46,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset("assets/images/btn_back.png",
                                width: 20, height: 20),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Thông tin cá nhân",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      return CircularImage(
                        image: networkImage,
                        isNetworkImage: networkImage.isNotEmpty,
                      );
                    }),
                    TextButton.icon(
                      onPressed: () {
                        controller.uploadUserProfilePicture();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: TColor.primary,
                        size: 12,
                      ),
                      label: Text(
                        "Thay đổi ảnh đại diện",
                        style: TextStyle(color: TColor.primary, fontSize: 12),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Xin chào ",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          controller.user.value.name,
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          " !",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ChangeInfoButton(
                      title: "Tên",
                      value: controller.txtName.text,
                      onTap: () {
                        Get.to(() => ChangeInfoView(
                              title: "Tên",
                              controller: controller.txtName,
                              isNameInfo: true,
                            ));
                      },
                    ),
                    Divider(
                      height: 1,
                      color: TColor.placeholder,
                      endIndent: 20,
                      indent: 20,
                      thickness: 0.5,
                    ),
                    ChangeInfoButton(
                      title: "Email",
                      value: controller.txtEmail.text,
                      isDisable: true,
                      onTap: () {},
                    ),
                    Divider(
                      height: 1,
                      color: TColor.placeholder,
                      endIndent: 20,
                      indent: 20,
                      thickness: 0.5,
                    ),
                    ChangeInfoButton(
                      title: "Số điện thoại",
                      value: controller.txtMobile.text,
                      isDisable: true,
                      onTap: () {},
                    ),
                    Divider(
                      height: 1,
                      color: TColor.placeholder,
                      endIndent: 20,
                      indent: 20,
                      thickness: 0.5,
                    ),
                    ChangeInfoButton(
                      title: "Giới tính",
                      value: controller.txtGender.text.isEmpty
                          ? "Cập nhật ngay"
                          : controller.txtGender.text,
                      onTap: () {
                        showGenderSelectionBottomSheet(
                            context, controller.txtGender.text,
                            (selectedGender) {
                          controller.txtGender.text = selectedGender;
                        });
                      },
                    ),
                    Divider(
                      height: 1,
                      color: TColor.placeholder,
                      endIndent: 20,
                      indent: 20,
                      thickness: 0.5,
                    ),
                    Obx(() {
                      return ChangeInfoButton(
                        title: "Ngày sinh",
                        value: controller.txtBirth.value.isEmpty
                            ? "Cập nhật ngay"
                            : controller.txtBirth.value,
                        onTap: () async {
                          final DateTime? result =
                              await showBoardDateTimePicker(
                            context: context,
                            pickerType: DateTimePickerType.date,
                            initialDate: DateTime.now(),
                          );

                          if (result != null) {
                            final formattedDate =
                                "${result.day.toString().padLeft(2, '0')}/${result.month.toString().padLeft(2, '0')}/${result.year}";
                            controller.updateBirthday(formattedDate);
                          }
                        },
                      );
                    }),
                    Divider(
                      height: 1,
                      color: TColor.placeholder,
                      endIndent: 20,
                      indent: 20,
                      thickness: 0.5,
                    ),
                    ChangeInfoButton(
                      title: "Nghề nghiệp",
                      value: controller.txtJob.text.isEmpty
                          ? "Cập nhật ngay"
                          : controller.txtJob.text,
                      onTap: () {
                        Get.to(() => ChangeInfoView(
                              title: "Nghề nghiệp",
                              controller: controller.txtJob,
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            return controller.profileLoading.value
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
