import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/on_boarding/on_boarding_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerifySuccessView extends StatefulWidget {
  const VerifySuccessView({super.key});

  @override
  State<VerifySuccessView> createState() => _VerifyEmailAddressState();
}

class _VerifyEmailAddressState extends State<VerifySuccessView> {
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
                'Tài khoản của bạn đã được tạo thành công',
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
                'Chúc mừng bạn đã hoàn tất việc tạo tài khoản trên ứng dụng đặt đồ ăn My Food của chúng tôi. Hãy nhấn tiếp theo để trải nghiệm ứng dụng với tài khoản của bạn.',
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
                    Get.to(() => const OnBoardingView());
                  },
                  title: 'Tiếp theo'),
            ],
          ),
        ),
      ),
    );
  }
}
