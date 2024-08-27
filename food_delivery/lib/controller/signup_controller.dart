import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/repositories/authentication_repository.dart';
import 'package:food_delivery/repositories/user_respository.dart';
import 'package:food_delivery/models/user_model.dart';
import 'package:food_delivery/view/login/verify_email_view.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  final _userRepository = Get.put(UserRespository());
  final txtName = TextEditingController();
  final txtMobile = TextEditingController();
  final txtAddress = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  var isSignUp = false.obs;
  void signUp() async {
    isSignUp.value = true;
    User? user = await AuthenticationRepository.instance
        .registerWithEmailAndPassword(txtEmail.text, txtPassword.text);

    isSignUp.value = false;
    if (user != null) {
      final newUser = UserModel(
          id: user.uid,
          name: txtName.text,
          email: txtEmail.text,
          mobile: txtMobile.text,
          isAdmin: false,
          profilePicture: "");
      await _userRepository.saveUserRecord(newUser);
      Get.off(() => VerifyEmailView(email: txtEmail.text));
    }
  }
}
