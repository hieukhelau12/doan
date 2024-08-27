// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/common_widget/validation_code.dart';
import 'package:food_delivery/controller/signup_controller.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:get/get.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isSignUp = false;
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignupController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    Text(
                      'Đăng ký',
                      style: TextStyle(
                          fontSize: 30,
                          color: TColor.primaryText,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Điền thông tin để đăng ký',
                      style: TextStyle(
                          fontSize: 14,
                          color: TColor.secondaryText,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextField(
                      controller: controller.txtName,
                      hintText: 'Tên',
                      validator: validateName,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextField(
                      controller: controller.txtEmail,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextField(
                      controller: controller.txtMobile,
                      hintText: 'Số điện thoại',
                      keyboardType: TextInputType.phone,
                      validator: validatePhoneNumber,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextField(
                      controller: controller.txtPassword,
                      hintText: 'Mật khẩu',
                      obscureText: true,
                      validator: validatePassword,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextField(
                        controller: controller.txtConfirmPassword,
                        hintText: 'Xác nhận mật khẩu',
                        obscureText: true,
                        validator: (value) => validateConfirmPassword(
                            value, controller.txtPassword.text)),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            controller.signUp();
                          }
                        },
                        title: 'Đăng ký'),
                    const SizedBox(
                      height: 4,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Đã có tài khoản? ',
                            style: TextStyle(
                                fontSize: 14,
                                color: TColor.secondaryText,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Đăng nhập',
                            style: TextStyle(
                                fontSize: 14,
                                color: TColor.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            return controller.isSignUp.value
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
