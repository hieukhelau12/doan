import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:food_delivery/view/login/verify_success_view.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();
  @override
  void onInit() {
    setTimeForAutoRedirect();
    sendEmailVerification();
    super.onInit();
  }

  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      Get.snackbar("Thông báo",
          "Vui lòng kiểm tra hộp thư đến và xác minh email của bạn");
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  setTimeForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => const VerifySuccessView());
      }
    });
  }

  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() => const VerifySuccessView());
    } else {
      Get.snackbar("Thông báo", "Vui lòng xác nhận email trước khi tiếp tục.");
    }
  }
}
