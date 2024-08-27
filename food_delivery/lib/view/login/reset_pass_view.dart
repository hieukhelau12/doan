import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/controller/forgot_password_controller.dart';
import 'package:get/get.dart';

class ResetPassView extends StatefulWidget {
  const ResetPassView({super.key});

  @override
  State<ResetPassView> createState() => _ResetPassViewState();
}

class _ResetPassViewState extends State<ResetPassView> {
  TextEditingController txtEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 64,
              ),
              Text(
                'Đặt lại mật khẩu',
                style: TextStyle(
                    fontSize: 30,
                    color: TColor.primaryText,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Vui lòng nhập email của bạn để nhận link \ntạo mật khẩu mới qua email',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: TColor.secondaryText,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 50,
              ),
              RoundTextField(
                  controller: controller.txtEmail,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  onPressed: () {
                    controller.sendPasswordReset();
                  },
                  title: 'Gửi'),
            ],
          ),
        ),
      ),
    );
  }
}
