import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/common_widget/round_icon_button.dart';
import 'package:food_delivery/common_widget/round_textfield.dart';
import 'package:food_delivery/common_widget/validation_code.dart';
import 'package:food_delivery/controller/login_controller.dart';
import 'package:food_delivery/view/login/reset_pass_view.dart';
import 'package:food_delivery/view/login/sign_up_view.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool isLogIn = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
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
                      'Đăng nhập',
                      style: TextStyle(
                          fontSize: 30,
                          color: TColor.primaryText,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Điền thông tin để đăng nhập',
                      style: TextStyle(
                          fontSize: 14,
                          color: TColor.secondaryText,
                          fontWeight: FontWeight.w500),
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
                      controller: controller.txtPassword,
                      hintText: 'Mật khẩu',
                      obscureText: true,
                      validator: validatePassword,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            controller.loginWithEmailPassword();
                          }
                        },
                        title: 'Đăng nhập'),
                    const SizedBox(
                      height: 4,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetPassView()));
                      },
                      child: Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                            fontSize: 14,
                            color: TColor.secondaryText,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'hoặc Đăng Nhập bằng ',
                      style: TextStyle(
                          fontSize: 14,
                          color: TColor.secondaryText,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // RoundIconButton(
                    //   onPressed: () {},
                    //   title: "Đăng nhập với Facebook",
                    //   icon: "assets/images/facebook_logo.png",
                    //   color: const Color(0xff367FC0),
                    // ),
                    // const SizedBox(
                    //   height: 25,
                    // ),
                    RoundIconButton(
                      onPressed: () {
                        controller.googleSignIn();
                      },
                      title: "Đăng nhập với Google",
                      icon: "assets/images/google_logo.png",
                      color: const Color(0xffDD4839),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpView()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Không có tài khoản? ',
                            style: TextStyle(
                                fontSize: 14,
                                color: TColor.secondaryText,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Đăng ký',
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
            return controller.isLogIn.value
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
