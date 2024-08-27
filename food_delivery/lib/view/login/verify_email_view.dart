import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/controller/verify_email_controller.dart';
import 'package:get/get.dart';

class VerifyEmailView extends StatefulWidget {
  final String? email;
  const VerifyEmailView({super.key, this.email});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailAddressState();
}

class _VerifyEmailAddressState extends State<VerifyEmailView> {
  final controller = Get.put(VerifyEmailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/send_email.png"),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Xác minh địa chỉ Email của bạn',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: TColor.primaryText,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Liên kết đã được gửi đến email của bạn. Vui lòng kiểm tra email ${widget.email ?? ""} \nđể xác thực tài khoản của mình',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: TColor.secondaryText,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  onPressed: () => controller.checkEmailVerificationStatus(),
                  title: 'Tiếp theo'),
              const SizedBox(
                height: 4,
              ),
              TextButton(
                onPressed: () => controller.sendEmailVerification(),
                style: const ButtonStyle(),
                child: Text(
                  'Gửi lại liên kết',
                  style: TextStyle(
                      fontSize: 14,
                      color: TColor.primary,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
