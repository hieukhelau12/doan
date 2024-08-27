import 'package:flutter/material.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:food_delivery/view/login/reset_pass_success_view.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  final txtEmail = TextEditingController();

  sendPasswordReset() async {
    try {
      await AuthenticationRepository.instance.sendPasswordReset(txtEmail.text);
      Get.snackbar("Thông báo",
          "Vui lòng kiểm tra hộp thư đến và xác minh email của bạn");
      Get.to(() => ResetPassSuccessView(email: txtEmail.text));
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    }
  }
}
