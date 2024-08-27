import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ResetPassSuccessView extends StatefulWidget {
  final String email;
  const ResetPassSuccessView({super.key, required this.email});

  @override
  State<ResetPassSuccessView> createState() => _ResetPassSuccessViewState();
}

class _ResetPassSuccessViewState extends State<ResetPassSuccessView> {
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              Lottie.asset("assets/images/success.json",
                  width: MediaQuery.of(context).size.width * 0.6),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Đặt lại mật khẩu thành công',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: TColor.primaryText,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Liên kết đã được gửi đến email của bạn. Vui lòng kiểm tra email ${widget.email} \nđể đặt lại mật khẩu mới. Nếu đã đặt lại mật khẩu mới, vui lòng ấn nút hoàn thành để đăng nhập',
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
                  onPressed: () {
                    Get.offAll(() => const LoginView());
                  },
                  title: 'Hoàn thành'),
              TextButton(
                onPressed: () {
                  AuthenticationRepository.instance
                      .sendPasswordReset(widget.email);
                },
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
