// ignore_for_file: deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/images/btn_back.png",
                          width: 20, height: 20),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "Về chúng tôi",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                    height: 140,
                    width: 140,
                    child: Image.asset("assets/images/icon.jpg")),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My food là một ứng dụng đặt đồ ăn. Ứng dụng này được xây dựng bằng Framework Flutter, một công nghệ hiện đại giúp phát triển ứng dụng đa nền tảng nhanh chóng và hiệu quả. Ngoài ra, hệ thống còn tích hợp với Firebase để quản lý dữ liệu, lưu trữ thông tin người dùng và đơn hàng một cách an toàn, bảo mật.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Người thực hiện: Từ Minh Hiếu",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Lớp: 71DCTT24",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Mã sinh viên: 71DCTT22065",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Facebook:  ',
                        style: TextStyle(color: TColor.primaryText),
                        children: [
                          TextSpan(
                            text: 'facebook.com/tuhieu2812',
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url =
                                    'https://www.facebook.com/tuhieu2812';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Không thể mở $url';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void sendNotification() async {
//   final String serverKey = 'YOUR_SERVER_KEY';
//   final String url = 'https://fcm.googleapis.com/fcm/send';

//   final Map<String, dynamic> message = {
//     'to': '/topics/your_topic_name',
//     'notification': {
//       'title': 'Hello',
//       'body': 'World!',
//     },
//     'priority': 'high'
//   };

//   final response = await http.post(
//     Uri.parse(url),
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverKey',
//     },
//     body: jsonEncode(message),
//   );

//   if (response.statusCode == 200) {
//     print('Notification sent successfully.');
//   } else {
//     print('Failed to send notification. Status code: ${response.statusCode}');
//   }
// }
