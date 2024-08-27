import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:food_delivery/view/login/sign_up_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  'assets/images/welcome_top_shape.png',
                  width: media.width,
                ),
                Image.asset(
                  'assets/images/app_logo.png',
                  width: media.width * 0.55,
                  height: media.width * 0.55,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            SizedBox(
              height: media.width * 0.1,
            ),
            Text(
              'Khám phá những món ăn ngon nhất từ nhiều \nnhà hàng khác nhau và giao hàng nhanh \nđến tận nhà bạn',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: TColor.secondaryText,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: media.width * 0.1,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: RoundButton(
                  title: 'Đăng nhập',
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: RoundButton(
                  title: 'Đăng ký tài khoản mới',
                  type: RoundButtonType.textPrimary,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpView()));
                  },
                )),
          ],
        ),
      ),
    );
  }
}
