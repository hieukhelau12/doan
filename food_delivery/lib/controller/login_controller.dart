import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:food_delivery/repositories/user_respository.dart';
import 'package:food_delivery/models/user_model.dart';
import 'package:food_delivery/view/login/verify_email_view.dart';
import 'package:food_delivery/view/main_tabview/main_tabview.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  var isLogIn = false.obs;
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void onInit() {
    txtEmail.text = "tuminhhieu111@gmail.com";
    txtPassword.text = "123456";
    super.onInit();
  }

  void loginWithEmailPassword() async {
    isLogIn.value = true;

    User? user = await AuthenticationRepository.instance
        .logInWithEmailAndPassword(txtEmail.text, txtPassword.text);

    isLogIn.value = false;

    if (user != null && user.emailVerified) {
      Get.offAll(() => const MainTabView());
      Get.snackbar("Thông Báo", "Đăng nhập thành công");
    } else {
      await AuthenticationRepository.instance.sendEmailVerification();
      Get.snackbar("Thông báo",
          "Vui lòng kiểm tra hộp thư đến và xác minh email của bạn");
      Get.to(() => VerifyEmailView(
            email: txtEmail.text,
          ));
    }
  }

  Future<void> googleSignIn() async {
    try {
      isLogIn.value = true;
      final userCredential =
          await AuthenticationRepository.instance.signInWithGoogle();
      final User? user = userCredential!.user;
      final existingUser = await _firestore
          .collection('Users')
          .where('email', isEqualTo: user!.email)
          .get();
      if (existingUser.docs.isEmpty) {
        await saveUserRecord(userCredential);
      }
      isLogIn.value = false;
      Get.snackbar("Thông báo", "Đăng nhập thành công");
      Get.offAll(() => const MainTabView());
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        final user = UserModel(
            id: userCredentials.user!.uid,
            name: userCredentials.user!.displayName ?? "",
            email: userCredentials.user!.email ?? "",
            mobile: userCredentials.user!.phoneNumber ?? "",
            isAdmin: false,
            profilePicture: userCredentials.user!.photoURL ?? "");
        await UserRespository.instance.saveUserRecord(user);
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi $e");
    }
  }
}
